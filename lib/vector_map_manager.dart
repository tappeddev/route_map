part of 'vector_map.dart';

class VectorMapManager {
  final VectorMapState _state;

  VectorMapManager(this._state);

  MapLibreMapController get controller => _state.controller!;

  Future<void> drawRoute({
    required List<LatLng> points,
    required bool animateCamera,
  }) async {
    await _state._lineManager.drawRoute(points: points);

    if (!_state.mounted) return;

    if (animateCamera) {
      await animateCameraTo(points: points);
    }
  }

  Future<void> removeRoute() async {
    await _state._lineManager.removeRoutes();
  }

  Future<String> drawIcon(
    VectorMapIcon mapIcon, {
    bool animateCamera = false,
  }) async {
    final symbolId = await _state._iconManager.drawIcon(mapIcon);

    if (!_state.mounted) return symbolId;

    if (animateCamera) {
      await animateCameraTo(points: [mapIcon.latLng]);
    }
    return symbolId;
  }

  Future<void> removeIcons() async {
    await _state._iconManager.removeIcons();
  }

  Future<void> removeViaIcons() async {
    await _state._iconManager.removeViaIcons();
  }

  Future<void> removeIcon({required String identifier}) async {
    await _state._iconManager.removeIcon(identifier: identifier);
  }

  /// Move cameras center to the [latLng] with zoom in by [detailCameraFocusZoom]
  Future<void> animateCameraTo({required List<LatLng> points}) async {
    final cameraUpdate = await controller.cameraUpdateFrom(
      points: points,
      additionalPadding: _state.widget.zoomPadding,
    );

    await controller.animateCamera(
      cameraUpdate,
      duration: const Duration(milliseconds: 1500),
    );
  }

  Future<void> drawCurrentLocation({required LatLng location}) async {
    await controller.drawCurrentLocationIndicatorAt(
      latLng: location,
      color: Colors.blue,
    );
  }

  Future<void> removeCurrentLocation() async {
    for (final circle in controller.circles) {
      await controller.removeCircle(circle);
    }
  }
}
