import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class NoServiceAreaLayer {
  final GeojsonSourceProperties source;
  final Color fillColor;
  final List<String> insertBelowLayers;

  const NoServiceAreaLayer({
    required this.source,
    required this.fillColor,
    this.insertBelowLayers = const [],
  });
}
