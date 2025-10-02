import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class NoServiceAreaLayer {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color fillColor;
  final String? belowLayerId;

  const NoServiceAreaLayer({
    required this.createSource,
    required this.fillColor,
    this.belowLayerId,
  });
}
