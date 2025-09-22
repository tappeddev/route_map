import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';

class VectorMapLineManager {
  final MapLibreMapController controller;

  final _lineMap = <String, List<LatLng>>{};
  final Color Function() lineColor;
  final Color Function() lineBackgroundColor;

  VectorMapLineManager({
    required this.controller,
    required this.lineColor,
    required this.lineBackgroundColor,
  });

  Future<List<List<LatLng>>> beforeRestore() async {
    final pointList = _lineMap.values.toList();

    await removeRoutes();

    return pointList;
  }

  Future<void> restore(List<List<LatLng>> pointList) async {
    for (final points in pointList) {
      await drawRoute(points: points);
    }
  }

  Future<void> removeRoutes() async {
    if (controller.lines.isNotEmpty) {
      await controller.removeLines(controller.lines);
    }

    _lineMap.clear();
  }

  Future<void> drawRoute({required List<LatLng> points}) async {
    final routeLine = LineOptions(
      draggable: false,
      lineOpacity: 1,
      geometry: points,
      lineColor: lineColor().toHexStringRGB(),
      lineWidth: 4,
    );

    final backgroundLine = LineOptions(
      draggable: false,
      lineOpacity: 1,
      geometry: points,
      lineColor: lineBackgroundColor().toHexStringRGB(),
      lineWidth: 6,
    );

    final bLine = await controller.addLine(backgroundLine);
    final line = await controller.addLine(routeLine);

    _lineMap[line.id] = points;
    _lineMap[bLine.id] = points;
  }
}
