part of 'route_map_base.dart';

/// Internal book-keeping for a single [RouteMapPoiLayer] that has been
/// materialised on the map.
class _PoiLayerEntry {
  final RouteMapPoiLayer layer;
  final String sourceId;
  final List<String> categoryLayerIds;
  final List<String> clusterLayerIds;
  final Map<String, RouteMapPoiCategory> categoryById;
  bool isVisible;

  _PoiLayerEntry({
    required this.layer,
    required this.sourceId,
    required this.categoryLayerIds,
    required this.clusterLayerIds,
    required this.categoryById,
    required this.isVisible,
  });

  List<String> get allLayerIds => [...categoryLayerIds, ...clusterLayerIds];
}

extension _RouteMapPoiLayerState on _RouteMapState {
  /// Wires up every declared [RouteMapPoiLayer] on the freshly-loaded
  /// style. Must be called from `onStyleLoadedCallback`.
  Future<void> _addPoiLayers() async {
    final poiLayers = widget.poiLayers;
    if (poiLayers.isEmpty) return;
    final controller = await _controller;
    if (!mounted) return;

    for (final layer in poiLayers) {
      await _addPoiLayer(controller: controller, layer: layer);
      if (!mounted) return;
    }
  }

  /// Removes all currently-installed POI layers. Used both for explicit
  /// removal and on style change to clean up before re-installing.
  Future<void> _removeAllPoiLayers() async {
    if (_poiLayers.isEmpty) return;
    final controller = await _controller;
    if (!mounted) return;

    for (final entry in _poiLayers.values.toList()) {
      await _removePoiLayerEntry(controller: controller, entry: entry);
      if (!mounted) return;
    }
  }

  Future<void> _addPoiLayer({
    required MapLibreMapController controller,
    required RouteMapPoiLayer layer,
  }) async {
    // Resolve the layer-id below which we insert all POI sub-layers. Mirrors
    // the logic of `_addNoServiceAreaLayer` to keep symbol manager layers
    // above the inserted POI layers.
    final belowLayerId = layer.belowLayerId;

    final topLayers = [
      ...controller.lineManager!.layerIds,
      ...controller.symbolManager!.layerIds,
      ...controller.circleManager!.layerIds,
      ...controller.fillManager!.layerIds,
      ?belowLayerId,
    ];
    final allLayerIds = await controller.getLayerIds();
    final insertBelowLayer = allLayerIds
        .map((layerId) => layerId.toString())
        .firstWhere((layerId) => topLayers.contains(layerId));

    if (!mounted) return;

    // Load the GeoJSON source.
    final source = await layer.createSource();
    if (!mounted) return;

    final sourceId = "route_map_poi_source_${layer.identifier}";
    await controller.addSource(sourceId, source);
    if (!mounted) return;

    final categoryImageKeys = <String, String>{};
    for (final category in layer.categories) {
      final imageId = _poiCategoryImageId(layer: layer, category: category);
      final template = RouteMapIcon(
        identifier: imageId,
        latLng: const LatLng(0, 0),
        markerPath: category.markerPath,
        theme: category.theme,
        darkTheme: category.darkTheme,
        svgIconPath: category.svgIconPath,
        anchor: category.anchor,
      );
      final imageKey = await _iconManagerInstance.addImageToCacheIfNeeded(
        controller,
        mapIcon: template,
      );
      categoryImageKeys[imageId] = imageKey;
      if (!mounted) return;
    }

    // Add a SymbolLayer per category.
    final categoryLayerIds = <String>[];
    final categoryById = <String, RouteMapPoiCategory>{};

    final brightness = MediaQuery.platformBrightnessOf(context);

    for (final category in layer.categories) {
      final imageId = _poiCategoryImageId(layer: layer, category: category);
      final imageKey = categoryImageKeys[imageId] ?? imageId;
      final layerId = _poiCategoryLayerId(layer: layer, category: category);

      // Combine the user-provided filter with a "not clustered" check so
      // clustered features don't render individually.
      final filter = <Object>[
        'all',
        [
          '!',
          ['has', 'point_count'],
        ],
        category.filter,
      ];

      final labelDef = category.label;
      final hasLabel = labelDef != null;

      // Resolve theme-aware label colors.
      final labelColor = labelDef == null
          ? null
          : (brightness == Brightness.dark
                ? (labelDef.darkColor ?? labelDef.color)
                : labelDef.color);
      final labelHaloColor = labelDef == null
          ? null
          : (brightness == Brightness.dark
                ? (labelDef.darkHaloColor ?? labelDef.haloColor)
                : labelDef.haloColor);

      await controller.addLayer(
        sourceId,
        layerId,
        SymbolLayerProperties(
          iconImage: imageKey,
          iconAnchor: category.anchor.mglIconValue,
          // Match the [RouteMapIconManager.iconScale] used for regular
          // icons so POI pins are rendered at the same size.
          iconSize: _iconManagerInstance.iconScale,
          iconAllowOverlap: widget.allowIconsOverlap,
          iconIgnorePlacement: widget.ignoreIconsPlacement,
          textField: hasLabel ? labelDef.textExpression : null,
          textAnchor: hasLabel ? labelDef.anchor.mglIconValue : null,
          textSize: hasLabel ? labelDef.textSize : null,
          // ignore: deprecated_member_use
          textColor: labelColor?.toHexStringRGB(),
          // ignore: deprecated_member_use
          textHaloColor: labelHaloColor?.toHexStringRGB(),
          textHaloWidth: hasLabel ? labelDef.haloWidth : null,
        ),
        belowLayerId: insertBelowLayer,
        enableInteraction: category.interactive,
        filter: filter,
      );
      if (!mounted) return;

      categoryLayerIds.add(layerId);
      categoryById[layerId] = category;
    }

    // Cluster appearance — single circle layer + count text layer, inserted
    // *above* the categories so they always paint on top of individual
    // features (mirroring the maplibre clustering example).
    final clusterLayerIds = <String>[];
    final clusterTheme = layer.clusterTheme;
    if (clusterTheme != null) {
      final circleId = _poiClusterCircleLayerId(layer: layer);
      final textId = _poiClusterTextLayerId(layer: layer);

      final circleColor = brightness == Brightness.dark
          ? (clusterTheme.darkCircleColor ?? clusterTheme.circleColor)
          : clusterTheme.circleColor;
      final circleStrokeColor = brightness == Brightness.dark
          ? (clusterTheme.darkCircleStrokeColor ??
                clusterTheme.circleStrokeColor)
          : clusterTheme.circleStrokeColor;
      final textColor = brightness == Brightness.dark
          ? (clusterTheme.darkTextColor ?? clusterTheme.textColor)
          : clusterTheme.textColor;

      await controller.addLayer(
        sourceId,
        circleId,
        CircleLayerProperties(
          // ignore: deprecated_member_use
          circleColor: circleColor.toHexStringRGB(),
          circleRadius: clusterTheme.circleRadius,
          // ignore: deprecated_member_use
          circleStrokeColor: circleStrokeColor.toHexStringRGB(),
          circleStrokeWidth: clusterTheme.circleStrokeWidth,
        ),
        belowLayerId: insertBelowLayer,
        filter: ['has', 'point_count'],
      );
      if (!mounted) return;

      await controller.addLayer(
        sourceId,
        textId,
        SymbolLayerProperties(
          textField: [Expressions.get, 'point_count'],
          textSize: clusterTheme.textSize,
          // ignore: deprecated_member_use
          textColor: textColor.toHexStringRGB(),
        ),
        belowLayerId: insertBelowLayer,
        filter: ['has', 'point_count'],
      );
      if (!mounted) return;

      clusterLayerIds.addAll([circleId, textId]);
    }

    final entry = _PoiLayerEntry(
      layer: layer,
      sourceId: sourceId,
      categoryLayerIds: categoryLayerIds,
      clusterLayerIds: clusterLayerIds,
      categoryById: categoryById,
      isVisible: layer.initiallyVisible,
    );
    _poiLayers[layer.identifier] = entry;

    if (!layer.initiallyVisible) {
      await _applyPoiLayerVisibility(
        controller: controller,
        entry: entry,
        isVisible: false,
      );
    }
  }

