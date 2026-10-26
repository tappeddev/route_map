import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

void main() {
  late _LocationPlatform platform;

  setUp(() {
    platform = _LocationPlatform();
    final previousFactory = MapLibrePlatform.createInstance;
    MapLibrePlatform.createInstance = () => platform;
    addTearDown(() => MapLibrePlatform.createInstance = previousFactory);
  });

  Future<RouteMapController> pumpMap(
    WidgetTester tester, {
    ManualLocationUpdate? location,
    RouteMapController? controller,
    void Function(CameraPosition)? onCameraMove,
    void Function(MyLocationTrackingMode)? onCameraTrackingChanged,
    VoidCallback? onCameraTrackingDismissed,
    MyLocationTrackingMode myLocationTrackingMode = MyLocationTrackingMode.none,
    MyLocationRenderMode myLocationRenderMode = MyLocationRenderMode.normal,
  }) async {
    controller ??= RouteMapController();
    await tester.pumpWidget(
      MaterialApp(
        home: RouteMap(
          controller: controller,
          initialCameraPosition: const CameraPosition(target: LatLng(52, 13)),
          onMapClicked: (_, _) {},
          zoomPadding: EdgeInsets.zero,
          locale: 'en',
          styleUrl: '{}',
          location: location,
          onCameraMove: onCameraMove,
          onCameraTrackingChanged: onCameraTrackingChanged,
          onCameraTrackingDismissed: onCameraTrackingDismissed,
          myLocationTrackingMode: myLocationTrackingMode,
          myLocationRenderMode: myLocationRenderMode,
        ),
      ),
    );
    return controller;
  }

  MapLibreMap createNativeController(WidgetTester tester) {
    final map = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    final nativeController = MapLibreMapController(
      maplibrePlatform: platform,
      annotationOrder: const [],
      annotationConsumeTapEvents: const [],
    );
    addTearDown(nativeController.dispose);
    map.onMapCreated!(nativeController);
    return map;
  }

  testWidgets(
    'declarative fixes enable display and apply only the latest fix after loading',
    (tester) async {
      const initial = ManualLocationUpdate(target: LatLng(52, 13));
      final latest = ManualLocationUpdate(
        target: const LatLng(53, 14),
        horizontalAccuracy: 5,
        verticalAccuracy: 3,
        altitude: 42,
        bearing: 90,
        speed: 12,
        timestamp: DateTime.utc(2026, 10, 22),
      );
      final controller = await pumpMap(tester, location: initial);
      final map = createNativeController(tester);
      expect(map.myLocationEnabled, isTrue);
      expect(map.locationSource, isA<ManualLocationSource>());
      await pumpMap(tester, controller: controller, location: latest);
      expect(platform.locations, isEmpty);

      map.onStyleLoadedCallback!();
      await tester.pumpAndSettle();
      expect(platform.locations, [latest]);

      // An unrelated rebuild does not replay the same fix.
      await pumpMap(tester, controller: controller, location: latest);
      await tester.pumpAndSettle();
      expect(platform.locations, [latest]);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'location can arrive after loading and null hides the indicator',
    (tester) async {
      final controller = await pumpMap(tester);
      final map = createNativeController(tester);
      expect(map.myLocationEnabled, isFalse);
      map.onStyleLoadedCallback!();
      await tester.pumpAndSettle();

      const fix = ManualLocationUpdate(target: LatLng(52, 13));
      await pumpMap(tester, controller: controller, location: fix);
      await tester.pumpAndSettle();
      expect(platform.locations, [fix]);
      expect(
        tester.widget<MapLibreMap>(find.byType(MapLibreMap)).myLocationEnabled,
        isTrue,
      );

      await pumpMap(tester, controller: controller);
      await tester.pumpAndSettle();
      expect(
        tester.widget<MapLibreMap>(find.byType(MapLibreMap)).myLocationEnabled,
        isFalse,
      );
      expect(platform.locations, [fix]);

      await pumpMap(tester, controller: controller, location: fix);
      await tester.pumpAndSettle();
      expect(platform.locations, [fix, fix]);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('clearing a location and resuming forwards the latest fix', (
    tester,
  ) async {
    const initial = ManualLocationUpdate(target: LatLng(52, 13));
    const latest = ManualLocationUpdate(target: LatLng(53, 14));
    final controller = await pumpMap(tester, location: initial);
    final map = createNativeController(tester);
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();

    await pumpMap(tester, controller: controller);
    await tester.pumpAndSettle();
    expect(platform.locations, [initial]);
    expect(
      tester.widget<MapLibreMap>(find.byType(MapLibreMap)).myLocationEnabled,
      isFalse,
    );

    await pumpMap(tester, controller: controller, location: latest);
    await tester.pumpAndSettle();
    expect(platform.locations, [initial, latest]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('style reloads restore the declarative fix', (tester) async {
    const fix = ManualLocationUpdate(target: LatLng(52, 13));
    await pumpMap(tester, location: fix);
    final map = createNativeController(tester);
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    expect(platform.locations, [fix, fix]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a declarative fix removed before readiness is not forwarded', (
    tester,
  ) async {
    const fix = ManualLocationUpdate(target: LatLng(52, 13));
    final controller = await pumpMap(tester, location: fix);
    final map = createNativeController(tester);
    await pumpMap(tester, controller: controller);
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    expect(platform.locations, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'declarative fixes are discarded when disposed before readiness',
    (tester) async {
      await pumpMap(
        tester,
        location: const ManualLocationUpdate(target: LatLng(52, 13)),
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      expect(platform.locations, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'in-flight updates are serialized and coalesce to the latest fix',
    (tester) async {
      const first = ManualLocationUpdate(target: LatLng(52, 13));
      const intermediate = ManualLocationUpdate(target: LatLng(53, 14));
      const latest = ManualLocationUpdate(target: LatLng(54, 15));
      platform.locationGate = Completer<void>();
      final controller = await pumpMap(tester, location: first);
      final map = createNativeController(tester);
      map.onStyleLoadedCallback!();
      await tester.pumpAndSettle();
      expect(platform.locations, [first]);

      await pumpMap(tester, controller: controller, location: intermediate);
      await pumpMap(tester, controller: controller, location: latest);
      expect(platform.locations, [first]);

      platform.locationGate!.complete();
      await tester.pumpAndSettle();
      expect(platform.locations, [first, latest]);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('a failed send still forwards a queued newer fix', (
    tester,
  ) async {
    const first = ManualLocationUpdate(target: LatLng(52, 13));
    const latest = ManualLocationUpdate(target: LatLng(53, 14));
    final gate = platform.locationGate = Completer<void>();
    final controller = await pumpMap(tester, location: first);
    final map = createNativeController(tester);
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    await pumpMap(tester, controller: controller, location: latest);

    platform.locationGate = null;
    final error = StateError('native location update failed');
    gate.completeError(error);
    await tester.pumpAndSettle();
    expect(tester.takeException(), same(error));
    expect(platform.locations, [first, latest]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a style reload during a send still restores the same fix', (
    tester,
  ) async {
    const fix = ManualLocationUpdate(target: LatLng(52, 13));
    final gate = platform.locationGate = Completer<void>();
    await pumpMap(tester, location: fix);
    final map = createNativeController(tester);
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    expect(platform.locations, [fix]);

    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    platform.locationGate = null;
    gate.complete();
    await tester.pumpAndSettle();
    expect(platform.locations, [fix, fix]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('hide and re-enable during a send reapplies the same fix', (
    tester,
  ) async {
    const fix = ManualLocationUpdate(target: LatLng(52, 13));
    final gate = platform.locationGate = Completer<void>();
    final controller = await pumpMap(tester, location: fix);
    final map = createNativeController(tester);
    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();

    await pumpMap(tester, controller: controller);
    await pumpMap(tester, controller: controller, location: fix);
    platform.locationGate = null;
    gate.complete();
    await tester.pumpAndSettle();
    expect(platform.locations, [fix, fix]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('manual display selects the upstream manual location source', (
    tester,
  ) async {
    await pumpMap(
      tester,
      location: const ManualLocationUpdate(target: LatLng(52, 13)),
    );
    final map = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    expect(map.myLocationEnabled, isTrue);
    expect(map.locationSource, isA<ManualLocationSource>());

    await tester.pumpWidget(const SizedBox());
    await pumpMap(tester);
    final disabledMap = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    expect(disabledMap.myLocationEnabled, isFalse);
    expect(disabledMap.locationSource, isA<ManualLocationSource>());
  });

  testWidgets('location modes apply only while a location is shown', (
    tester,
  ) async {
    final controller = await pumpMap(
      tester,
      myLocationTrackingMode: MyLocationTrackingMode.tracking,
      myLocationRenderMode: MyLocationRenderMode.compass,
    );
    final hiddenMap = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    expect(hiddenMap.myLocationTrackingMode, MyLocationTrackingMode.none);
    expect(hiddenMap.myLocationRenderMode, MyLocationRenderMode.normal);

    await pumpMap(
      tester,
      controller: controller,
      location: const ManualLocationUpdate(target: LatLng(52, 13)),
      myLocationTrackingMode: MyLocationTrackingMode.tracking,
      myLocationRenderMode: MyLocationRenderMode.compass,
    );
    final shownMap = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    expect(shownMap.myLocationTrackingMode, MyLocationTrackingMode.tracking);
    expect(shownMap.myLocationRenderMode, MyLocationRenderMode.compass);
  });

  testWidgets('native events use the current callbacks after a rebuild', (
    tester,
  ) async {
    final controller = await pumpMap(tester);
    // Native controllers retain the callbacks supplied at map creation.
    final initialMap = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    final positions = <CameraPosition>[];
    final modes = <MyLocationTrackingMode>[];
    var dismissed = false;
    await pumpMap(
      tester,
      controller: controller,
      onCameraMove: positions.add,
      onCameraTrackingChanged: modes.add,
      onCameraTrackingDismissed: () => dismissed = true,
    );

    const position = CameraPosition(target: LatLng(53, 14));
    initialMap.onCameraMove!(position);
    initialMap.onCameraTrackingChanged!(MyLocationTrackingMode.none);
    initialMap.onCameraTrackingDismissed!();

    expect(positions, [position]);
    expect(modes, [MyLocationTrackingMode.none]);
    expect(dismissed, isTrue);
  });

  testWidgets('location fixes wait for style readiness and preserve metadata', (
    tester,
  ) async {
    final timestamp = DateTime.utc(2026, 10, 20);
    await pumpMap(
      tester,
      location: ManualLocationUpdate(
        target: const LatLng(52.5, 13.5),
        horizontalAccuracy: 5,
        verticalAccuracy: 3,
        altitude: 42,
        bearing: 90,
        speed: 12,
        timestamp: timestamp,
      ),
    );
    final map = createNativeController(tester);
    await tester.pump();
    expect(platform.locations, isEmpty);

    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();

    expect(platform.locations.single.toMap(), {
      'position': [52.5, 13.5],
      'horizontalAccuracy': 5.0,
      'verticalAccuracy': 3.0,
      'altitude': 42.0,
      'bearing': 90.0,
      'speed': 12.0,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });
    await tester.pumpWidget(const SizedBox());
  });
}

class _LocationPlatform extends MapLibrePlatform {
  final locations = <ManualLocationUpdate>[];
  Completer<void>? locationGate;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Widget buildView(
    Map<String, dynamic> creationParams,
    OnPlatformViewCreatedCallback onPlatformViewCreated,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  ) => const SizedBox();

  @override
  Future<void> setMapLanguage(String language) async {}

  @override
  Future<void> setManualLocation(ManualLocationUpdate update) async {
    locations.add(update);
    await locationGate?.future;
  }
}
