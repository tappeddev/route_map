import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:vector_map/vector_map_current_location_extensions.dart';
import 'package:vector_map/vector_map_geometry_extension.dart';
import 'package:vector_map/vector_map_icon/vector_map_icon.dart';
import 'package:vector_map/vector_map_icon_manager.dart';
import 'package:vector_map/vector_map_layer_extensions.dart';
import 'package:vector_map/vector_map_line_manager.dart';

// Export
export 'package:maplibre_gl/maplibre_gl.dart';

export 'vector_map_icon/vector_map_icon.dart';
export 'vector_map_icon_anchor.dart';

part 'vector_map_manager.dart';

class VectorMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final void Function(VectorMapManager) onLoaded;

  /// Will be called whenever the user clicks on an specify point on the map.
  /// It doesn't matter if the user long presses or just a short tap on any point.
  /// The received [LatLng] is the click point of the user.
  final bool Function() isTouchFeedbackEnabled;
  final void Function(LatLng location) onMapClicked;
  final EdgeInsets zoomPadding;
  final Color lineColor;
  final Color lineBackgroundColor;
  final String locale;
  final String styleUrl;
  final CameraTargetBounds? cameraTargetBounds;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final ServiceAreaLayer? serviceAreaLayer;

  const VectorMap({
    super.key,
    this.initialCameraPosition = const CameraPosition(
      target: LatLng(48.577983, 7.734238),
      zoom: 13,
    ),
    required this.onMapClicked,
    required this.isTouchFeedbackEnabled,
    required this.zoomPadding,
    required this.lineColor,
    required this.lineBackgroundColor,
    required this.locale,
    required this.styleUrl,
    required this.onLoaded,
    this.cameraTargetBounds,
    this.minMaxZoomPreference,
    this.serviceAreaLayer,
  });

  @override
  State<VectorMap> createState() => VectorMapState();
}

class VectorMapState extends State<VectorMap> {
  /// This value is used to check if the zoom needs to be adjusted during the [CameraUpdate] or not.
  /// The current zoom +- [acceptedZoomPadding] is fine and there is no need to change anything.
  @visibleForTesting
  static const acceptedZoomPadding = 1.0;

  MapLibreMapController? controller;
  late final _manager = VectorMapManager(this);
  final initializationCompleter = Completer();

  late final _iconManager = VectorMapIconManager(controller: controller!);
  late final _lineManager = VectorMapLineManager(
    controller: controller!,
    lineColor: () => widget.lineColor,
    lineBackgroundColor: () => widget.lineBackgroundColor,
  );

  @override
  void didUpdateWidget(covariant VectorMap oldWidget) {
    if (widget.locale != oldWidget.locale) {
      _setMapLanguage();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // the [PlatformView] could get the focus, but it doesn't make any sense
    return ExcludeFocus(
      child: MapLibreMap(
        initialCameraPosition: widget.initialCameraPosition,
        // ⚠️ MapBox styles are not supported! -> https://github.com/maplibre/flutter-maplibre-gl/issues/149
        styleString: widget.styleUrl,
        compassEnabled: false,
        // We show an custom indicator for the current location, since we want some custom handling.
        myLocationEnabled: false,
        cameraTargetBounds:
            widget.cameraTargetBounds ?? CameraTargetBounds.unbounded,
        minMaxZoomPreference:
            widget.minMaxZoomPreference ?? MinMaxZoomPreference.unbounded,
        // We disable the different perspective, since the style doesn't
        // support that feature in 3d.
        // https://www.nextpit.com/forum/561686/how-to-use-google-maps-secret-gestures
        tiltGesturesEnabled: false,
        onMapClick: (_, latLng) {
          final isTouchEnabled = widget.isTouchFeedbackEnabled();

          if (!isTouchEnabled) {
            return;
          }

          widget.onMapClicked(latLng);
        },
        onMapCreated: (c) => controller = c,
        onStyleLoadedCallback: () async {
          if (widget.serviceAreaLayer != null) {
            await addServiceAreaLayer(
              serviceAreaLayer: widget.serviceAreaLayer!,
            );
          }

          await _setMapLanguage();
          if (!initializationCompleter.isCompleted) {
            widget.onLoaded(_manager);
            initializationCompleter.complete();
          }

          _scheduleGeometryRedraw();
        },
        // Need to be true to receive the change events from the move, zoom and scale events
        // that are done with the [MaplibreMapController]
        trackCameraPosition: true,
        annotationOrder: const [
          AnnotationType.fill,
          AnnotationType.circle,
          AnnotationType.line,
          AnnotationType.symbol,
        ],
      ),
    );
  }

  Future<void> _setMapLanguage() async {
    await controller!.setMapLanguage(widget.locale);
  }

  Future<void> _scheduleGeometryRedraw() async {
    final routes = await _lineManager.beforeRestore();
    final symbols = await _iconManager.beforeRestore();

    if (!mounted) return;

    await (_lineManager).restore(routes);

    if (!mounted) return;

    await (_iconManager).restore(symbols);
  }
}