  Future<void> _removePoiLayerEntry({
    required MapLibreMapController controller,
    required _PoiLayerEntry entry,
  }) async {
    for (final layerId in entry.allLayerIds) {
      try {
        await controller.removeLayer(layerId);
      } catch (_) {
        // The layer might already be gone after a style change — ignore.
      }
      if (!mounted) return;
    }
    try {
      await controller.removeSource(entry.sourceId);
    } catch (_) {
      // Same here.
    }
    _poiLayers.remove(entry.layer.identifier);
  }

  Future<void> _applyPoiLayerVisibility({
    required MapLibreMapController controller,
    required _PoiLayerEntry entry,
    required bool isVisible,
  }) async {
    final layerIds = await controller.getLayerIds();
    for (final layerId in entry.allLayerIds) {
      if (!layerIds.contains(layerId)) continue;
      await controller.setLayerVisibility(layerId, isVisible);
      if (!mounted) return;
    }
    entry.isVisible = isVisible;
  }

  /// Looks up the [RouteMapPoiCategory] / [RouteMapPoiLayer] pair of a
  /// tapped feature, identified by the layer-id reported by maplibre.
  ({RouteMapPoiLayer layer, RouteMapPoiCategory category})?
  _findPoiCategoryByLayerId(String layerId) {
    for (final entry in _poiLayers.values) {
      final category = entry.categoryById[layerId];
      if (category != null) {
        return (layer: entry.layer, category: category);
      }
    }
    return null;
  }
}

String _poiCategoryImageId({
  required RouteMapPoiLayer layer,
  required RouteMapPoiCategory category,
}) => "route_map_poi_icon_${layer.identifier}_${category.identifier}";

String _poiCategoryLayerId({
  required RouteMapPoiLayer layer,
  required RouteMapPoiCategory category,
}) => "route_map_poi_layer_${layer.identifier}_${category.identifier}";

String _poiClusterCircleLayerId({required RouteMapPoiLayer layer}) =>
    "route_map_poi_cluster_circle_${layer.identifier}";

String _poiClusterTextLayerId({required RouteMapPoiLayer layer}) =>
    "route_map_poi_cluster_text_${layer.identifier}";
