import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_route/route_map_route.dart';

class RouteMapLineManager {
  final MapLibreMapController controller;
  Brightness _brightness = Brightness.light;

  final _routeMap = <String, RouteMapRoute>{};

  RouteMapLineManager({required this.controller});

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final routes = _routeMap.values.toList();
    await removeRoutes();

    for (final route in routes) {
      await drawRoute(route);
    }
  }

  Future<void> removeRoutes() async {
    if (controller.lines.isNotEmpty) {
      await controller.removeLines(controller.lines);
    }

    _routeMap.clear();
  }

  /// Returns a tuple (String, String?) containing the front line id and the optional back line id
  Future<(String, String?)> drawRoute(RouteMapRoute route) async {
    final theme =
        _brightness == Brightness.light
            ? route.theme
            : route.darkTheme ?? route.theme;

    final routeLine = LineOptions(
      geometry: route.points,
      lineColor: theme.color.toHexStringRGB(),
      lineOpacity: theme.color.a,
      lineWidth: theme.lineWidth,
    );

    Line? backLine;
    if (theme.backLineWidth != null && theme.backLineColor != null) {
      final backgroundLine = LineOptions(
        geometry: route.points,
        lineColor: theme.backLineColor!.toHexStringRGB(),
        lineOpacity: theme.backLineColor!.a,
        lineWidth: theme.backLineWidth,
      );
      backLine = await controller.addLine(backgroundLine);
      _routeMap[backLine.id] = route;
    }

    if (controller.isDisposed) ('', null);
    final line = await controller.addLine(routeLine);
    _routeMap[line.id] = route;

    return (line.id, backLine?.id);
  }
}
