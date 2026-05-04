import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class NoServiceAreaLayer {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color fillColor;
  final NoServiceAreaBorder? border;
  final String? belowLayerId;
  final bool enableInteraction;

  const NoServiceAreaLayer({
    required this.createSource,
    required this.fillColor,
    this.border,
    this.belowLayerId,
    this.enableInteraction = false,
  });
}

class NoServiceAreaBorder {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color color;
  final double width;

  const NoServiceAreaBorder({
    required this.createSource,
    required this.color,
    this.width = 1,
  });
}
