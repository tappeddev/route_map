import 'package:maplibre_gl/maplibre_gl.dart';

class RouteMapCircleManager {
  final MapLibreMapController controller;

  Circle? _accuracyCircle;
  Circle? _indicatorCircle;

  RouteMapCircleManager({required this.controller});

  Future<void> drawUserLocationCircles({
    required CircleOptions accuracyOptions,
    required CircleOptions? indicatorOptions,
  }) async {
    if (_accuracyCircle == null) {
      _accuracyCircle = await controller.addCircle(accuracyOptions);
    } else {
      await controller.updateCircle(_accuracyCircle!, accuracyOptions);
    }
    if (controller.isDisposed) return;

    if (indicatorOptions == null) {
      await removeIndicatorCircle();
      return;
    }

    if (_indicatorCircle == null) {
      _indicatorCircle = await controller.addCircle(indicatorOptions);
      return;
    }

    await controller.updateCircle(_indicatorCircle!, indicatorOptions);
  }

  Future<void> removeIndicatorCircle() async {
    final indicatorCircle = _indicatorCircle;
    if (indicatorCircle == null) return;
    await controller.removeCircle(indicatorCircle);
    _indicatorCircle = null;
  }

  Future<void> removeUserLocationCircles() async {
    final removals = <Future<void>>[
      if (_accuracyCircle != null) controller.removeCircle(_accuracyCircle!),
      if (_indicatorCircle != null) controller.removeCircle(_indicatorCircle!),
    ];
    if (removals.isEmpty) return;
    await Future.wait(removals);
    _accuracyCircle = null;
    _indicatorCircle = null;
  }
}
