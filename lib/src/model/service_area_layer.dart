import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

/// Defines a shaded region on the map — typically used to visualise an
/// area that is *not* part of the operator's service coverage.
///
/// The fill is rendered below all annotation-manager layers (lines,
/// symbols, circles, fills) so drawn routes and icons remain fully
/// visible on top of it.
class ServiceAreaLayer {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color fillColor;
  final ServiceAreaHashLines? hashLines;
  final ServiceAreaBorder? border;
  final String? belowLayerId;

  const ServiceAreaLayer({
    required this.createSource,
    required this.fillColor,
    this.hashLines,
    this.border,
    this.belowLayerId,
  });
}

class ServiceAreaHashLines {
  final Color color;
  final double width;
  final double spacing;

  const ServiceAreaHashLines({
    required this.color,
    this.width = 1,
    this.spacing = 8,
  }) : assert(width > 0),
       assert(spacing > 0);
}

class ServiceAreaBorder {
  final Future<GeojsonSourceProperties> Function() createSource;
  final Color color;
  final double width;

  const ServiceAreaBorder({
    required this.createSource,
    required this.color,
    this.width = 1,
  });
}
