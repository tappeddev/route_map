import 'dart:async';

/// Runs an async task and coalesces overlapping schedule requests.
///
/// * If the runner is idle, [schedule] immediately starts the task.
/// * If the runner is already running, [schedule] just flags a rerun
///   and returns — it never spawns a second concurrent execution.
/// * Any number of [schedule] calls while a task is in flight collapse
///   into a single extra run once the current one finishes.
///
/// Useful for reacting to callbacks that may fire faster than the task
/// takes to complete (e.g. MapLibre's `onStyleLoadedCallback`), when
/// running the task twice concurrently would race shared state but
/// missing a late fire would leave the app out of sync.
class CoalescingRunner {
  final Future<void> Function() _task;
  final bool Function()? _shouldRerun;

  bool _isRunning = false;
  bool _rerunPending = false;

  /// [task] is the work to run. [shouldRerun] is an optional guard
  /// consulted before every rerun (e.g. `() => mounted`) — return
  /// `false` to abort the pending rerun.
  CoalescingRunner(this._task, {bool Function()? shouldRerun})
    : _shouldRerun = shouldRerun;

  bool get isRunning => _isRunning;

  /// Schedules the task. Safe to call from anywhere (including from
  /// synchronous callbacks) — the returned future never throws and
  /// completes when either the current run (or its rerun, if this
  /// call triggered one) is done.
  Future<void> schedule() async {
    if (_isRunning) {
      _rerunPending = true;
      return;
    }
    _isRunning = true;
    try {
      do {
        _rerunPending = false;
        await _task();
      } while (_rerunPending && (_shouldRerun?.call() ?? true));
    } finally {
      _isRunning = false;
    }
  }
}
