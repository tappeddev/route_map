import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/annotation_manager/route_map_layer_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_line_manager.dart';
import 'package:route_map/src/model/route_map_route/route_map_route.dart';

void main() {
  test('existing route with same backline shape updates in place', () {
    const nextTheme = RouteMapRouteTheme(
      lineWidth: 7,
      color: Color(0xFF00FF00),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );

    final strategy = resolveRouteMutationStrategy(
      hasExistingRoute: true,
      wasDrawnDashed: false,
      wasDrawnWithBackLine: true,
      nextTheme: nextTheme,
    );

    expect(strategy, RouteMapRouteMutationStrategy.update);
  });

  test('backline presence changes require a rebuild', () {
    const themeWithoutBackLine = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
    );
    const themeWithBackLine = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );

    for (final (wasDrawnWithBackLine, nextTheme) in [
      (false, themeWithBackLine),
      (true, themeWithoutBackLine),
    ]) {
      final strategy = resolveRouteMutationStrategy(
        hasExistingRoute: true,
        wasDrawnDashed: false,
        wasDrawnWithBackLine: wasDrawnWithBackLine,
        nextTheme: nextTheme,
      );

      expect(strategy, RouteMapRouteMutationStrategy.rebuild);
    }
  });

  test('route theme keeps new smoothing fields optional by default', () {
    const theme = RouteMapRouteTheme(lineWidth: 6, color: Color(0xFF0000FF));

    expect(theme.lineJoin, isNull);
    expect(theme.lineBlur, isNull);
    expect(theme.dashArray, isNull);
  });

  test('switching between solid and dashed requires a rebuild', () {
    const solidTheme = RouteMapRouteTheme(
      lineWidth: 3,
      color: Color(0xFFE0A400),
    );
    const dashedTheme = RouteMapRouteTheme(
      lineWidth: 3,
      color: Color(0xFFE0A400),
      dashArray: [2, 2],
    );

    for (final (wasDrawnDashed, nextTheme, expectedStrategy) in [
      (false, dashedTheme, RouteMapRouteMutationStrategy.rebuild),
      (true, solidTheme, RouteMapRouteMutationStrategy.rebuild),
      (
        true,
        dashedTheme.copyWith(dashArray: [4, 1]),
        RouteMapRouteMutationStrategy.update,
      ),
    ]) {
      final strategy = resolveRouteMutationStrategy(
        hasExistingRoute: true,
        wasDrawnDashed: wasDrawnDashed,
        wasDrawnWithBackLine: false,
        nextTheme: nextTheme,
      );

      expect(strategy, expectedStrategy);
    }
  });

  test('route without an existing one is added', () {
    const dashedTheme = RouteMapRouteTheme(
      lineWidth: 3,
      color: Color(0xFFE0A400),
      dashArray: [2, 2],
    );

    final strategy = resolveRouteMutationStrategy(
      hasExistingRoute: false,
      wasDrawnDashed: false,
      wasDrawnWithBackLine: true,
      nextTheme: dashedTheme,
    );

    expect(strategy, RouteMapRouteMutationStrategy.add);
  });

  group('dashed route', () {
    const sourceId = 'route_map_dashed_route_source_not-driven';
    const frontLayerId = 'route_map_dashed_route_layer_not-driven';
    const backLayerId = 'route_map_dashed_route_back_layer_not-driven';
    const route = RouteMapRoute(
      identifier: 'not-driven',
      points: [LatLng(38, 23.5), LatLng(38.5, 24)],
      theme: RouteMapRouteTheme(
        lineWidth: 3,
        color: Color(0xFFE0A400),
        backLineWidth: 9,
        backLineColor: Color(0xFFFFF1C2),
        dashArray: [2, 2],
      ),
      darkTheme: RouteMapRouteTheme(
        lineWidth: 3,
        color: Color(0xFFE0A400),
        backLineWidth: 9,
        backLineColor: Color(0xFF5A4710),
        dashArray: [2, 2],
      ),
    );
    const otherRoute = RouteMapRoute(
      identifier: 'other',
      points: [LatLng(38, 24), LatLng(38.5, 24.5)],
      theme: RouteMapRouteTheme(
        lineWidth: 3,
        color: Color(0xFF000000),
        dashArray: [1, 1],
      ),
    );

    late _FakeMapController controller;
    late RouteMapLayerManager layerManager;
    late RouteMapLineManager lineManager;

    setUp(() {
      controller = _FakeMapController();
      layerManager = RouteMapLayerManager(controller: controller);
      lineManager = RouteMapLineManager(
        controller: controller,
        layerManager: layerManager,
      );
    });

    test(
      'is drawn as solid back and dashed front layer below annotations',
      () async {
        await lineManager.drawRoute(route);

        expect(controller.styleLayerIds, [
          backLayerId,
          frontLayerId,
          ..._annotationLayerIds,
        ]);
        expect(
          controller.sources[sourceId]!['data'],
          _lineStringData([
            [23.5, 38],
            [24, 38.5],
          ]),
        );
        expect(controller.layers[frontLayerId], {
          'line-color': const Color(0xFFE0A400).toHexStringRGB(),
          'line-opacity': 1.0,
          'line-width': 3.0,
          'line-dasharray': [2.0, 2.0],
        });
        expect(controller.layers[backLayerId], {
          'line-color': const Color(0xFFFFF1C2).toHexStringRGB(),
          'line-opacity': 1.0,
          'line-width': 9.0,
        });
      },
    );

    test('is removed by removeRoutes', () async {
      await lineManager.drawRoute(route);
      await lineManager.removeRoutes();

      expect(controller.styleLayerIds, _annotationLayerIds);
      expect(controller.sources, isEmpty);
    });

    test('is redrawn with the dark theme after a style reload', () async {
      await lineManager.drawRoute(route);
      // What `_installStyleContent` does when the style is (re)loaded.
      await layerManager.removeAll();
      await lineManager.restore(Brightness.dark);

      expect(controller.styleLayerIds, [
        backLayerId,
        frontLayerId,
        ..._annotationLayerIds,
      ]);
      expect(
        controller.layers[backLayerId]!['line-color'],
        const Color(0xFF5A4710).toHexStringRGB(),
      );
    });

    test('is updated in place when redrawn', () async {
      await lineManager.drawRoute(route);
      await lineManager.drawRoute(otherRoute);
      final layerIdsBeforeUpdate = [...controller.styleLayerIds];

      await lineManager.drawRoute(
        route.copyWith(
          points: const [LatLng(38, 23.5), LatLng(38.25, 23.75)],
          theme: route.theme.copyWith(color: const Color(0xFF0000FF)),
        ),
      );

      // A rebuild would move the route above `otherRoute`.
      expect(controller.styleLayerIds, layerIdsBeforeUpdate);
      expect(
        controller.sources[sourceId]!['data'],
        _lineStringData([
          [23.5, 38],
          [23.75, 38.25],
        ]),
      );
      expect(
        controller.layers[frontLayerId]!['line-color'],
        const Color(0xFF0000FF).toHexStringRGB(),
      );
    });

    test('resets unset properties when redrawn', () async {
      await lineManager.drawRoute(
        route.copyWith(theme: route.theme.copyWith(lineBlur: 2)),
      );
      await lineManager.drawRoute(route);

      expect(controller.layers[frontLayerId], containsPair('line-blur', null));
      expect(controller.layers[backLayerId], containsPair('line-blur', null));
    });

    test('is drawn once when drawn concurrently', () async {
      await Future.wait([
        lineManager.drawRoute(route),
        lineManager.drawRoute(route),
      ]);

      expect(controller.styleLayerIds, [
        backLayerId,
        frontLayerId,
        ..._annotationLayerIds,
      ]);
      expect(controller.sources.keys, [sourceId]);
    });

    test('is replaced by line annotations when it becomes solid', () async {
      await lineManager.drawRoute(route);
      await lineManager.drawRoute(
        route.copyWith(theme: route.theme.copyWith(dashArray: null)),
      );

      expect(controller.styleLayerIds, _annotationLayerIds);
      expect(controller.sources, isEmpty);
      expect(
        controller.lines.map((line) => line.options.lineColor),
        unorderedEquals([
          const Color(0xFFE0A400).toHexStringRGB(),
          const Color(0xFFFFF1C2).toHexStringRGB(),
        ]),
      );
    });

    test('removes and re-adds the back layer when it is toggled', () async {
      final routeWithoutBackLine = route.copyWith(
        theme: route.theme.copyWith(backLineWidth: null, backLineColor: null),
      );

      await lineManager.drawRoute(route);
      await lineManager.drawRoute(routeWithoutBackLine);

      expect(controller.styleLayerIds, [frontLayerId, ..._annotationLayerIds]);
      expect(controller.sources.keys, [sourceId]);

      await lineManager.drawRoute(route);

      expect(controller.styleLayerIds, [
        backLayerId,
        frontLayerId,
        ..._annotationLayerIds,
      ]);
      expect(controller.sources.keys, [sourceId]);
    });

    test(
      'keeps the stacking order after a style reload when rebuilt',
      () async {
        await lineManager.drawRoute(route);
        await lineManager.drawRoute(otherRoute);
        // Removing the back line rebuilds the route above `otherRoute`.
        await lineManager.drawRoute(
          route.copyWith(
            theme: route.theme.copyWith(
              backLineWidth: null,
              backLineColor: null,
            ),
          ),
        );
        final layerIdsBeforeReload = [...controller.styleLayerIds];

        await layerManager.removeAll();
        await lineManager.restore(Brightness.light);

        expect(controller.styleLayerIds, layerIdsBeforeReload);
      },
    );

    test('makes no native calls once the map is disposed', () async {
      await lineManager.drawRoute(route);
      await lineManager.drawRoute(
        route.copyWith(
          identifier: 'solid',
          theme: route.theme.copyWith(dashArray: null),
        ),
      );
      controller
        ..isDisposed = true
        ..calls.clear();

      await lineManager.drawRoute(
        route.copyWith(points: const [LatLng(38, 23.5), LatLng(38.25, 23.75)]),
      );
      await lineManager.drawRoute(otherRoute);
      await lineManager.restore(Brightness.dark);
      await lineManager.removeRoutes();

      expect(controller.calls, isEmpty);
    });

    test('stops adding once the map is disposed in between', () async {
      controller.disposeAfterCall = 'addSource';

      await lineManager.drawRoute(route);

      expect(controller.calls, ['addSource']);
    });

    test('stops updating once the map is disposed in between', () async {
      await lineManager.drawRoute(route);
      for (final (disposeAfterCall, expectedCalls) in [
        ('setGeoJsonSource', ['setGeoJsonSource']),
        ('setLayerProperties', ['setGeoJsonSource', 'setLayerProperties']),
      ]) {
        controller
          ..isDisposed = false
          ..disposeAfterCall = disposeAfterCall
          ..calls.clear();

        await lineManager.drawRoute(
          route.copyWith(
            theme: route.theme.copyWith(color: const Color(0xFF0000FF)),
          ),
        );

        expect(controller.calls, expectedCalls);
      }
    });

    test('asserts that dashArray is non-empty and positive', () async {
      for (final dashArray in [
        <double>[],
        <double>[2, 0],
        <double>[2, -1],
      ]) {
        await expectLater(
          lineManager.drawRoute(
            route.copyWith(
              darkTheme: route.darkTheme!.copyWith(dashArray: dashArray),
            ),
          ),
          throwsAssertionError,
        );
      }

      expect(controller.styleLayerIds, _annotationLayerIds);
      expect(controller.sources, isEmpty);
    });
  });
}

