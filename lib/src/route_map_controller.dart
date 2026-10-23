part of 'route_map_base.dart';

class RouteMapController {
  final _stateCompleter = Completer<_RouteMapState>();

  void _attachState(_RouteMapState state) {
    if (_stateCompleter.isCompleted) return;
    _stateCompleter.complete(state);
  }

  Future<_RouteMapState> get _state async => _stateCompleter.future;

  /// Runs [action] once the native map is created. Skips it and returns null
  /// if the map is disposed first.
  Future<T?> _whenMapCreated<T>(
    FutureOr<T> Function(_RouteMapState state, MapLibreMapController controller)
    action,
  ) async {
    final state = await _state;
    await state._waitForMapCreated();
    if (!state.mounted) return null;
    return action(state, await state._controller);
  }

  /// Runs [action] once the style is ready, so the managers are safe to use.
  /// Skips it and returns null if the map is disposed first.
  Future<T?> _whenStyleReady<T>(
    FutureOr<T> Function(_RouteMapState state) action,
  ) async {
    final state = await _state;
    await state._waitForStyleReady();
    if (!state.mounted) return null;
    return action(state);
  }

  Future<CameraPosition?> getCameraPosition() =>
      _whenMapCreated<CameraPosition?>(
        (_, controller) => controller.cameraPosition,
      );

  Future<void> drawRoute({
    required RouteMapRoute route,
    required bool animateCamera,
  }) async {
    await _whenStyleReady((state) => state._lineManager.drawRoute(route));
    if (animateCamera) {
      await animateCameraTo(points: route.points);
    }
  }

  Future<void> removeRoutes() =>
      _whenStyleReady((state) => state._lineManager.removeRoutes());

  Future<void> drawIcon(
    RouteMapIcon mapIcon, {
    bool animateCamera = false,
  }) async {
    await _whenStyleReady((state) => state._iconManager.drawIcon(mapIcon));
    if (animateCamera) {
      await animateCameraTo(points: [mapIcon.latLng]);
    }
  }

  Future<void> drawCircle(
    RouteMapCircle circle, {
    bool animateCamera = false,
  }) async {
    await _whenStyleReady((state) => state._circleManager.drawCircle(circle));
    if (animateCamera) {
      await animateCameraTo(points: [circle.latLng]);
    }
  }

  Future<void> removeIcons() =>
      _whenStyleReady((state) => state._iconManager.removeIcons());

  Future<void> removeIconsWhere(bool Function(RouteMapIcon icon) test) =>
      _whenStyleReady((state) => state._iconManager.removeIconsWhere(test));

  Future<void> removeIcon(String identifier) => _whenStyleReady(
    (state) => state._iconManager.removeIcon(identifier: identifier),
  );

  Future<void> removeCircles() =>
      _whenStyleReady((state) => state._circleManager.removeCircles());

  Future<void> removeCircle(String identifier) => _whenStyleReady(
    (state) => state._circleManager.removeCircle(identifier: identifier),
  );

  Future<void> drawArea(RouteMapArea area, {bool animateCamera = false}) async {
    await _whenStyleReady((state) => state._areaManager.drawArea(area));
    if (animateCamera) {
      await animateCameraTo(
        points: [for (final polygon in area.polygons) ...polygon.outline],
      );
    }
  }

  Future<void> removeArea(String identifier) => _whenStyleReady(
    (state) => state._areaManager.removeArea(identifier: identifier),
  );

  Future<void> removeAreas() =>
      _whenStyleReady((state) => state._areaManager.removeAreas());

  Future<void> animateCameraToTarget({
    required LatLng target,
    double? zoom,
    double? bearing,
    double? tilt,
    Duration duration = const Duration(milliseconds: 1500),
  }) => _whenMapCreated((state, controller) async {
    final cameraUpdate = resolveAnimateCameraToTargetUpdate(
      target: target,
      // Without tracking, MapLibre keeps reporting the initial camera
      // position, which would reset the zoom and tilt.
      trackedCameraPosition: state.widget.trackCameraPosition
          ? controller.cameraPosition
          : null,
      zoom: zoom,
      bearing: bearing,
      tilt: tilt,
    );

    await controller.animateCamera(cameraUpdate, duration: duration);
  });

  /// Move cameras center to the [latLng] with zoom in by [detailCameraFocusZoom]
  Future<void> animateCameraTo({
    required List<LatLng> points,
    EdgeInsets? padding,
  }) => _whenMapCreated((state, controller) async {
    final cameraUpdate = await controller.cameraUpdateFrom(
      points: points,
      padding: padding ?? state.widget.zoomPadding,
    );
    if (!state.mounted) return;

    await controller.animateCamera(
      cameraUpdate,
      duration: const Duration(milliseconds: 1500),
    );
  });

  /// Captures the visible map as PNG bytes. Call after the map has loaded.
  ///
  /// Includes runtime geometry and custom marker images on Android and iOS.
  /// Throws [TimeoutException] if the native snapshot exceeds [timeout].
  Future<Uint8List> takeSnapshot({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final controller = await _controller;
    return controller.takeSnapshot().timeout(timeout);
  }

  /// Toggles the visibility of a previously-installed POI layer.
  ///
  /// Identifier must match [RouteMapPoiLayer.identifier]. Silently does
  /// nothing when no layer with that identifier is installed.
  Future<void> setPoiLayerVisibility({
    required String identifier,
    required bool isVisible,
  }) => _whenStyleReady((state) async {
    // The POI layers are only installed once the style is ready.
    final controller = await state._controller;
    final entry = state._poiLayers[identifier];
    if (entry == null) return;
    if (entry.isVisible == isVisible) return;

    await state._applyPoiLayerVisibility(
      controller: controller,
      entry: entry,
      isVisible: isVisible,
    );
  });
}
