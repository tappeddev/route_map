import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:route_map/src/utils/coalescing_runner.dart';

void main() {
  group('CoalescingRunner', () {
    test('runs the task immediately when idle', () async {
      var calls = 0;
      final runner = CoalescingRunner(() async => calls++);

      await runner.schedule();

      expect(calls, 1);
    });

    test('isRunning is true while in flight and false once finished', () async {
      final gate = Completer<void>();
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() => gate.future);

      expect(runner.isRunning, isFalse);

      final first = runner.schedule();
      expect(runner.isRunning, isTrue);

      gate.complete();
      await first;
      expect(runner.isRunning, isFalse);
    });

    test('each schedule runs again once the runner is idle', () async {
      var calls = 0;
      final runner = CoalescingRunner(() async => calls++);

      await runner.schedule();
      await runner.schedule();

      expect(calls, 2);
    });

    test('coalesces overlapping schedules into a single rerun', () async {
      var calls = 0;
      final gates = <Completer<void>>[];
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() {
        calls++;
        final gate = Completer<void>();
        gates.add(gate);
        return gate.future;
      });

      // Start run #1.
      final first = runner.schedule();
      expect(calls, 1);

      // Several fires arrive while run #1 is still in flight.
      unawaited(runner.schedule());
      unawaited(runner.schedule());
      unawaited(runner.schedule());
      // None of them start a concurrent run.
      expect(calls, 1);

      // Finishing run #1 folds all pending fires into exactly one rerun.
      gates[0].complete();
      await pumpEventQueue();
      expect(calls, 2);

      // Finishing the rerun leaves no further work.
      gates[1].complete();
      await first;
      expect(calls, 2);
    });

    test('never runs two tasks concurrently', () async {
      var active = 0;
      var maxActive = 0;
      final gates = <Completer<void>>[];
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() {
        active++;
        maxActive = active > maxActive ? active : maxActive;
        final gate = Completer<void>();
        gates.add(gate);
        return gate.future.whenComplete(() => active--);
      });

      final first = runner.schedule();
      unawaited(runner.schedule());
      unawaited(runner.schedule());

      gates[0].complete();
      await pumpEventQueue();
      gates[1].complete();
      await first;

      expect(maxActive, 1);
    });

    test('the coalesced rerun observes the latest external state', () async {
      final observed = <int>[];
      var external = 0;
      final gates = <Completer<void>>[];
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() {
        observed.add(external);
        final gate = Completer<void>();
        gates.add(gate);
        return gate.future;
      });

      external = 1;
      final first = runner.schedule(); // run #1 observes 1
      external = 2;
      unawaited(runner.schedule()); // requests a rerun
      external = 3; // state keeps changing before run #1 completes

      gates[0].complete(); // rerun starts and should observe the newest value
      await pumpEventQueue();
      gates[1].complete();
      await first;

      // Only two runs, and the rerun skipped the intermediate value (2).
      expect(observed, [1, 3]);
    });

    test('a schedule during the rerun triggers a further rerun', () async {
      var calls = 0;
      final gates = <Completer<void>>[];
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() {
        calls++;
        final gate = Completer<void>();
        gates.add(gate);
        return gate.future;
      });

      final first = runner.schedule(); // run #1
      unawaited(runner.schedule()); // -> rerun (run #2) pending

      gates[0].complete();
      await pumpEventQueue();
      expect(calls, 2); // run #2 in flight

      unawaited(runner.schedule()); // -> rerun (run #3) pending
      gates[1].complete();
      await pumpEventQueue();
      expect(calls, 3); // run #3 in flight

      gates[2].complete();
      await first;
      expect(calls, 3);
    });

    test('shouldRerun == false suppresses the pending rerun', () async {
      var calls = 0;
      final gates = <Completer<void>>[];
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() {
        calls++;
        final gate = Completer<void>();
        gates.add(gate);
        return gate.future;
      }, shouldRerun: () => false);

      final first = runner.schedule();
      unawaited(runner.schedule()); // requests a rerun that must be aborted

      gates[0].complete();
      await first;

      // Initial run still happened; the rerun was suppressed by the guard.
      expect(calls, 1);
    });

    test('shouldRerun == true allows the pending rerun', () async {
      var calls = 0;
      final gates = <Completer<void>>[];
      late final CoalescingRunner runner;
      runner = CoalescingRunner(() {
        calls++;
        final gate = Completer<void>();
        gates.add(gate);
        return gate.future;
      }, shouldRerun: () => true);

      final first = runner.schedule();
      unawaited(runner.schedule());

      gates[0].complete();
      await pumpEventQueue();
      expect(calls, 2);

      gates[1].complete();
      await first;
      expect(calls, 2);
    });

    test(
      'shouldRerun is only consulted for reruns, not the first run',
      () async {
        var calls = 0;
        var shouldRerunCallCount = 0;
        final runner = CoalescingRunner(
          () async {
            calls++;
          },
          shouldRerun: () {
            shouldRerunCallCount++;
            return true;
          },
        );

        // A lone schedule finishes before any other fire arrives, so there is
        // no pending rerun and the guard is never consulted.
        await runner.schedule();

        expect(calls, 1);
        expect(shouldRerunCallCount, 0);
      },
    );

    test('recovers after the task throws so it can run again', () async {
      var calls = 0;
      var shouldThrow = true;
      final runner = CoalescingRunner(() async {
        calls++;
        if (shouldThrow) throw StateError('boom');
      });

      // Swallow the failure so the test can assert on recovery. (The `finally`
      // block is what guarantees the runner is left in a usable state.)
      await runner.schedule().catchError((Object _) {});
      expect(
        runner.isRunning,
        isFalse,
        reason: 'the finally block must reset _isRunning even on error',
      );

      shouldThrow = false;
      await runner.schedule();
      expect(
        calls,
        2,
        reason: 'the runner must be schedulable again after a failed run',
      );
    });
  });
}
