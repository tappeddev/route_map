part of 'route_map_base.dart';

class RouteMapController {
  late _RouteMapState _state;

  Future<MapLibreMapController> get _controller => _state._controller;

  Future<RouteMapLineManager> get _lineManager => _state._lineManager;

  Future<RouteMapIconManager> get _iconManager => _state._iconManager;

  Future<RouteMapCircleManager> get _circleManager => _state._circleManager;

  bool get _mounted => _state.mounted;

  Future<(String, String?)> drawRoute({
    required RouteMapRoute route,
    required bool animateCamera,
  }) async {
    final lineManager = await _lineManager;
    if (!_mounted) return ('', null);
    final res = await lineManager.drawRoute(route);

    if (!_mounted) return ('', null);

    if (animateCamera) {
      await animateCameraTo(points: route.points);
    }
    return res;
  }

  Future<void> removeRoute() async {
    final lineManager = await _lineManager;
    if (!_mounted) return;
    await lineManager.removeRoutes();
  }

  Future<void> drawIcon(
    RouteMapIcon mapIcon, {
    bool animateCamera = false,
  }) async {
    final iconManager = await _iconManager;
    if (!_mounted) return;
    await iconManager.drawIcon(mapIcon);
    if (!_mounted) return;
    if (animateCamera) {
      await animateCameraTo(points: [mapIcon.latLng]);
    }
  }

  Future<void> removeIcons() async {
    final iconManager = await _iconManager;
    if (!_mounted) return;
    await iconManager.removeIcons();
  }

  Future<void> removeIconsWhere(bool Function(RouteMapIcon icon) test) async {
    final iconManager = await _iconManager;
    if (!_mounted) return;
    await iconManager.removeIconsWhere(test);
  }

  Future<void> removeIcon(String identifier) async {
    final iconManager = await _iconManager;
    if (!_mounted) return;
    await iconManager.removeIcon(identifier: identifier);
  }

  Future<void> drawUserLocationIndicator(
    RouteMapUserLocationIndicator indicator,
  ) async {
    final circleManager = await _circleManager;
    if (!_mounted) return;
    await circleManager.drawUserLocationIndicator(indicator);
  }

  Future<void> removeUserLocationIndicator() async {
    final circleManager = await _circleManager;
    if (!_mounted) return;
    await circleManager.removeUserLocationIndicator();
  }

  /// Move cameras center to the [latLng] with zoom in by [detailCameraFocusZoom]
  Future<void> animateCameraTo({required List<LatLng> points}) async {
    final controller = await _controller;
    if (!_mounted) return;

    final cameraUpdate = await controller.cameraUpdateFrom(
      points: points,
      additionalPadding: _state.widget.zoomPadding,
    );
    if (!_mounted) return;

    await controller.animateCamera(
      cameraUpdate,
      duration: const Duration(milliseconds: 1500),
    );
  }
}
