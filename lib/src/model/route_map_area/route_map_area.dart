import 'package:flutter/painting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_map/route_map.dart';
import 'package:route_map/src/route_map_area_geometry.dart';

part 'route_map_area.freezed.dart';

/// A filled area with a border on the map, which keeps its geographic size
/// while zooming, e.g. the region reachable from a location.
///
/// It may consist of several [polygons], e.g. when a radius
/// ([RouteMapAreaPolygon.radius]) is cut by the border of a region.
@freezed
abstract class RouteMapArea with _$RouteMapArea {
  const factory RouteMapArea({
    required String identifier,
    required List<RouteMapAreaPolygon> polygons,
    required RouteMapAreaTheme theme,
    RouteMapAreaTheme? darkTheme,

    /// Preferred style layer to insert the area below, e.g. to keep the labels
    /// of the map readable. The area is always placed below drawn routes and
    /// icons.
    String? belowLayerId,
  }) = _RouteMapArea;
}

@freezed
abstract class RouteMapAreaPolygon with _$RouteMapAreaPolygon {
  const RouteMapAreaPolygon._();

  const factory RouteMapAreaPolygon({
    /// The outline of the polygon. It doesn't need to be closed, the first
    /// point is repeated at the end if needed.
    required List<LatLng> outline,

    /// Areas cut out of the polygon.
    @Default(<List<LatLng>>[]) List<List<LatLng>> holes,
  }) = _RouteMapAreaPolygon;

  /// A circle with a radius in meters around the [center], approximated by
  /// [steps] points on the earth's surface.
  ///
  /// In contrast to [RouteMapCircle] (whose radius is in screen pixels), it
  /// keeps its geographic size while zooming.
  factory RouteMapAreaPolygon.radius({
    required LatLng center,
    required double radiusInMeters,
    int steps = radiusPolygonSteps,
  }) {
    return RouteMapAreaPolygon(
      outline: createRadiusPolygon(
        center: center,
        radiusInMeters: radiusInMeters,
        steps: steps,
      ),
    );
  }
}

@freezed
abstract class RouteMapAreaTheme with _$RouteMapAreaTheme {
  const factory RouteMapAreaTheme({
    /// The opacity is taken from the alpha of the color.
    required Color fillColor,

    /// The opacity is taken from the alpha of the color.
    required Color borderColor,
    @Default(2) double borderWidth,
  }) = _RouteMapAreaTheme;
}
