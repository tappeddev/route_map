import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';
import 'package:route_map/src/manager/route_map_circle_manager.dart';
import 'package:route_map/src/manager/route_map_icon_manager.dart';
import 'package:route_map/src/manager/route_map_line_manager.dart';
import 'package:route_map/src/route_map_geometry_extension.dart';

part 'route_map_controller.dart';

class RouteMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final void Function(Point point, LatLng location) onMapClicked;
  final EdgeInsets zoomPadding;
  final String locale;
  final String styleUrl;
  final CameraTargetBounds? cameraTargetBounds;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final NoServiceAreaLayer? noServiceAreaLayer;
  final RouteMapController controller;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  final bool allowIconsOverlap;

  /// If true, icons are not preserving space allowing other items like POIs to be visible even if they collide with the icon.
  final bool ignoreIconsPlacement;
  final void Function(
    String identifier,
    LatLng current,
    LatLng origin,
    DragEventType eventType,
  )?
  onFeatureDrag;
  final void Function(
    String identifier,
    LatLng latLng,
    HoverEventType eventType,
  )?
  onFeatureHover;

  const RouteMap({
    super.key,
    required this.initialCameraPosition,
    required this.controller,
    required this.onMapClicked,
    required this.zoomPadding,
    required this.locale,
    required this.styleUrl,
    this.cameraTargetBounds,
    this.minMaxZoomPreference,
    this.noServiceAreaLayer,
    this.onFeatureDrag,
    this.onFeatureHover,
    this.allowIconsOverlap = false,
    this.ignoreIconsPlacement = false,
  });

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final _controllerCompleter = Completer<MapLibreMapController>();
  final _mapCreatedCompleter = Completer<MapLibreMapController>();
  final _iconManagerCompleter = Completer<RouteMapIconManager>();
  final _lineManagerCompleter = Completer<RouteMapLineManager>();
  final _circleManagerCompleter = Completer<RouteMapCircleManager>();

  Future<MapLibreMapController> get _controller => _mapCreatedCompleter.future;

  Future<RouteMapIconManager> get _iconManager => _iconManagerCompleter.future;

  Future<RouteMapLineManager> get _lineManager => _lineManagerCompleter.future;

  Future<RouteMapCircleManager> get _circleManager =>
      _circleManagerCompleter.future;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RouteMap oldWidget) {
    if (widget.locale != oldWidget.locale) {
      _setMapLanguage();
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _removeListeners() async {
    if (!_mapCreatedCompleter.isCompleted) return;
    final controller = await _mapCreatedCompleter.future;
    controller.onFeatureDrag.remove(_onFeatureDrag);
    if (kIsWeb) {
      controller.onFeatureHover.remove(_onFeatureHover);
    }
  }

  Future<void> _onFeatureDrag(
    Point<double> point,
    LatLng origin,
    LatLng current,
    LatLng delta,
    String id,
    Annotation? annotation,
    DragEventType eventType,
  ) async {
    final iconManager = await _iconManager;
    widget.onFeatureDrag?.call(
      annotation is Symbol
          ? iconManager.findIconBySymbol(annotation).identifier
          : id,
      annotation is Symbol ? annotation.options.geometry! : current,
      origin,
      eventType,
    );
  }

  Future<void> _onFeatureHover(
    Point<double> point,
    LatLng latLng,
    String id,
    Annotation? annotation,
    HoverEventType eventType,
  ) async {
    final iconManager = await _iconManager;
    widget.onFeatureHover?.call(
      annotation is Symbol
          ? iconManager.findIconBySymbol(annotation).identifier
          : id,
      latLng,
      eventType,
    );
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
        myLocationEnabled: false,
        cameraTargetBounds:
            widget.cameraTargetBounds ?? CameraTargetBounds.unbounded,
        minMaxZoomPreference:
            widget.minMaxZoomPreference ?? MinMaxZoomPreference.unbounded,
        // We disable the different perspective, since the style doesn't
        // support that feature in 3d.
        // https://www.nextpit.com/forum/561686/how-to-use-google-maps-secret-gestures
        tiltGesturesEnabled: false,
        onMapClick: widget.onMapClicked,
        onMapCreated: (controller) {
          _mapCreatedCompleter.complete(controller);
          controller.onFeatureDrag.add(_onFeatureDrag);
          if (kIsWeb) {
            controller.onFeatureHover.add(_onFeatureHover);
          }
        },
        onStyleLoadedCallback: () async {
          if (!_controllerCompleter.isCompleted) {
            await _completeInit();
          }

          await _addNoServiceAreaLayer();

          await _setMapLanguage();

          unawaited(_setOverlap());

          await _scheduleGeometryRedraw();
        },
        annotationOrder: const [
          AnnotationType.fill,
          AnnotationType.circle,
          AnnotationType.line,
          AnnotationType.symbol,
        ],
      ),
    );
  }

  Future<void> _completeInit() async {
    final controller = await _mapCreatedCompleter.future;
    final iconManager = RouteMapIconManager(controller: controller);
    final lineManager = RouteMapLineManager(controller: controller);
    final circleManager = RouteMapCircleManager(controller: controller);
    _controllerCompleter.complete(controller);
    _iconManagerCompleter.complete(iconManager);
    _lineManagerCompleter.complete(lineManager);
    _circleManagerCompleter.complete(circleManager);
  }

  Future<void> _setMapLanguage() async {
    final controller = await _controller;
    if (!mounted) return;
    await controller.setMapLanguage(widget.locale);
  }

  Future<void> _scheduleGeometryRedraw() async {
    final lineManager = await _lineManager;
    final symbolManager = await _iconManager;
    final circleManger = await _circleManager;

    if (!mounted) return;
    final brightness = MediaQuery.platformBrightnessOf(context);
    await Future.wait([
      lineManager.restore(brightness),
      symbolManager.restore(brightness),
      circleManger.restore(brightness),
    ]);
  }

  Future<void> _setOverlap() async {
    final controller = await _controller;
    await controller.setSymbolIconAllowOverlap(widget.allowIconsOverlap);
  }

  Future<void> _addNoServiceAreaLayer() async {
    final noServiceAreaLayer = widget.noServiceAreaLayer;
    if (noServiceAreaLayer == null) return;
    final controller = await _controller;
    if (!mounted) return;

    /// The no service layer needs to be below the manager layers, to show
    /// all lines, icons, images above the grey layer and not below.
    final belowLayerId = noServiceAreaLayer.belowLayerId;

    final topLayers = [
      ...controller.lineManager!.layerIds,
      ...controller.symbolManager!.layerIds,
      ...controller.circleManager!.layerIds,
      ...controller.fillManager!.layerIds,
      if (belowLayerId != null) belowLayerId,
    ];
    final allLayerIds = await controller.getLayerIds();

    final insertBelowLayer = allLayerIds
        .map((layerId) => layerId.toString())
        .firstWhere((layerId) => topLayers.contains(layerId));

    if (!mounted) return;

    final source = await noServiceAreaLayer.createSource();

    if (!mounted) return;

    const sourceId = "no_service_area_source_id";
    await controller.addSource(sourceId, source);
    if (!mounted) return;

    await controller.addLayer(
      sourceId,
      "no_service_area_layer_id",
      FillLayerProperties(
        fillColor: noServiceAreaLayer.fillColor.toHexStringRGB(),
        fillOpacity: noServiceAreaLayer.fillColor.a,
      ),
      belowLayerId: insertBelowLayer,
      enableInteraction: false,
    );
  }
}
