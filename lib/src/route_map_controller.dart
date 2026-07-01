part of 'route_map_base.dart';

class RouteMapController {
  final _stateCompleter = Completer<_RouteMapState>();

  void _attachState(_RouteMapState state) {
    if (_stateCompleter.isCompleted) return;
    _stateCompleter.complete(state);
  }

  Future<_RouteMapState> get _state async => _stateCompleter.future;

  Future<MapLibreMapController> get _controller async =>
      (await _state)._controller;

  Future<RouteMapLineManager> get _lineManager async =>
      (await _state)._lineManager;

  Future<RouteMapCircleManager> get _circleManager async =>
      (await _state)._circleManager;

  Future<RouteMapIconManager> get _iconManager async =>
      (await _state)._iconManager;

  Future<RouteMapLocationIndicatorCoordinator>
  get _locationIndicatorManager async =>
      (await _state)._locationIndicatorCoordinator;

  Future<bool> get _mounted async => (await _state).mounted;

  Future<CameraPosition?> getCameraPosition() async {
    final controller = await _controller;
    if (!await _mounted) return null;
    return controller.cameraPosition;
  }

  Future<void> drawRoute({
    required RouteMapRoute route,
    required bool animateCamera,
  }) async {
    final lineManager = await _lineManager;
    if (!await _mounted) return;
    await lineManager.drawRoute(route);

    if (!await _mounted) return;

    if (animateCamera) {
      await animateCameraTo(points: route.points);
    }
  }

  Future<void> removeRoutes() async {
    final lineManager = await _lineManager;
    if (!await _mounted) return;
    await lineManager.removeRoutes();
  }

  Future<void> drawIcon(
    RouteMapIcon mapIcon, {
    bool animateCamera = false,
  }) async {
    final iconManager = await _iconManager;
    if (!await _mounted) return;
    await iconManager.drawIcon(mapIcon);
    if (!await _mounted) return;
    if (animateCamera) {
      await animateCameraTo(points: [mapIcon.latLng]);
    }
  }

  Future<void> drawCircle(
    RouteMapCircle circle, {
    bool animateCamera = false,
  }) async {
    final circleManager = await _circleManager;
    if (!await _mounted) return;
    await circleManager.drawCircle(circle);
    if (!await _mounted) return;
    if (animateCamera) {
      await animateCameraTo(points: [circle.latLng]);
    }
  }

  Future<void> removeIcons() async {
    final iconManager = await _iconManager;
    if (!await _mounted) return;
    await iconManager.removeIcons();
  }

  Future<void> removeIconsWhere(bool Function(RouteMapIcon icon) test) async {
    final iconManager = await _iconManager;
    if (!await _mounted) return;
    await iconManager.removeIconsWhere(test);
  }

  Future<void> removeIcon(String identifier) async {
    final iconManager = await _iconManager;
    if (!await _mounted) return;
    await iconManager.removeIcon(identifier: identifier);
  }

  Future<void> removeCircles() async {
    final circleManager = await _circleManager;
    if (!await _mounted) return;
    await circleManager.removeCircles();
  }

  Future<void> removeCircle(String identifier) async {
    final circleManager = await _circleManager;
    if (!await _mounted) return;
    await circleManager.removeCircle(identifier: identifier);
  }

  Future<void> drawUserLocationIndicator(
    RouteMapUserLocationIndicator indicator,
  ) async {
    final locationIndicatorManager = await _locationIndicatorManager;
    if (!await _mounted) return;
    await locationIndicatorManager.drawUserLocationIndicator(indicator);
  }

  Future<void> removeUserLocationIndicator() async {
    final locationIndicatorManager = await _locationIndicatorManager;
    if (!await _mounted) return;
    await locationIndicatorManager.removeUserLocationIndicator();
  }

  /// Pushes an app-provided location into the native user-location component
  /// (the "puck").
  ///
  /// Requires the [RouteMap] to be created with
  /// `enableManualLocationDisplay: true`, which sets up the map with
  /// `myLocationEnabled: true` and a [ManualLocationSource]. No location
  /// permission is required in this mode.
  ///
  /// **Not supported on web** — throws an [UnsupportedError] there.
  Future<void> updateManualLocation({
    required LatLng location,
    double? horizontalAccuracy,
    double? verticalAccuracy,
    double? altitude,
    double? bearing,
    double? speed,
    DateTime? timestamp,
  }) async {
    final controller = await _controller;
    if (!await _mounted) return;
    await controller.updateManualLocation(
      ManualLocationUpdate(
        target: location,
        horizontalAccuracy: horizontalAccuracy,
        verticalAccuracy: verticalAccuracy,
        altitude: altitude,
        bearing: bearing,
        speed: speed,
        timestamp: timestamp,
      ),
    );
  }

  Future<void> animateCameraToTarget({
    required LatLng target,
    double? zoom,
    double? bearing,
    double? tilt,
    Duration duration = const Duration(milliseconds: 1500),
  }) async {
    final controller = await _controller;
    if (!await _mounted) return;

    final cameraUpdate = resolveAnimateCameraToTargetUpdate(
      target: target,
      trackedCameraPosition: controller.cameraPosition,
      zoom: zoom,
      bearing: bearing,
      tilt: tilt,
    );

    await controller.animateCamera(cameraUpdate, duration: duration);
  }

  /// Move cameras center to the [latLng] with zoom in by [detailCameraFocusZoom]
  Future<void> animateCameraTo({required List<LatLng> points}) async {
    final state = await _state;
    final controller = await _controller;
    if (!await _mounted) return;

    final cameraUpdate = await controller.cameraUpdateFrom(
      points: points,
      padding: state.widget.zoomPadding,
    );
    if (!await _mounted) return;

    await controller.animateCamera(
      cameraUpdate,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// Takes a snapshot of the current map view and returns it as PNG bytes.
  ///
  /// The map must be fully loaded and visible before calling this. If tiles
  /// are still rendering, the returned image may contain incomplete content.
  ///
  /// A [TimeoutException] is thrown if the native platform does not respond
  /// within [timeout] (default 10 s).
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
  }) async {
    final state = await _state;
    final controller = await _controller;
    if (!await _mounted) return;

    final entry = state._poiLayers[identifier];
    if (entry == null) return;
    if (entry.isVisible == isVisible) return;

    await state._applyPoiLayerVisibility(
      controller: controller,
      entry: entry,
      isVisible: isVisible,
    );
  }
}
