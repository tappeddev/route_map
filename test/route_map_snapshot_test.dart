import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

void main() {
  late _SnapshotPlatform platform;

  setUp(() {
    platform = _SnapshotPlatform();
    final previousFactory = MapLibrePlatform.createInstance;
    MapLibrePlatform.createInstance = () => platform;
    addTearDown(() => MapLibrePlatform.createInstance = previousFactory);
  });

  Future<RouteMapController> pumpMap(
    WidgetTester tester, {
    bool createNativeController = true,
  }) async {
    final controller = RouteMapController();
    await tester.pumpWidget(
      MaterialApp(
        home: RouteMap(
          controller: controller,
          initialCameraPosition: const CameraPosition(target: LatLng(52, 13)),
          onMapClicked: (_, _) {},
          zoomPadding: EdgeInsets.zero,
          locale: 'en',
          styleUrl: '{}',
        ),
      ),
    );
    if (!createNativeController) return controller;
    final map = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    final nativeController = MapLibreMapController(
      maplibrePlatform: platform,
      annotationOrder: const [],
      annotationConsumeTapEvents: const [],
    );
    addTearDown(nativeController.dispose);
    map.onMapCreated!(nativeController);
    return controller;
  }

  testWidgets('snapshot fails if disposed before the native map is created', (
    tester,
  ) async {
    final controller = await pumpMap(tester, createNativeController: false);
    final expectation = expectLater(
      controller.takeSnapshot(),
      throwsStateError,
    );
    await tester.pump();
    expect(platform.captureCount, 0);
    await tester.pumpWidget(const SizedBox());
    await expectation;
    expect(platform.captureCount, 0);
  });

  testWidgets('snapshot fails without calling native code after disposal', (
    tester,
  ) async {
    final controller = await pumpMap(tester);
    await tester.pumpWidget(const SizedBox());
    await expectLater(controller.takeSnapshot(), throwsStateError);
    expect(platform.captureCount, 0);
  });

  testWidgets('snapshot returns the bytes captured by the native renderer', (
    tester,
  ) async {
    final controller = await pumpMap(tester);
    final png = Uint8List.fromList([137, 80, 78, 71]);
    final expectation = expectLater(
      controller.takeSnapshot(),
      completion(same(png)),
    );
    await tester.pump();
    platform.snapshot.complete(png);
    await tester.pump();
    await expectation;
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('snapshot propagates native capture failures', (tester) async {
    final controller = await pumpMap(tester);
    final error = PlatformException(code: 'SNAPSHOT_ERROR');
    final expectation = expectLater(
      controller.takeSnapshot(),
      throwsA(same(error)),
    );
    await tester.pump();
    platform.snapshot.completeError(error);
    await tester.pump();
    await expectation;
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'a stalled native capture times out and tolerates late completion',
    (tester) async {
      final controller = await pumpMap(tester);
      final expectation = expectLater(
        controller.takeSnapshot(timeout: const Duration(milliseconds: 100)),
        throwsA(isA<TimeoutException>()),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await expectation;
      platform.snapshot.complete(Uint8List(0));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}

class _SnapshotPlatform extends MapLibrePlatform {
  late final snapshot = Completer<Uint8List>();
  int captureCount = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Widget buildView(
    Map<String, dynamic> creationParams,
    OnPlatformViewCreatedCallback onPlatformViewCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  ) => const SizedBox();

  @override
  Future<Uint8List> takeSnapshot({int? width, int? height}) {
    captureCount++;
    return snapshot.future;
  }
}