Map<String, dynamic> _lineStringData(List<List<double>> coordinates) => {
  'type': 'FeatureCollection',
  'features': [
    {
      'type': 'Feature',
      'properties': <String, dynamic>{},
      'geometry': {'type': 'LineString', 'coordinates': coordinates},
    },
  ],
};

const _annotationLayerIds = ['fills', 'lines', 'symbols', 'circles'];

/// Records sources and layers like a MapLibre style. [styleLayerIds] is
/// ordered bottom to top.
class _FakeMapController extends Fake implements MapLibreMapController {
  final styleLayerIds = [..._annotationLayerIds];
  final layers = <String, Map<String, dynamic>>{};
  final sources = <String, Map<String, dynamic>>{};
  final _lines = <Line>{};
  var _nextLineId = 0;

  /// The names of the native calls, in the order they were made.
  final calls = <String>[];

  /// Disposes the map right after the first call with this name.
  String? disposeAfterCall;

  @override
  bool isDisposed = false;

  void _record(String call) {
    calls.add(call);
    if (call == disposeAfterCall) isDisposed = true;
  }

  @override
  FillManager? get fillManager => _FakeFillManager();

  @override
  LineManager? get lineManager => _FakeLineManager();

  @override
  SymbolManager? get symbolManager => _FakeSymbolManager();

