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
  }) = _RouteMapUserLocationIndicator;
}

@freezed
abstract class RouteMapUserLocationIndicatorTheme
    with _$RouteMapUserLocationIndicatorTheme {
  const factory RouteMapUserLocationIndicatorTheme({required Color color}) =
      _RouteMapUserLocationIndicatorTheme;
}
