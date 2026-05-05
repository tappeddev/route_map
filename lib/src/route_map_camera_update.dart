import 'package:maplibre_gl/maplibre_gl.dart';

CameraUpdate resolveAnimateCameraToTargetUpdate({
  required LatLng target,
  required CameraPosition? trackedCameraPosition,
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