  @override
  CircleManager? get circleManager => _FakeCircleManager();

  @override
  Set<Line> get lines => {..._lines};

  @override
  Future<Line> addLine(
    LineOptions options, [
    Map<String, dynamic>? data,
  ]) async {
    _record('addLine');
    final line = Line('line_${_nextLineId++}', options, data);
    _lines.add(line);
    return line;
  }

  @override
  Future<void> removeLines(Iterable<Line> lines) async {
    _record('removeLines');
    _lines.removeAll(lines);
  }

  @override
  Future<List<dynamic>> getLayerIds() async {
    _record('getLayerIds');
    return [...styleLayerIds];
  }

  @override
  Future<void> addSource(String sourceid, SourceProperties properties) async {
    _record('addSource');
    if (sources.containsKey(sourceid)) {
      throw StateError('Source $sourceid already exists');
    }
    sources[sourceid] = properties.toJson();
  }

  @override
  Future<void> removeSource(String sourceId) async {
    _record('removeSource');
    sources.remove(sourceId);
  }

  @override
  Future<void> addLayer(
    String sourceId,
    String layerId,
    LayerProperties properties, {
    String? belowLayerId,
    bool enableInteraction = true,
    String? sourceLayer,
    double? minzoom,
    double? maxzoom,
    dynamic filter,
  }) async {
    _record('addLayer');
    styleLayerIds.insert(styleLayerIds.indexOf(belowLayerId!), layerId);
    layers[layerId] = properties.toJson();
  }

  @override
  Future<void> removeLayer(String layerId) async {
    _record('removeLayer');
    styleLayerIds.remove(layerId);
    layers.remove(layerId);
  }

  @override
  Future<void> setGeoJsonSource(
    String sourceId,
    Map<String, dynamic> geojson,
  ) async {
    _record('setGeoJsonSource');
    sources[sourceId]!['data'] = geojson;
  }

  @override
  Future<void> setLayerProperties(
    String layerId,
    LayerProperties properties,
  ) async {
    _record('setLayerProperties');
    if (!layers.containsKey(layerId)) throw StateError('No layer $layerId');
    // Like MapLibreMapController, which resets unset properties.
    layers[layerId] = properties.toJson(skipNulls: false);
  }
}

class _FakeFillManager extends Fake implements FillManager {
  @override
  List<String> get layerIds => ['fills'];
}

class _FakeLineManager extends Fake implements LineManager {
  @override
  List<String> get layerIds => ['lines'];
}

class _FakeSymbolManager extends Fake implements SymbolManager {
  @override
  List<String> get layerIds => ['symbols'];
}

class _FakeCircleManager extends Fake implements CircleManager {
  @override
  List<String> get layerIds => ['circles'];
}
