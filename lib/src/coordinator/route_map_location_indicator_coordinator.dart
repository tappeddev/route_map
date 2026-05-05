import 'dart:ui';

import 'package:route_map/route_map.dart';
import 'package:route_map/src/annotation_manager/route_map_circle_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_icon_manager.dart';

class RouteMapLocationIndicatorCoordinator {
  static const _accuracyCircleIdentifier =
      'route_map_user_location_indicator_accuracy_circle';
  static const _centerCircleIdentifier =
      'route_map_user_location_indicator_center_circle';
  static const _userLocationIconIdentifier =
      'route_map_user_location_indicator_icon';

  final RouteMapCircleManager _circleManager;
  final RouteMapIconManager _iconManager;

  RouteMapLocationIndicatorCoordinator({
    required RouteMapCircleManager circleManager,
    required RouteMapIconManager iconManager,
  }) : _circleManager = circleManager,
       _iconManager = iconManager;

  Future<void> drawUserLocationIndicator(
    RouteMapUserLocationIndicator indicator,
  ) async {
    const indicatorRadius = 6.0;
    const indicatorStrokeWidth = 2.0;
    const indicatorTotalRadius = indicatorRadius + indicatorStrokeWidth;

    await _circleManager.drawCircle(
      RouteMapCircle(
        identifier: _accuracyCircleIdentifier,
        latLng: indicator.location,
        theme: RouteMapCircleTheme(
          radius: indicatorTotalRadius + indicator.accuracyWidth,
          color: indicator.theme.color,
          opacity: 0.35,
          blur: 0.1,
        ),
        darkTheme: indicator.darkTheme == null
            ? null
            : RouteMapCircleTheme(
                radius: indicatorTotalRadius + indicator.accuracyWidth,
                color: indicator.darkTheme!.color,
                opacity: 0.35,
                blur: 0.1,
              ),
      ),
    );

    final icon = indicator.icon;
    if (icon == null) {
      await _circleManager.drawCircle(
        RouteMapCircle(
          identifier: _centerCircleIdentifier,
          latLng: indicator.location,
          theme: RouteMapCircleTheme(
            radius: indicatorRadius,
            color: indicator.theme.color,
            strokeColor: const Color(0xFFFFFFFF),
            strokeWidth: indicatorStrokeWidth,
            blur: 0.1,
          ),
          darkTheme: indicator.darkTheme == null
              ? null
              : RouteMapCircleTheme(
                  radius: indicatorRadius,
                  color: indicator.darkTheme!.color,
                  strokeColor: const Color(0xFFFFFFFF),
                  strokeWidth: indicatorStrokeWidth,
                  blur: 0.1,
                ),
        ),
      );
      await _iconManager.removeIcon(identifier: _userLocationIconIdentifier);
    } else {
      await _circleManager.removeCircle(identifier: _centerCircleIdentifier);
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
  }

  Future<void> removeUserLocationIndicator() async {
    await Future.wait([
      _circleManager.removeCircle(identifier: _accuracyCircleIdentifier),
      _circleManager.removeCircle(identifier: _centerCircleIdentifier),
      _iconManager.removeIcon(identifier: _userLocationIconIdentifier),
    ]);
  }
}
