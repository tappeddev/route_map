import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';

const Map<String, Object?> serviceAreaGeoJson = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": <String, Object?>{},
      "geometry": {
        "type": "MultiPolygon",
        "coordinates": [
          [
            // Polygon 1 — irregular outer ring ...
            [
              [11.35, 48.00],
              [11.50, 47.97],
              [11.66, 48.02],
              [11.74, 48.12],
              [11.70, 48.24],
              [11.58, 48.30],
              [11.45, 48.27],
              [11.36, 48.18],
              [11.30, 48.09],
              [11.35, 48.00],
            ],
            // ... with a hole in the middle.
            [
              [11.50, 48.10],
              [11.60, 48.10],
              [11.62, 48.17],
              [11.53, 48.19],
              [11.48, 48.15],
              [11.50, 48.10],
            ],
          ],
          [
            // Polygon 2 — a separate area to the east.
            [
              [11.82, 48.02],
              [11.95, 48.05],
              [11.98, 48.14],
              [11.90, 48.20],
              [11.80, 48.13],
              [11.82, 48.02],
            ],
          ],
        ],
      },
    },
  ],
};

Future<GeojsonSourceProperties> createServiceAreaSource() async {
  return const GeojsonSourceProperties(data: serviceAreaGeoJson);
}

List<ServiceAreaLayer> serviceAreaLayers() => [
  ServiceAreaLayer(
    createSource: createServiceAreaSource,
    fillColor: Colors.grey.withValues(alpha: 0.45),
    hashLines: const ServiceAreaHashLines(color: Colors.black26, spacing: 10),
    border: const ServiceAreaBorder(
      createSource: createServiceAreaSource,
      color: Colors.redAccent,
      width: 2,
    ),
  ),
];
