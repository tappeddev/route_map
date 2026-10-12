import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/annotation_manager/route_map_layer_manager.dart';
import 'package:route_map/src/model/route_map_area/route_map_area.dart';
import 'package:route_map/src/route_map_area_geometry.dart';

class RouteMapAreaManager {
  final MapLibreMapController controller;
  final RouteMapLayerManager layerManager;

  Brightness _brightness = Brightness.light;
  final _areaMap = <String, RouteMapArea>{};

  RouteMapAreaManager({required this.controller, required this.layerManager});

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;

    for (final area in _areaMap.values.toList()) {
      if (controller.isDisposed) return;
      await _install(area);
    }
  }

  Future<void> drawArea(RouteMapArea area) async {
    final isDrawn = _areaMap.containsKey(area.identifier);
    _areaMap[area.identifier] = area;

    if (!isDrawn) {
      await _install(area);
      return;
    }

    final ids = _AreaIds(area.identifier);
    final theme = _resolveTheme(area);

    await controller.setGeoJsonSource(
      ids.source,
      createAreaFeatureCollection(area.polygons),
    );
    if (controller.isDisposed) return;
    await controller.setLayerProperties(ids.fillLayer, _fillProperties(theme));
    if (controller.isDisposed) return;
    await controller.setLayerProperties(
      ids.borderLayer,
      _borderProperties(theme),
    );
  }

  Future<void> removeArea({required String identifier}) async {
    if (_areaMap.remove(identifier) == null) return;
    await _uninstall(identifier);
  }

  Future<void> removeAreas() async {
    final identifiers = _areaMap.keys.toList();
    _areaMap.clear();

    for (final identifier in identifiers) {
      await _uninstall(identifier);
    }
  }

  Future<void> _install(RouteMapArea area) async {
    final ids = _AreaIds(area.identifier);
    final theme = _resolveTheme(area);

    await layerManager.addSource(
      ids.source,
      GeojsonSourceProperties(data: createAreaFeatureCollection(area.polygons)),
    );
    if (controller.isDisposed) return;

    await layerManager.addLayer(
      ids.source,
      ids.fillLayer,
      _fillProperties(theme),
      belowLayerId: area.belowLayerId,
      enableInteraction: false,
    );
    if (controller.isDisposed) return;

    await layerManager.addLayer(
      ids.source,
      ids.borderLayer,
      _borderProperties(theme),
      belowLayerId: area.belowLayerId,
      enableInteraction: false,
    );
  }

  Future<void> _uninstall(String identifier) async {
    final ids = _AreaIds(identifier);

    await layerManager.removeLayer(ids.borderLayer);
    await layerManager.removeLayer(ids.fillLayer);
    await layerManager.removeSource(ids.source);
  }

  RouteMapAreaTheme _resolveTheme(RouteMapArea area) {
    return switch (_brightness) {
      Brightness.dark => area.darkTheme ?? area.theme,
      Brightness.light => area.theme,
    };
  }

  FillLayerProperties _fillProperties(RouteMapAreaTheme theme) {
    return FillLayerProperties(
      fillColor: theme.fillColor.toHexStringRGB(),
      fillOpacity: theme.fillColor.a,
    );
  }

  LineLayerProperties _borderProperties(RouteMapAreaTheme theme) {
    return LineLayerProperties(
      lineColor: theme.borderColor.toHexStringRGB(),
      lineOpacity: theme.borderColor.a,
      lineWidth: theme.borderWidth,
    );
  }
}

/// The ids of the style source and layers of an area.
class _AreaIds {
  final String identifier;

  const _AreaIds(this.identifier);

  String get source => "route_map_area_source_$identifier";

  String get fillLayer => "route_map_area_fill_layer_$identifier";

  String get borderLayer => "route_map_area_border_layer_$identifier";
}
