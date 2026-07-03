import 'dart:typed_data';

import 'package:maplibre_gl/maplibre_gl.dart';

/// Tracks every *style-scoped* resource (source, layer, image) that has
/// been attached to the map, so it can be cleanly removed and rebuilt
/// whenever MapLibre reports a fresh style — for example after a theme
/// / style-url change, or when `onStyleLoadedCallback` fires more than
/// once during construction (which MapLibre does).
///
/// This manager is **content-agnostic**: it does not know about service
/// areas, POI layers or anything else. Consumers (extensions on
/// `_RouteMapState`) go through this manager instead of calling
/// `controller.addSource` / `addLayer` / `addImage` directly, so that a
/// single [removeAll] call in `onStyleLoadedCallback` can safely tear
/// everything down before re-installation without any per-feature
/// bookkeeping duplicated across extensions.
///
/// All add operations are idempotent: registering the same id twice
/// silently no-ops. This makes callers robust against MapLibre firing
/// `onStyleLoadedCallback` twice in a row before [removeAll] has been
/// called.
class RouteMapLayerManager {
  final MapLibreMapController controller;

  final Set<String> _layerIds = {};
  final Set<String> _sourceIds = {};
  final Set<String> _imageIds = {};

  /// Cache of resolved insert-below anchors keyed by the [belowLayerId]
  /// hint the caller passed to [addLayer]. Cleared in [removeAll]. Safe
  /// to cache within one install run because the resolved anchor is
  /// always one of the annotation-manager layers, which the manager
  /// itself never touches.
  final Map<String?, String> _insertBelowCache = {};

  RouteMapLayerManager({required this.controller});

  Future<void> addSource(String id, SourceProperties properties) async {
    if (_sourceIds.contains(id)) return;
    await controller.addSource(id, properties);
    _sourceIds.add(id);
  }

  /// Adds a style layer. When [belowLayerId] is provided it is
  /// preferred as insertion anchor; otherwise the first annotation-
  /// manager layer (lines / symbols / circles / fills) becomes the
  /// anchor so custom layers stay below drawn routes and icons.
  ///
  /// Note: [belowLayerId] here means "prefer this as anchor if it
  /// exists" — it is *not* forwarded verbatim to
  /// [MapLibreMapController.addLayer]. The manager always resolves an
  /// annotation-manager-aware anchor so custom layers never render on
  /// top of drawn geometry.
  Future<void> addLayer(
    String sourceId,
    String layerId,
    LayerProperties properties, {
    String? belowLayerId,
    // Mirror maplibre_gl's own default (true) so callers that don't
    // explicitly opt out keep the same behavior as before.
    bool enableInteraction = true,
    bool isVisible = true,
    dynamic filter,
  }) async {
    if (_layerIds.contains(layerId)) return;
    final resolvedBelowLayerId = await _resolveInsertBelowLayer(
      belowLayerId: belowLayerId,
    );
    await controller.addLayer(
      sourceId,
      layerId,
      properties,
      belowLayerId: resolvedBelowLayerId,
      enableInteraction: enableInteraction,
      filter: filter,
    );
    _layerIds.add(layerId);

    if (controller.isDisposed) return;

    // MapLibre defaults new layers to visible; only flip when the
    // caller wants it hidden right from the start (saves a native
    // round-trip in the common case).
    if (!isVisible) {
      await controller.setLayerVisibility(layerId, false);
    }
  }

  Future<void> addImage(String id, Uint8List bytes) async {
    if (_imageIds.contains(id)) return;
    await controller.addImage(id, bytes);
    _imageIds.add(id);
  }

  /// Tears down every source & layer this manager has attached to the
  /// map. Individual failures are swallowed because a style change may
  /// have already dropped some of them on the native side.
  ///
  /// Images are *not* explicitly removed: the maplibre_gl Dart API
  /// does not expose a `removeImage`, and MapLibre wipes all style
  /// images automatically when a new style is loaded. We only clear
  /// our tracking set so the next [addImage] re-registers them (which
  /// safely overwrites the — by then absent — native entry).
  Future<void> removeAll() async {
    _insertBelowCache.clear();

    if (controller.isDisposed) {
      _layerIds.clear();
      _sourceIds.clear();
      _imageIds.clear();
      return;
    }

    for (final id in _layerIds.toList()) {
      try {
        await controller.removeLayer(id);
      } catch (_) {
        /* ignore */
      }
    }
    _layerIds.clear();

    for (final id in _sourceIds.toList()) {
      try {
        await controller.removeSource(id);
      } catch (_) {
        /* ignore */
      }
    }
    _sourceIds.clear();

    _imageIds.clear();
  }

  Future<String> _resolveInsertBelowLayer({
    required String? belowLayerId,
  }) async {
    final cached = _insertBelowCache[belowLayerId];
    if (cached != null) return cached;

    final topLayers = [
      ...controller.lineManager!.layerIds,
      ...controller.symbolManager!.layerIds,
      ...controller.circleManager!.layerIds,
      ...controller.fillManager!.layerIds,
      ?belowLayerId,
    ];
    final allLayerIds = await controller.getLayerIds();
    final resolved = allLayerIds
        .map((layerId) => layerId.toString())
        .firstWhere((layerId) => topLayers.contains(layerId));
    _insertBelowCache[belowLayerId] = resolved;
    return resolved;
  }
}
