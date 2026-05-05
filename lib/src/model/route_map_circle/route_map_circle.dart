import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_map/route_map.dart';

part 'route_map_circle.freezed.dart';

@freezed
abstract class RouteMapCircle with _$RouteMapCircle {
  const factory RouteMapCircle({
    required String identifier,
    required LatLng latLng,
    required RouteMapCircleTheme theme,
    RouteMapCircleTheme? darkTheme,
  }) = _RouteMapCircle;
}

@freezed
abstract class RouteMapCircleTheme with _$RouteMapCircleTheme {
  const factory RouteMapCircleTheme({
    required double radius,
    required Color color,
    double? opacity,
    double? blur,
    double? strokeWidth,
    Color? strokeColor,
    double? strokeOpacity,
    @Default(false) bool draggable,
  }) = _RouteMapCircleTheme;
}
