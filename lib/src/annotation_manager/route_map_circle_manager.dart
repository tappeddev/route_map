import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

class RouteMapCircleManager {
  final MapLibreMapController controller;
  Brightness _brightness = Brightness.light;
  final _circleMap = <String, _DrawnCircle>{};

  RouteMapCircleManager({required this.controller});

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final circles = _circleMap.values.map((drawnCircle) => drawnCircle.circle);
    final restoredCircles = circles.toList();
    await removeCircles();
    for (final circle in restoredCircles) {
      if (controller.isDisposed) return;
      await drawCircle(circle);
    }
  }

  Future<void> drawCircle(RouteMapCircle mapCircle) async {
    final theme = switch (_brightness) {
      Brightness.dark => mapCircle.darkTheme ?? mapCircle.theme,
      Brightness.light => mapCircle.theme,
    };
    final circleOptions = CircleOptions(
      circleRadius: theme.radius,
      circleColor: theme.color.toHexStringRGB(),
      circleOpacity: theme.opacity ?? theme.color.a,
      circleBlur: theme.blur,
      circleStrokeWidth: theme.strokeWidth,
      circleStrokeColor: theme.strokeColor?.toHexStringRGB(),
      circleStrokeOpacity: theme.strokeOpacity ?? theme.strokeColor?.a,
      geometry: mapCircle.latLng,
      draggable: theme.draggable,
    );

    final drawnCircle = _circleMap[mapCircle.identifier];
    if (drawnCircle == null) {
      final circle = await controller.addCircle(circleOptions);
      _circleMap[mapCircle.identifier] = _DrawnCircle(
        circle: mapCircle,
        annotation: circle,
      );
    } else {
      await controller.updateCircle(drawnCircle.annotation, circleOptions);
      _circleMap[mapCircle.identifier] = _DrawnCircle(
        circle: mapCircle,
        annotation: drawnCircle.annotation,
      );
    }
  }

  Future<void> removeCircle({required String identifier}) async {
    final drawnCircle = _circleMap.remove(identifier);
    if (drawnCircle == null) return;
    await controller.removeCircle(drawnCircle.annotation);
  }

  Future<void> removeCircles() async {
    if (controller.circles.isEmpty) {
      _circleMap.clear();
      return;
    }

    await controller.removeCircles(controller.circles);
    _circleMap.clear();
  }
}

class _DrawnCircle {
  final RouteMapCircle circle;
  final Circle annotation;

  const _DrawnCircle({required this.circle, required this.annotation});
}
