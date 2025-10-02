import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class NoServiceAreaLayer {
  final GeojsonSourceProperties source;
  final Color fillColor;
  final String? belowLayerId;

  const NoServiceAreaLayer({
    required this.source,
    required this.fillColor,
    this.belowLayerId,
  });
}
