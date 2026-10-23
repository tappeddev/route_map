import 'package:flutter_test/flutter_test.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/route_map_camera_update.dart';

void main() {
  test('animating to a target without tracking keeps a target-only update', () {
    final update = resolveAnimateCameraToTargetUpdate(
      target: const LatLng(30.0, 31.0),
      trackedCameraPosition: null,
    );

    expect(update.toJson(), [
      'newLatLng',
      [30.0, 31.0],
    ]);
  });

  test(
    'animating to a target and zoom without tracking keeps a zoom update',
    () {
      final update = resolveAnimateCameraToTargetUpdate(
        target: const LatLng(30.0, 31.0),
        trackedCameraPosition: null,
        zoom: 12,
      );

      expect(update.toJson(), [
        'newLatLngZoom',
        [30.0, 31.0],
        12.0,
      ]);
    },
  );

  test(
    'bearing or tilt without tracking throws instead of resetting camera',
    () {
      expect(
        () => resolveAnimateCameraToTargetUpdate(
          target: const LatLng(30.0, 31.0),
          trackedCameraPosition: null,
          bearing: 90,
        ),
        throwsStateError,
      );
    },
  );

  test('tracked camera position fills in missing camera fields', () {
    final update = resolveAnimateCameraToTargetUpdate(
      target: const LatLng(30.0, 31.0),
      trackedCameraPosition: const CameraPosition(
        target: LatLng(29.0, 30.0),
        zoom: 9,
        bearing: 45,
        tilt: 20,
      ),
      bearing: 90,
    );

    expect(update.toJson(), [
      'newCameraPosition',
      {
        'bearing': 90.0,
        'target': [30.0, 31.0],
        'tilt': 20.0,
        'zoom': 9.0,
      },
    ]);
  });
}
