import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_map/route_map.dart';

part 'route_map_user_location_indicator.freezed.dart';

@freezed
abstract class RouteMapUserLocationIndicator
    with _$RouteMapUserLocationIndicator {
  const factory RouteMapUserLocationIndicator({
    required LatLng location,
    required double accuracyWidth,
    required RouteMapUserLocationIndicatorTheme theme,
    RouteMapUserLocationIndicatorTheme? darkTheme,
    RouteMapUserLocationIndicatorIcon? icon,
    double? headingDegrees,
  }) = _RouteMapUserLocationIndicator;
}

@freezed
abstract class RouteMapUserLocationIndicatorIcon
    with _$RouteMapUserLocationIndicatorIcon {
  @Assert(
    'svgIconPath == null || text == null',
    'Either svgIcon or text must be provided, not both.',
  )
  const factory RouteMapUserLocationIndicatorIcon({
    required Path markerPath,
    required RouteMapIconTheme theme,
    RouteMapIconTheme? darkTheme,
    String? svgIconPath,
    String? text,
    @Default(RouteMapIconAnchor.center) RouteMapIconAnchor anchor,
  }) = _RouteMapUserLocationIndicatorIcon;
}

@freezed
abstract class RouteMapUserLocationIndicatorTheme
    with _$RouteMapUserLocationIndicatorTheme {
  const factory RouteMapUserLocationIndicatorTheme({required Color color}) =
      _RouteMapUserLocationIndicatorTheme;
}
