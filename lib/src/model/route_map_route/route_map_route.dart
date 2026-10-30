import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
    String? lineJoin,
    double? lineBlur,

    /// Dashes the front line with MapLibre `line-dasharray` semantics:
    /// alternating dash and gap lengths in multiples of [lineWidth],
    /// e.g. `[2, 2]`. Must be non-empty and contain only positive values.
    /// The back line stays solid.
    ///
    /// Line annotations can't be dashed, so dashed routes are drawn as
    /// style layers instead. As a consequence they:
    /// * always render below solid routes, icons and circles,
    ///   regardless of draw order (among dashed routes, the most recently
    ///   added one is on top),
    /// * render relative to areas without a [RouteMapArea.belowLayerId] in
    ///   insertion order, which can change after a style reload (areas are
    ///   restored first),
    /// * don't consume taps and don't trigger `onFeatureHover`.
    List<double>? dashArray,
  }) = _RouteMapRouteTheme;
}
