import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_user_location_indicator/route_map_user_location_indicator.dart';

class RouteMapCircleManager {
  final MapLibreMapController controller;

  /// Tuple of (accuracyCircle, indicatorCircle)
  (Circle, Circle)? _userLocationCircles;
  RouteMapUserLocationIndicator? _previousIndicator;

  RouteMapCircleManager({required this.controller});

  Brightness _brightness = Brightness.light;

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final previousIndicator = _previousIndicator;
    if (previousIndicator == null) return;
    await removeUserLocationIndicator();
    if (controller.isDisposed) return;
    await drawUserLocationIndicator(previousIndicator);
  }

  Future<void> drawUserLocationIndicator(
    RouteMapUserLocationIndicator indicator,
  ) async {
    final theme = switch (_brightness) {
      Brightness.dark => indicator.darkTheme ?? indicator.theme,
      Brightness.light => indicator.theme,
    };
    const indicatorRadius = 6.0;
    const indicatorStrokeWidth = 2.0;
    const indicatorTotalRadius = indicatorRadius + indicatorStrokeWidth;
    final accuracyOptions = CircleOptions(
      circleRadius: indicatorTotalRadius + indicator.accuracyWidth,
      circleColor: theme.color.toHexStringRGB(),
      circleOpacity: 0.35,
      geometry: indicator.location,
      circleBlur: 0.1,
    );
    final indicatorOptions = CircleOptions(
      circleRadius: indicatorRadius,
      circleColor: theme.color.toHexStringRGB(),
      circleStrokeColor: '#FFFFFF',
      circleStrokeWidth: indicatorStrokeWidth,
      geometry: indicator.location,
      circleBlur: 0.1,
    );

    if (_previousIndicator == null) {
      final accuracyCircle = await controller.addCircle(accuracyOptions);
      if (controller.isDisposed) return;
      final indicatorCircle = await controller.addCircle(indicatorOptions);
      _userLocationCircles = (accuracyCircle, indicatorCircle);
    } else {
      final accuracyCircle = _userLocationCircles!.$1;
      final indicatorCircle = _userLocationCircles!.$2;
      await controller.updateCircle(accuracyCircle, accuracyOptions);
      if (controller.isDisposed) return;
      await controller.updateCircle(indicatorCircle, indicatorOptions);
    }

    _previousIndicator = indicator;
  }

  Future<void> removeUserLocationIndicator() async {
    if (_previousIndicator == null) return;
    await Future.wait([
      controller.removeCircle(_userLocationCircles!.$1),
      controller.removeCircle(_userLocationCircles!.$2),
    ]);
    _userLocationCircles = null;
    _previousIndicator = null;
  }
}
