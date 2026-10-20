import 'package:maplibre_gl/maplibre_gl.dart';

CameraUpdate resolveAnimateCameraToTargetUpdate({
  required LatLng target,
  required CameraPosition? trackedCameraPosition,
  bool trackCameraPosition = false,
  CameraPosition? fallbackCameraPosition,
  double? zoom,
  double? bearing,
  double? tilt,
}) {
  if (bearing == null && tilt == null) {
    if (zoom == null) {
      return CameraUpdate.newLatLng(target);
    }
    return CameraUpdate.newLatLngZoom(target, zoom);
  }

  final currentCameraPosition = trackedCameraPosition;
  if (currentCameraPosition == null) {
    if (trackCameraPosition) {
      return CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: zoom ?? fallbackCameraPosition?.zoom ?? 0,
          bearing: bearing ?? fallbackCameraPosition?.bearing ?? 0,
          tilt: tilt ?? fallbackCameraPosition?.tilt ?? 0,
        ),
      );
    }

    throw StateError(
      'RouteMap.trackCameraPosition must be true when bearing or tilt is provided.',
    );
  }

  return CameraUpdate.newCameraPosition(
    CameraPosition(
      target: target,
      zoom: zoom ?? currentCameraPosition.zoom,
      bearing: bearing ?? currentCameraPosition.bearing,
      tilt: tilt ?? currentCameraPosition.tilt,
    ),
  );
}
