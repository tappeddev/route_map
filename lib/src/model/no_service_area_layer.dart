import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class NoServiceAreaLayer {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color fillColor;
  final NoServiceAreaHashLines? hashLines;
  final NoServiceAreaBorder? border;
  final String? belowLayerId;
  final bool enableInteraction;

  const NoServiceAreaLayer({
    required this.createSource,
    required this.fillColor,
    this.hashLines,
    this.border,
    this.belowLayerId,
    this.enableInteraction = false,
  });
}

class NoServiceAreaHashLines {
  final Color color;
  final double width;
  final double spacing;

  const NoServiceAreaHashLines({
    required this.color,
    this.width = 1,
    this.spacing = 8,
  }) : assert(width > 0),
       assert(spacing > 0);
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
