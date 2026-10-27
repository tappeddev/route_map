import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/annotation_manager/route_map_layer_manager.dart';
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

  // Dashed routes are drawn as style layers, solid routes as line annotations.
  final wasDashed = previousTheme.dashArray != null;
  final isDashed = nextTheme.dashArray != null;

  if (wasDashed != isDashed) {
    return RouteMapRouteMutationStrategy.rebuild;
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

  /// Draws dashed routes, see [RouteMapRouteTheme.dashArray].
  final RouteMapLayerManager layerManager;
  Brightness _brightness = Brightness.light;

  final _routeMap = <String, _DrawnRoute>{};

  RouteMapLineManager({required this.controller, required this.layerManager});

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final routes = _routeMap.values.toList();
    await removeRoutes();
    for (final drawnRoute in routes) {
      if (controller.isDisposed) return;
      await drawRoute(drawnRoute.route);
    }
  }

  RouteMapRoute? findRouteByHoveredLine(Line line) => _routeMap.values
      .whereType<_DrawnLineRoute>()
      .firstWhereOrNull((drawnRoute) {
        // If backline exists, ignore front line to prevent duplicate callbacks
        return drawnRoute.backLine != null
            ? drawnRoute.backLine!.id == line.id
            : drawnRoute.line.id == line.id;
      })
      ?.route;

  Future<void> removeRoutes() async {
    if (controller.lines.isNotEmpty) {
      await controller.removeLines(controller.lines);
    }

    final dashedRoutes = _routeMap.values.whereType<_DrawnDashedRoute>();
    for (final drawnRoute in dashedRoutes.toList()) {
      await _removeDashedRoute(drawnRoute.route.identifier);
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
        switch (drawnRoute!) {
          case final _DrawnLineRoute drawnLineRoute:
            await _updateExistingRoute(drawnLineRoute, route, theme);
          case _DrawnDashedRoute():
            await _updateDashedRoute(route, theme);
        }
        break;
      case RouteMapRouteMutationStrategy.rebuild:
        switch (drawnRoute!) {
          case _DrawnLineRoute(:final line, :final backLine):
            await controller.removeLines([line, ?backLine]);
          case _DrawnDashedRoute():
            await _removeDashedRoute(route.identifier);
        }
        await _drawNewRoute(route, theme);
        break;
    }
  }

  Future<void> _drawNewRoute(
    RouteMapRoute route,
    RouteMapRouteTheme theme,
  ) async {
    if (theme.dashArray != null) {
      await _drawDashedRoute(route, theme);
      return;
    }

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
    _routeMap[route.identifier] = _DrawnLineRoute(
      route: route,
      line: line,
      backLine: backLine,
    );
  }

  Future<void> _updateExistingRoute(
    _DrawnLineRoute drawnRoute,
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

    _routeMap[route.identifier] = _DrawnLineRoute(
      route: route,
      line: drawnRoute.line,
      backLine: drawnRoute.backLine,
    );
  }

  /// Draws [route] as style layers instead of line annotations, because
  /// only style layers support `line-dasharray`. They are inserted below
  /// all annotation layers, see [RouteMapLayerManager.addLayer].
  Future<void> _drawDashedRoute(
    RouteMapRoute route,
    RouteMapRouteTheme theme,
  ) async {
    final sourceId = _dashedRouteSourceId(route.identifier);
    await layerManager.addSource(
      sourceId,
      GeojsonSourceProperties(data: _routeGeoJson(route)),
    );

    if (theme.backLineWidth != null && theme.backLineColor != null) {
      if (controller.isDisposed) return;
      await layerManager.addLayer(
        sourceId,
        _dashedRouteBackLayerId(route.identifier),
        _backLineLayerProperties(theme),
        enableInteraction: false,
      );
    }

    if (controller.isDisposed) return;
    await layerManager.addLayer(
      sourceId,
      _dashedRouteLayerId(route.identifier),
      _lineLayerProperties(theme),
      enableInteraction: false,
    );
    _routeMap[route.identifier] = _DrawnDashedRoute(route: route);
  }

  /// Counterpart of [_updateExistingRoute] for routes drawn by
  /// [_drawDashedRoute]. Keeps the layers, so their order is unchanged.
  Future<void> _updateDashedRoute(
    RouteMapRoute route,
    RouteMapRouteTheme theme,
  ) async {
    await controller.setGeoJsonSource(
      _dashedRouteSourceId(route.identifier),
      _routeGeoJson(route),
    );

    if (theme.backLineWidth != null && theme.backLineColor != null) {
      await controller.setLayerProperties(
        _dashedRouteBackLayerId(route.identifier),
        _backLineLayerProperties(theme),
      );
    }

    // setLayerProperties also sends unset (null) properties, which resets them
    // to their defaults, like a new layer.
    await controller.setLayerProperties(
      _dashedRouteLayerId(route.identifier),
      _lineLayerProperties(theme),
    );
    _routeMap[route.identifier] = _DrawnDashedRoute(route: route);
  }

  Future<void> _removeDashedRoute(String identifier) async {
    await layerManager.removeLayer(_dashedRouteLayerId(identifier));
    await layerManager.removeLayer(_dashedRouteBackLayerId(identifier));
    await layerManager.removeSource(_dashedRouteSourceId(identifier));
  }
}

sealed class _DrawnRoute {
  final RouteMapRoute route;

  const _DrawnRoute({required this.route});
}

/// Drawn as line annotations.
class _DrawnLineRoute extends _DrawnRoute {
  final Line line;
  final Line? backLine;

  const _DrawnLineRoute({
    required super.route,
    required this.line,
    this.backLine,
  });
}

/// Drawn as style layers, see [RouteMapLineManager._drawDashedRoute].
class _DrawnDashedRoute extends _DrawnRoute {
  const _DrawnDashedRoute({required super.route});
}

String _dashedRouteSourceId(String identifier) =>
    "route_map_dashed_route_source_$identifier";

String _dashedRouteLayerId(String identifier) =>
    "route_map_dashed_route_layer_$identifier";

String _dashedRouteBackLayerId(String identifier) =>
    "route_map_dashed_route_back_layer_$identifier";

Map<String, dynamic> _routeGeoJson(RouteMapRoute route) =>
    buildFeatureCollection([LineOptions(geometry: route.points).toGeoJson()]);

LineLayerProperties _lineLayerProperties(RouteMapRouteTheme theme) =>
    LineLayerProperties(
      lineColor: theme.color.toHexStringRGB(),
      lineOpacity: theme.color.a,
      lineWidth: theme.lineWidth,
      lineJoin: theme.lineJoin,
      lineBlur: theme.lineBlur,
      lineDasharray: theme.dashArray,
    );

LineLayerProperties _backLineLayerProperties(RouteMapRouteTheme theme) =>
    LineLayerProperties(
      lineColor: theme.backLineColor!.toHexStringRGB(),
      lineOpacity: theme.backLineColor!.a,
      lineWidth: theme.backLineWidth,
      lineJoin: theme.lineJoin,
      lineBlur: theme.lineBlur,
    );
