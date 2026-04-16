import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';
import 'package:route_map/src/manager/route_map_circle_manager.dart';
import 'package:route_map/src/manager/route_map_icon_manager.dart';

class RouteMapLocationIndicatorManager {
  static const _userLocationIconIdentifier =
      '__route_map_user_location_indicator_icon__';

  final MapLibreMapController controller;
  final RouteMapCircleManager _circleManager;
  final RouteMapIconManager _iconManager;

  RouteMapUserLocationIndicator? _previousIndicator;
  Brightness _brightness = Brightness.light;

  RouteMapLocationIndicatorManager({required this.controller})
    : _circleManager = RouteMapCircleManager(controller: controller),
      _iconManager = RouteMapIconManager(controller: controller);

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final previousIndicator = _previousIndicator;
    await removeUserLocationIndicator();
    await _iconManager.restore(brightness);
    if (previousIndicator == null || controller.isDisposed) return;
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
    final centerIndicatorOptions = indicator.icon == null
        ? CircleOptions(
            circleRadius: indicatorRadius,
            circleColor: theme.color.toHexStringRGB(),
            circleStrokeColor: '#FFFFFF',
            circleStrokeWidth: indicatorStrokeWidth,
            geometry: indicator.location,
            circleBlur: 0.1,
          )
        : null;

    await _circleManager.drawUserLocationCircles(
      accuracyOptions: accuracyOptions,
      indicatorOptions: centerIndicatorOptions,
    );
    if (controller.isDisposed) return;

    final icon = indicator.icon;
    if (icon == null) {
      await _iconManager.removeIcon(identifier: _userLocationIconIdentifier);
    } else {
      await _iconManager.drawIcon(
        RouteMapIcon(
          identifier: _userLocationIconIdentifier,
          markerPath: icon.markerPath,
          latLng: indicator.location,
          theme: icon.theme,
          darkTheme: icon.darkTheme,
          svgIconPath: icon.svgIconPath,
          text: icon.text,
          rotationDegrees: indicator.headingDegrees,
          anchor: icon.anchor,
        ),
      );
    }

    _previousIndicator = indicator;
  }

  Future<void> removeUserLocationIndicator() async {
    await Future.wait([
      _circleManager.removeUserLocationCircles(),
      _iconManager.removeIcon(identifier: _userLocationIconIdentifier),
    ]);
    _previousIndicator = null;
  }
}
