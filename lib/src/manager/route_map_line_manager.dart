import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_route/route_map_route.dart';

class RouteMapLineManager {
  final MapLibreMapController controller;
  Brightness _brightness = Brightness.light;

  final _routeMap = <String, _DrawnRoute>{};

  RouteMapLineManager({required this.controller});

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    await removeRoutes();

    for (final drawnRoute in _routeMap.values) {
      await drawRoute(drawnRoute.route);
    }
  }

  RouteMapRoute? findRouteByHoveredLine(Line line) =>
      _routeMap.values.firstWhereOrNull((drawnRoute) {
        // If backline exists, ignore front line to prevent duplicate callbacks
        return drawnRoute.backLine != null
            ? drawnRoute.backLine!.id == line.id
            : drawnRoute.line.id == line.id;
      })?.route;

  Future<void> removeRoutes() async {
    if (controller.lines.isNotEmpty) {
      await controller.removeLines(controller.lines);
    }

    _routeMap.clear();
  }

  /// Returns a tuple (String, String?) containing the front line id and the optional back line id
  Future<void> drawRoute(RouteMapRoute route) async {
    final drawnRoute = _routeMap[route.identifier];
    if (drawnRoute != null) {
      await controller.removeLines([
        drawnRoute.line,
        if (drawnRoute.backLine != null) drawnRoute.backLine!,
      ]);
    }

    final theme = switch (_brightness) {
      Brightness.dark => route.darkTheme ?? route.theme,
      Brightness.light => route.theme,
    };

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
    }

    if (controller.isDisposed) return;
    final line = await controller.addLine(routeLine);
    _routeMap[route.identifier] = _DrawnRoute(
      route: route,
      line: line,
      backLine: backLine,
    );
  }
}

class _DrawnRoute {
  final RouteMapRoute route;
  final Line line;
  final Line? backLine;

  const _DrawnRoute({required this.route, required this.line, this.backLine});
}
