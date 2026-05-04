import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class NoServiceAreaLayer {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color fillColor;
  final Color? borderColor;
  final double borderWidth;
  final String? belowLayerId;
  final bool enableInteraction;

  const NoServiceAreaLayer({
    required this.createSource,
    required this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.belowLayerId,
    this.enableInteraction = false,
  });
}
