import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:collection/collection.dart';

extension VectorMapCurrentLocationExtensions on MapLibreMapController {
  @protected
  Future<void> drawCurrentLocationIndicatorAt({
    required LatLng latLng,
    required Color color,
  }) async {
    final accuracyOptions = CircleOptions(
      circleRadius: 2,
      circleColor: color.toHexStringRGB(),
      circleStrokeColor: color.toHexStringRGB(),
      circleStrokeOpacity: 0.35,
      circleStrokeWidth: 12,
      geometry: latLng,
      circleBlur: 0.1,
      draggable: false,
    );

    await addOrUpdateCircle(options: accuracyOptions);

    final indicatorOptions = CircleOptions(
      circleRadius: 6,
      circleColor: color.toHexStringRGB(),
      circleStrokeColor: Colors.white.toHexStringRGB(),
      circleStrokeWidth: 2,
      geometry: latLng,
      circleBlur: 0.1,
      draggable: false,
    );

    await addOrUpdateCircle(options: indicatorOptions);
  }
}

extension on MapLibreMapController {
  Future<void> addOrUpdateCircle({required CircleOptions options}) async {
    final circle = circles.firstWhereOrNull((circle) {
      final existing =
          circle.options.withoutColorsAndGeometry().toJson().toString();
      final replacement =
          options.withoutColorsAndGeometry().toJson().toString();

      return existing == replacement;
    });

    if (circle != null) {
      await updateCircle(circle, options);
    } else {
      await addCircle(options);
    }
  }
}

extension on CircleOptions {
  CircleOptions withoutColorsAndGeometry() {
    return CircleOptions(
      circleRadius: circleRadius,
      circleColor: null,
      circleBlur: circleBlur,
      circleOpacity: circleOpacity,
      circleStrokeWidth: circleStrokeWidth,
      circleStrokeColor: null,
      circleStrokeOpacity: circleStrokeOpacity,
      draggable: draggable,
      geometry: null,
    );
  }
}
