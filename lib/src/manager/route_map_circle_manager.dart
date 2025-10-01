import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_user_location_indicator/route_map_user_location_indicator.dart';

class RouteMapCircleManager {
  final MapLibreMapController controller;

  /// Tuple of (accuracyCircle, indicatorCircle)
  (Circle, Circle)? _userLocationCircles;

  RouteMapCircleManager({required this.controller});

  Brightness _brightness = Brightness.light;

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final userLocationCircles = _userLocationCircles;
    if (userLocationCircles == null) return;
    await removeUserLocationIndicator();
    if (controller.isDisposed) return;
    await _addUserLocationCircles(
      userLocationCircles.$1.options,
      userLocationCircles.$2.options,
    );
  }

  Future<void> drawUserLocationIndicator(
    RouteMapUserLocationIndicator indicator,
  ) async {
    final theme =
        _brightness == Brightness.light
            ? indicator.theme
            : indicator.darkTheme ?? indicator.theme;
    final indicatorRadius = 6;
    final indicatorStrokeWidth = 2;
    final indicatorTotalRadius = indicatorRadius + indicatorStrokeWidth;
    final accuracyOptions = CircleOptions(
      circleRadius: indicatorTotalRadius + indicator.accuracyWidth,
      circleColor: theme.color.toHexStringRGB(),
      circleOpacity: 0.35,
      geometry: indicator.location,
      circleBlur: 0.1,
    );
    final indicatorOptions = CircleOptions(
      circleRadius: 6,
      circleColor: theme.color.toHexStringRGB(),
      circleStrokeColor: '#FFFFFF',
      circleStrokeWidth: 2,
      geometry: indicator.location,
      circleBlur: 0.1,
    );

    if (_userLocationCircles == null) {
      await _addUserLocationCircles(accuracyOptions, indicatorOptions);
    } else {
      final accuracyCircleId = _userLocationCircles!.$1;
      final indicatorCircleId = _userLocationCircles!.$2;
      await controller.updateCircle(accuracyCircleId, accuracyOptions);
      if (controller.isDisposed) return;
      await controller.updateCircle(indicatorCircleId, indicatorOptions);
    }
  }

  Future<void> _addUserLocationCircles(
    CircleOptions accuracy,
    CircleOptions indicator,
  ) async {
    final accuracyCircle = await controller.addCircle(accuracy);
    if (controller.isDisposed) return;
    final indicatorCircle = await controller.addCircle(indicator);
    _userLocationCircles = (accuracyCircle, indicatorCircle);
  }

  Future<void> removeUserLocationIndicator() async {
    if (_userLocationCircles == null) return;
    await Future.wait([
      controller.removeCircle(_userLocationCircles!.$1),
      controller.removeCircle(_userLocationCircles!.$2),
    ]);
    _userLocationCircles = null;
  }
}
