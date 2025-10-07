import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

part 'route_map_route.freezed.dart';

@freezed
abstract class RouteMapRoute with _$RouteMapRoute {
  const factory RouteMapRoute({
    required String identifier,
    required List<LatLng> points,
    required RouteMapRouteTheme theme,
    RouteMapRouteTheme? darkTheme,
  }) = _RouteMapRoute;
}

@freezed
abstract class RouteMapRouteTheme with _$RouteMapRouteTheme {
  const factory RouteMapRouteTheme({
    required double lineWidth,
    required Color color,
    double? backLineWidth,
    Color? backLineColor,
  }) = _RouteMapRouteTheme;
}
