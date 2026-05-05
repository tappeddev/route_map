import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_route/route_map_route.dart';

enum RouteMapRouteMutationStrategy { add, update, rebuild }

RouteMapRouteMutationStrategy resolveRouteMutationStrategy({
  required bool hasExistingRoute,
  required RouteMapRouteTheme previousTheme,
  required RouteMapRouteTheme nextTheme,
}) {
  if (!hasExistingRoute) {
    return RouteMapRouteMutationStrategy.add;
  }

  final hadBackLine =
      previousTheme.backLineWidth != null &&
      previousTheme.backLineColor != null;
  final hasBackLine =
      nextTheme.backLineWidth != null && nextTheme.backLineColor != null;

  if (hadBackLine != hasBackLine) {
    return RouteMapRouteMutationStrategy.rebuild;
  }

  return RouteMapRouteMutationStrategy.update;
}

class RouteMapLineManager {
  final MapLibreMapController controller;
  Brightness _brightness = Brightness.light;

  final _routeMap = <String, _DrawnRoute>{};

  RouteMapLineManager({required this.controller});

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final routes = _routeMap.values.toList();
    await removeRoutes();
    for (final drawnRoute in routes) {
      if (controller.isDisposed) return;
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
    final theme = switch (_brightness) {
      Brightness.dark => route.darkTheme ?? route.theme,
      Brightness.light => route.theme,
    };
    final mutationStrategy = resolveRouteMutationStrategy(
      hasExistingRoute: drawnRoute != null,
      previousTheme:
          switch (_brightness) {
            Brightness.dark =>
              drawnRoute?.route.darkTheme ?? drawnRoute?.route.theme,
            Brightness.light => drawnRoute?.route.theme,
          } ??
          theme,
      nextTheme: theme,
    );

    switch (mutationStrategy) {
      case RouteMapRouteMutationStrategy.add:
        await _drawNewRoute(route, theme);
        break;
      case RouteMapRouteMutationStrategy.update:
        await _updateExistingRoute(drawnRoute!, route, theme);
        break;
      case RouteMapRouteMutationStrategy.rebuild:
        await controller.removeLines([
          drawnRoute!.line,
          if (drawnRoute.backLine != null) drawnRoute.backLine!,
        ]);
        await _drawNewRoute(route, theme);
        break;
    }
  }

  Future<void> _drawNewRoute(
    RouteMapRoute route,
    RouteMapRouteTheme theme,
  ) async {
    final routeLine = LineOptions(
      geometry: route.points,
      lineColor: theme.color.toHexStringRGB(),
      lineOpacity: theme.color.a,
      lineWidth: theme.lineWidth,
      lineJoin: theme.lineJoin,
      lineBlur: theme.lineBlur,
    );

    Line? backLine;
    if (theme.backLineWidth != null && theme.backLineColor != null) {
      final backgroundLine = LineOptions(
        geometry: route.points,
        lineColor: theme.backLineColor!.toHexStringRGB(),
        lineOpacity: theme.backLineColor!.a,
        lineWidth: theme.backLineWidth,
        lineJoin: theme.lineJoin,
        lineBlur: theme.lineBlur,
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

  Future<void> _updateExistingRoute(
    _DrawnRoute drawnRoute,
    RouteMapRoute route,
    RouteMapRouteTheme theme,
  ) async {
    await controller.updateLine(
      drawnRoute.line,
      LineOptions(
        geometry: route.points,
        lineColor: theme.color.toHexStringRGB(),
        lineOpacity: theme.color.a,
        lineWidth: theme.lineWidth,
        lineJoin: theme.lineJoin,
        lineBlur: theme.lineBlur,
      ),
    );

    final backLine = drawnRoute.backLine;
    if (backLine != null &&
        theme.backLineWidth != null &&
        theme.backLineColor != null) {
      await controller.updateLine(
        backLine,
        LineOptions(
          geometry: route.points,
          lineColor: theme.backLineColor!.toHexStringRGB(),
          lineOpacity: theme.backLineColor!.a,
          lineWidth: theme.backLineWidth,
          lineJoin: theme.lineJoin,
          lineBlur: theme.lineBlur,
        ),
      );
    }

    _routeMap[route.identifier] = _DrawnRoute(
      route: route,
      line: drawnRoute.line,
      backLine: drawnRoute.backLine,
    );
  }
}

class _DrawnRoute {
  final RouteMapRoute route;
  final Line line;
  final Line? backLine;

  const _DrawnRoute({required this.route, required this.line, this.backLine});
}
