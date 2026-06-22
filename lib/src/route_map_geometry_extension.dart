import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

extension RouteMapGeometryExtensions on MapLibreMapController {
  Future<CameraUpdate> cameraUpdateFrom({
    required List<LatLng> points,
    required EdgeInsets padding,
  }) async {
    final cameraBounds = points.convertToBounds();

    final cameraUpdate = CameraUpdate.newLatLngBounds(
      cameraBounds,
      left: padding.left,
      right: padding.right,
      bottom: padding.bottom,
      top: padding.top,
    );

    return cameraUpdate;
  }
}

extension on List<LatLng> {
  // https://stackoverflow.com/a/66545600/9277334
  LatLngBounds convertToBounds() {
    final route = this;

    // in case we want to highlight a location, we need to create a magically limited bound box
    if (route.length == 1) {
      final paddingDegrees = 0.001;

      final center = route.first;
      return LatLngBounds(
        southwest: LatLng(
          center.latitude - paddingDegrees,
          center.longitude - paddingDegrees,
        ),
        northeast: LatLng(
          center.latitude + paddingDegrees,
          center.longitude + paddingDegrees,
        ),
      );
    }

    assert(route.isNotEmpty);
    final firstLatLng = route.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < route.length; i++) {
      final latlng = this[i];
      s = min(s, latlng.latitude);
      n = max(n, latlng.latitude);
      w = min(w, latlng.longitude);
      e = max(e, latlng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }
}
