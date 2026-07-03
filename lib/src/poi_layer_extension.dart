part of 'route_map_base.dart';

/// Internal book-keeping for a single [RouteMapPoiLayer] that has been
/// materialised on the map. The manager only tracks *raw* sources /
/// layers / images — this struct captures the higher-level grouping we
/// need for POI-specific operations like visibility toggling and tap
/// routing.
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

  Future<void> _addPoiLayer({
    required MapLibreMapController controller,
    required RouteMapPoiLayer layer,
  }) async {
    final source = await layer.createSource();
    if (!mounted) return;

    final sourceId = "route_map_poi_source_${layer.identifier}";
    await _layerManagerInstance.addSource(sourceId, source);
    if (!mounted) return;

    // Register PNGs via the shared icon manager so POI markers go
    // through the exact same rasterization pipeline as regular icons.
    // The manager returns the actual MapLibre image key it registered
    // the PNG under (derived from visuals), which we reuse as
    // `iconImage` for the SymbolLayer below.
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

      await _layerManagerInstance.addLayer(
        sourceId,
        layerId,
        SymbolLayerProperties(
          iconImage: imageKey,
          iconAnchor: category.anchor.mglIconValue,
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
        belowLayerId: layer.belowLayerId,
        enableInteraction: category.interactive,
        isVisible: layer.initiallyVisible,
        filter: filter,
      );
      if (!mounted) return;

      categoryLayerIds.add(layerId);
      categoryById[layerId] = category;
    }

    // Cluster appearance — inserted *above* the categories so they
    // always paint on top of individual features (mirroring the
    // maplibre clustering example).
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

      await _layerManagerInstance.addLayer(
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
        belowLayerId: layer.belowLayerId,
        isVisible: layer.initiallyVisible,
        filter: ['has', 'point_count'],
      );
      if (!mounted) return;

      await _layerManagerInstance.addLayer(
        sourceId,
        textId,
        SymbolLayerProperties(
          textField: [Expressions.get, 'point_count'],
          textSize: clusterTheme.textSize,
          // ignore: deprecated_member_use
          textColor: textColor.toHexStringRGB(),
        ),
        belowLayerId: layer.belowLayerId,
        isVisible: layer.initiallyVisible,
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
