import 'dart:math';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_area/route_map_area.dart';

/// Mean radius of the earth in meters.
const _earthRadiusInMeters = 6371008.8;

/// Amount of points of the polygon approximating a radius. With 256 points the
/// polygon deviates less than 0.008 % of the radius from a real circle
/// (e.g. 2.3 m for 30 km), which isn't visible on any zoom level.
const radiusPolygonSteps = 256;

/// The points on the earth's surface which are [radiusInMeters] away from the
/// [center], as closed ring (the first point is repeated at the end).
List<LatLng> createRadiusPolygon({
  required LatLng center,
  required double radiusInMeters,
  int steps = radiusPolygonSteps,
}) {
  assert(radiusInMeters > 0, "The radius has to be positive");
  assert(steps >= 3, "A polygon needs at least 3 points");

  final latitude = _toRadians(center.latitude);
  final longitude = _toRadians(center.longitude);
  final angularDistance = radiusInMeters / _earthRadiusInMeters;

  final points = List.generate(steps, (index) {
    final bearing = 2 * pi * index / steps;

    final pointLatitude = asin(
      sin(latitude) * cos(angularDistance) +
          cos(latitude) * sin(angularDistance) * cos(bearing),
    );

    final pointLongitude =
        longitude +
        atan2(
          sin(bearing) * sin(angularDistance) * cos(latitude),
          cos(angularDistance) - sin(latitude) * sin(pointLatitude),
        );

    return LatLng(
      _toDegrees(pointLatitude),
      _normalizeLongitude(pointLongitude),
    );
  });

  return [...points, points.first];
}

/// The GeoJSON feature collection of the [polygons] as one MultiPolygon, as
/// expected by [GeojsonSourceProperties.data] and
/// [MapLibreMapController.setGeoJsonSource].
Map<String, dynamic> createAreaFeatureCollection(
  List<RouteMapAreaPolygon> polygons,
) {
  return {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": <String, dynamic>{},
        "geometry": {
          "type": "MultiPolygon",
          "coordinates": [
            for (final polygon in polygons)
              [
                _toGeoJsonRing(polygon.outline),
                for (final hole in polygon.holes) _toGeoJsonRing(hole),
              ],
          ],
        },
      },
    ],
  };
}

/// GeoJSON positions are [longitude, latitude] and rings have to be closed.
List<List<double>> _toGeoJsonRing(List<LatLng> ring) {
  final isClosed = ring.isNotEmpty && ring.first == ring.last;

  return [
    for (final point in ring) [point.longitude, point.latitude],
    if (!isClosed && ring.isNotEmpty)
      [ring.first.longitude, ring.first.latitude],
  ];
}

/// The great-circle distance between [a] and [b] in meters (haversine).
double distanceInMeters(LatLng a, LatLng b) {
  final latitudeA = _toRadians(a.latitude);
  final latitudeB = _toRadians(b.latitude);
  final deltaLatitude = latitudeB - latitudeA;
  final deltaLongitude = _toRadians(b.longitude - a.longitude);

  final h =
      pow(sin(deltaLatitude / 2), 2) +
      cos(latitudeA) * cos(latitudeB) * pow(sin(deltaLongitude / 2), 2);

  return 2 * _earthRadiusInMeters * asin(sqrt(h));
}

double _toRadians(double degrees) => degrees * pi / 180;

double _toDegrees(double radians) => radians * 180 / pi;

/// Keeps the longitude within -180° and 180°.
double _normalizeLongitude(double longitudeInRadians) {
  final degrees = _toDegrees(longitudeInRadians);
  return (degrees + 540) % 360 - 180;
}
