import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/annotation_manager/route_map_layer_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_line_manager.dart';
import 'package:route_map/src/model/route_map_route/route_map_route.dart';

void main() {
  test('existing route with same backline shape updates in place', () {
    const previousTheme = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );
    const nextTheme = RouteMapRouteTheme(
      lineWidth: 7,
      color: Color(0xFF00FF00),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );

    final strategy = resolveRouteMutationStrategy(
      hasExistingRoute: true,
      previousTheme: previousTheme,
      nextTheme: nextTheme,
    );

    expect(strategy, RouteMapRouteMutationStrategy.update);
  });

  test('backline presence changes require a rebuild', () {
    const previousTheme = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
    );
    const nextTheme = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );

    final strategy = resolveRouteMutationStrategy(
      hasExistingRoute: true,
      previousTheme: previousTheme,
      nextTheme: nextTheme,
    );

    expect(strategy, RouteMapRouteMutationStrategy.rebuild);
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

    for (final (previousTheme, nextTheme, expectedStrategy) in [
      (solidTheme, dashedTheme, RouteMapRouteMutationStrategy.rebuild),
      (dashedTheme, solidTheme, RouteMapRouteMutationStrategy.rebuild),
      (
        dashedTheme,
        dashedTheme.copyWith(dashArray: [4, 1]),
        RouteMapRouteMutationStrategy.update,
      ),
    ]) {
      final strategy = resolveRouteMutationStrategy(
        hasExistingRoute: true,
        previousTheme: previousTheme,
        nextTheme: nextTheme,
      );

      expect(strategy, expectedStrategy);
    }
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
      const otherRoute = RouteMapRoute(
        identifier: 'other',
        points: [LatLng(38, 24), LatLng(38.5, 24.5)],
        theme: RouteMapRouteTheme(
          lineWidth: 3,
          color: Color(0xFF000000),
          dashArray: [1, 1],
        ),
      );
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

  @override
  bool get isDisposed => false;

  @override
  FillManager? get fillManager => _FakeFillManager();

  @override
  LineManager? get lineManager => _FakeLineManager();

  @override
  SymbolManager? get symbolManager => _FakeSymbolManager();

  @override
  CircleManager? get circleManager => _FakeCircleManager();

  @override
  Set<Line> get lines => {};

  @override
  Future<List<dynamic>> getLayerIds() async => [...styleLayerIds];

  @override
  Future<void> addSource(String sourceid, SourceProperties properties) async {
    sources[sourceid] = properties.toJson();
  }

  @override
  Future<void> removeSource(String sourceId) async {
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
    styleLayerIds.insert(styleLayerIds.indexOf(belowLayerId!), layerId);
    layers[layerId] = properties.toJson();
  }

  @override
  Future<void> removeLayer(String layerId) async {
    styleLayerIds.remove(layerId);
    layers.remove(layerId);
  }

  @override
  Future<void> setGeoJsonSource(
    String sourceId,
    Map<String, dynamic> geojson,
  ) async {
    sources[sourceId]!['data'] = geojson;
  }

  @override
  Future<void> setLayerProperties(
    String layerId,
    LayerProperties properties,
  ) async {
    if (!layers.containsKey(layerId)) throw StateError('No layer $layerId');
    layers[layerId] = properties.toJson();
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
