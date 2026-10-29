import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_map/route_map.dart';
import 'package:route_map/src/route_map_area_geometry.dart';

void main() {
  const strasbourg = LatLng(48.5796, 7.7353);

  group('createRadiusPolygon', () {
    test('every point has the radius as distance to the center', () {
      for (final radius in [50.0, 30000.0, 150000.0]) {
        final polygon = createRadiusPolygon(
          center: strasbourg,
          radiusInMeters: radius,
        );

        for (final point in polygon) {
          expect(
            distanceInMeters(strasbourg, point),
            closeTo(radius, radius * 0.0001),
          );
        }
      }
    });

    test('is a closed ring with the amount of steps', () {
      final polygon = createRadiusPolygon(
        center: strasbourg,
        radiusInMeters: 30000,
        steps: 64,
      );

      expect(polygon, hasLength(65));
      expect(polygon.first, polygon.last);
    });

    test('starts in the north and goes clockwise', () {
      final polygon = createRadiusPolygon(
        center: strasbourg,
        radiusInMeters: 30000,
        steps: 4,
      );

      final [north, east, south, west, _] = polygon;

      expect(north.latitude, greaterThan(strasbourg.latitude));
      expect(north.longitude, closeTo(strasbourg.longitude, 0.000001));
      expect(east.longitude, greaterThan(strasbourg.longitude));
      expect(south.latitude, lessThan(strasbourg.latitude));
      expect(west.longitude, lessThan(strasbourg.longitude));
    });

    test('keeps the longitude within -180 and 180 at the antimeridian', () {
      final polygon = createRadiusPolygon(
        center: const LatLng(0, 179.9),
        radiusInMeters: 50000,
      );

      for (final point in polygon) {
        expect(point.longitude, inInclusiveRange(-180, 180));
      }
    });
  });

  group('createAreaFeatureCollection', () {
    test('creates a MultiPolygon with [longitude, latitude] positions', () {
      final featureCollection = createAreaFeatureCollection(const [
        RouteMapAreaPolygon(
          outline: [LatLng(1, 2), LatLng(3, 4), LatLng(5, 6), LatLng(1, 2)],
          holes: [
            [LatLng(2, 3), LatLng(3, 3.5), LatLng(4, 4.5), LatLng(2, 3)],
          ],
        ),
        RouteMapAreaPolygon(
          outline: [LatLng(10, 20), LatLng(30, 40), LatLng(50, 60)],
        ),
      ]);

      final features = featureCollection["features"] as List;
      final geometry = (features.single as Map)["geometry"] as Map;

      expect(featureCollection["type"], "FeatureCollection");
      expect(geometry["type"], "MultiPolygon");
      expect(geometry["coordinates"], [
        [
          [
            [2, 1],
            [4, 3],
            [6, 5],
            [2, 1],
          ],
          [
            [3, 2],
            [3.5, 3],
            [4.5, 4],
            [3, 2],
          ],
        ],
        // the open outline is closed
        [
          [
            [20, 10],
            [40, 30],
            [60, 50],
            [20, 10],
          ],
        ],
      ]);
    });
  });

  test('distanceInMeters between Strasbourg and Paris', () {
    const paris = LatLng(48.8566, 2.3522);

    // ~397 km great-circle distance
    expect(distanceInMeters(strasbourg, paris), closeTo(397000, 2000));
  });

  group('RouteMapAreaPolygon.radius', () {
    test('has the radius as outline and no holes', () {
      final polygon = RouteMapAreaPolygon.radius(
        center: strasbourg,
        radiusInMeters: 30000,
      );

      expect(polygon.holes, isEmpty);
      expect(polygon.outline, hasLength(radiusPolygonSteps + 1));

      for (final point in polygon.outline) {
        expect(distanceInMeters(strasbourg, point), closeTo(30000, 3));
      }
    });
  });

  test('area keeps the optional fields empty by default', () {
    final area = RouteMapArea(
      identifier: 'area-id',
      polygons: [
        RouteMapAreaPolygon.radius(center: strasbourg, radiusInMeters: 30000),
      ],
      theme: const RouteMapAreaTheme(
        fillColor: Color(0x330000FF),
        borderColor: Color(0xFF0000FF),
      ),
    );

    expect(area.darkTheme, isNull);
    expect(area.belowLayerId, isNull);
    expect(area.theme.borderWidth, 2);
  });
}
