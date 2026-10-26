import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

void main() {
  late _FakePlatform platform;

  setUp(() {
    platform = _FakePlatform();
    final previousFactory = MapLibrePlatform.createInstance;
    MapLibrePlatform.createInstance = () => platform;
    addTearDown(() => MapLibrePlatform.createInstance = previousFactory);
  });

  Future<RouteMapController> pumpMap(WidgetTester tester) async {
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
    return controller;
  }

  void createNativeController(WidgetTester tester) {
    final map = tester.widget<MapLibreMap>(find.byType(MapLibreMap));
    final nativeController = MapLibreMapController(
      maplibrePlatform: platform,
      annotationOrder: const [],
      annotationConsumeTapEvents: const [],
    );
    addTearDown(nativeController.dispose);
    map.onMapCreated!(nativeController);
  }

  // Calls that wait for the style to load.
  List<Future<void>> callStyleMethods(RouteMapController controller) => [
    controller.removeRoutes(),
    controller.removeIcons(),
    controller.removeCircles(),
    controller.removeAreas(),
  ];

  // Calls that only wait for the native map to be created.
  List<Future<Object?>> callMapMethods(RouteMapController controller) => [
    controller.getCameraPosition(),
    controller.animateCameraTo(points: const [LatLng(52, 13)]),
  ];

  testWidgets(
    'calls waiting for the style complete when disposed before it loads',
    (tester) async {
      final controller = await pumpMap(tester);
      createNativeController(tester);
      final calls = callStyleMethods(controller);

      var completed = false;
      unawaited(Future.wait(calls).then((_) => completed = true));

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'calls waiting for the map complete when disposed before it is created',
    (tester) async {
      final controller = await pumpMap(tester);
      final calls = [
        ...callStyleMethods(controller),
        ...callMapMethods(controller),
      ];

      var completed = false;
      unawaited(Future.wait(calls).then((_) => completed = true));

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}

class _FakePlatform extends MapLibrePlatform {
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
}
