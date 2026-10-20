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
    bool enableManualLocationDisplay = true,
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
          enableManualLocationDisplay: enableManualLocationDisplay,
        ),
      ),
    );
    return controller;
  }

  testWidgets('manual display selects the upstream manual location source', (
    tester,
  ) async {
    await pumpMap(tester);
    final map = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    expect(map.myLocationEnabled, isTrue);
    expect(map.locationSource, isA<ManualLocationSource>());

    await tester.pumpWidget(const SizedBox());
    await pumpMap(tester, enableManualLocationDisplay: false);
    final disabledMap = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    expect(disabledMap.myLocationEnabled, isFalse);
    expect(disabledMap.locationSource, isA<PlatformLocationSource>());
  });

  testWidgets('location fixes wait for style readiness and preserve metadata', (
    tester,
  ) async {
    final controller = await pumpMap(tester);
    final map = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    final nativeController = MapLibreMapController(
      maplibrePlatform: platform,
      annotationOrder: const [],
      annotationConsumeTapEvents: const [],
    );
    addTearDown(nativeController.dispose);
    map.onMapCreated!(nativeController);

    final timestamp = DateTime.utc(2026, 10, 20);
    final pendingUpdate = controller.updateManualLocation(
      location: const LatLng(52.5, 13.5),
      horizontalAccuracy: 5,
      verticalAccuracy: 3,
      altitude: 42,
      bearing: 90,
      speed: 12,
      timestamp: timestamp,
    );
    await tester.pump();
    expect(platform.locations, isEmpty);

    map.onStyleLoadedCallback!();
    await tester.pumpAndSettle();
    await pendingUpdate;

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
  }
}
