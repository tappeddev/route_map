import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';
import 'package:route_map/src/coordinator/route_map_location_indicator_coordinator.dart';
import 'package:route_map/src/annotation_manager/route_map_circle_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_icon_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_layer_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_line_manager.dart';
import 'package:route_map/src/route_map_camera_update.dart';
import 'package:route_map/src/route_map_geometry_extension.dart';
import 'package:route_map/src/utils/coalescing_runner.dart';
import 'package:synchronized/synchronized.dart';

part 'route_map_controller.dart';

part 'route_map_service_area_layer.dart';

part 'poi_layer_extension.dart';

class RouteMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final void Function(Point point, LatLng location) onMapClicked;
  final EdgeInsets zoomPadding;
  final String locale;
  final String styleUrl;
  final CameraTargetBounds? cameraTargetBounds;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final List<ServiceAreaLayer> serviceAreaLayers;
  final RouteMapController controller;
  final bool trackCameraPosition;
  final VoidCallback? onCameraMoveStarted;
  final VoidCallback? onCameraIdle;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  final bool allowIconsOverlap;

  /// If true, icons are not preserving space allowing other items like POIs to be visible even if they collide with the icon.
  final bool ignoreIconsPlacement;

  /// Enables the native user-location component (the "puck") driven by
  /// app-provided locations.
  ///
  /// When `true`, the map is created with `myLocationEnabled: true` and a
  /// [ManualLocationSource], so no location permission is requested and the
  /// device's location engine is not used. Push locations into the puck via
  /// [RouteMapController.updateManualLocation].
  ///
  /// This is independent of the custom indicator drawn by
  /// [RouteMapController.drawUserLocationIndicator]; enable only one to avoid
  /// showing two indicators at once.
  ///
  /// **Not supported on web** — pushing a manual location throws there.
  final bool enableManualLocationDisplay;

  /// Defines how the map's camera follows the user-location "puck".
  ///
  /// Only relevant when [enableManualLocationDisplay] is `true`.
  final MyLocationTrackingMode myLocationTrackingMode;

  /// Defines how the user-location "puck" is rendered.
  ///
  /// Only relevant when [enableManualLocationDisplay] is `true`.
  final MyLocationRenderMode myLocationRenderMode;

  /// Called when the camera tracking mode changes, e.g. when the user pans
  /// the map and tracking is disengaged.
  final void Function(MyLocationTrackingMode mode)? onCameraTrackingChanged;

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

  /// Optional clustered POI overlays (e.g. service points, border crossings).
  /// Each entry is materialised when the map's style is loaded; visibility
  /// can later be toggled through [RouteMapController.setPoiLayerVisibility].
  final List<RouteMapPoiLayer> poiLayers;

  /// Called when the user taps a feature of an interactive
  /// [RouteMapPoiCategory] (see [RouteMapPoiCategory.interactive]).
  final void Function(RouteMapPoiTappedEvent event)? onPoiTapped;

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
    this.serviceAreaLayers = const [],
    this.poiLayers = const [],
    this.trackCameraPosition = false,
    this.onCameraMoveStarted,
    this.onCameraIdle,
    this.onFeatureDrag,
    this.onFeatureHover,
    this.onPoiTapped,
    this.allowIconsOverlap = false,
    this.ignoreIconsPlacement = false,
    this.enableManualLocationDisplay = false,
    this.myLocationTrackingMode = MyLocationTrackingMode.none,
    this.myLocationRenderMode = MyLocationRenderMode.normal,
    this.onCameraTrackingChanged,
  });

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final _fullyLoadedCompleter = Completer<void>();
  final _controllerCompleter = Completer<MapLibreMapController>();
  bool _wasCameraMoving = false;
  VoidCallback? _cameraStateListener;

  final _mapStyleLoadLock = Lock();

  /// Coordinates concurrent `onStyleLoadedCallback` invocations.
  /// MapLibre fires the callback on initial construction *and* on
  /// every subsequent style change (theme switch, style-url reload),
  /// sometimes twice in quick succession. Overlapping installs would
  /// race the shared layer state, so the runner ensures at most one
  /// install runs at a time and folds any fires that arrive
  /// mid-install into a single trailing rerun — enough to pick up
  /// whatever caused the latest fire without executing every fire
  /// individually.
  late final _installRunner = CoalescingRunner(
    _installStyleContent,
    shouldRerun: () => mounted,
  );

  late final RouteMapIconManager _iconManagerInstance;

  late final RouteMapLineManager _lineManagerInstance;

  late final RouteMapCircleManager _circleManagerInstance;

  late final RouteMapLayerManager _layerManagerInstance;

  late final RouteMapLocationIndicatorCoordinator
  _locationIndicatorCoordinatorInstance;

  /// Currently materialised POI layers (keyed by layer identifier).
  final Map<String, _PoiLayerEntry> _poiLayers = {};

  Future<MapLibreMapController> get _controller => _controllerCompleter.future;

  Future<RouteMapIconManager> get _iconManager async {
    // wait for style and restore to complete
    await _afterStyleReady();
    return _iconManagerInstance;
  }

  Future<RouteMapLineManager> get _lineManager async {
    await _afterStyleReady();
    return _lineManagerInstance;
  }

  Future<RouteMapCircleManager> get _circleManager async {
    await _afterStyleReady();
    return _circleManagerInstance;
  }

  Future<RouteMapLocationIndicatorCoordinator>
  get _locationIndicatorCoordinator async {
    await _afterStyleReady();
    return _locationIndicatorCoordinatorInstance;
  }

  @override
  void initState() {
    super.initState();
    widget.controller._attachState(this);
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
    if (!_controllerCompleter.isCompleted) return;
    final controller = await _controllerCompleter.future;
    controller.onFeatureDrag.remove(_onFeatureDrag);
    controller.onFeatureTapped.remove(_onFeatureTapped);
    if (kIsWeb) {
      controller.onFeatureHover.remove(_onFeatureHover);
    }
    final cameraStateListener = _cameraStateListener;
    if (cameraStateListener != null) {
      controller.removeListener(cameraStateListener);
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
    /// Dragging feature was only added to icons
    if (annotation is! Symbol) return;
    final iconManager = await _iconManager;
    widget.onFeatureDrag?.call(
      iconManager.findIconBySymbol(annotation).identifier,
      annotation.options.geometry!,
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
    final lineManager = await _lineManager;
    final id = switch (annotation) {
      final Symbol symbol => iconManager.findIconBySymbol(symbol).identifier,
      final Line line => lineManager.findRouteByHoveredLine(line)?.identifier,
      _ => null,
    };
    if (id == null) return;
    widget.onFeatureHover?.call(id, latLng, eventType);
  }

  /// Looks up the [RouteMapPoiCategory] (if any) for the layer-id reported
  /// by maplibre's tap event and forwards the event to the caller via
  /// [RouteMap.onPoiTapped].
  void _onFeatureTapped(
    Point<double> point,
    LatLng latLng,
    String featureId,
    String layerId,
    Annotation? annotation,
  ) {
    final onPoiTapped = widget.onPoiTapped;
    if (onPoiTapped == null) return;

    final match = _findPoiCategoryByLayerId(layerId);
    if (match == null) return;

    onPoiTapped(
      RouteMapPoiTappedEvent(
        layerIdentifier: match.layer.identifier,
        categoryIdentifier: match.category.identifier,
        featureId: featureId,
        latLng: latLng,
      ),
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
        myLocationEnabled: widget.enableManualLocationDisplay,
        myLocationTrackingMode: widget.myLocationTrackingMode,
        myLocationRenderMode: widget.myLocationRenderMode,
        onCameraTrackingChanged: widget.onCameraTrackingChanged,
        locationSource: widget.enableManualLocationDisplay
            ? const ManualLocationSource()
            : const PlatformLocationSource(),
        trackCameraPosition: widget.trackCameraPosition,
        cameraTargetBounds:
            widget.cameraTargetBounds ?? CameraTargetBounds.unbounded,
        minMaxZoomPreference:
            widget.minMaxZoomPreference ?? MinMaxZoomPreference.unbounded,
        // We disable the different perspective, since the style doesn't
        // support that feature in 3d.
        // https://www.nextpit.com/forum/561686/how-to-use-google-maps-secret-gestures
        tiltGesturesEnabled: false,
        onMapClick: widget.onMapClicked,
        onCameraIdle: widget.onCameraIdle,
        onMapCreated: (controller) {
          _iconManagerInstance = RouteMapIconManager(controller: controller);
          _lineManagerInstance = RouteMapLineManager(controller: controller);
          _circleManagerInstance = RouteMapCircleManager(
            controller: controller,
          );
          _layerManagerInstance = RouteMapLayerManager(controller: controller);
          _locationIndicatorCoordinatorInstance =
              RouteMapLocationIndicatorCoordinator(
                circleManager: _circleManagerInstance,
                iconManager: _iconManagerInstance,
              );
          _controllerCompleter.complete(controller);
          _cameraStateListener = () {
            final isCameraMoving = controller.isCameraMoving;
            if (isCameraMoving && !_wasCameraMoving) {
              widget.onCameraMoveStarted?.call();
            }
            _wasCameraMoving = isCameraMoving;
          };
          controller.addListener(_cameraStateListener!);

          controller.onFeatureDrag.add(_onFeatureDrag);
          controller.onFeatureTapped.add(_onFeatureTapped);
          if (kIsWeb) {
            controller.onFeatureHover.add(_onFeatureHover);
          }
        },
        onStyleLoadedCallback: () =>
            // We might run into the issue that we have concurrent calls of onStyleLoadedCallback.
            // _installRunner makes sure that we only run one at a time and coalesce overlapping calls.
            // However, our managers are not safe and should only be used after all concurrent calls have finished.
            // Therefore, we use a lock which is awaited in [_afterStyleReady].
            _mapStyleLoadLock.synchronized(_installRunner.schedule),
        annotationOrder: const [
          AnnotationType.fill,
          AnnotationType.line,
          AnnotationType.symbol,
          AnnotationType.circle,
        ],
      ),
    );
  }

  Future<void> _installStyleContent() async {
    if (!mounted) return;

    _poiLayers.clear();
    await _layerManagerInstance.removeAll();
    if (!mounted) return;

    await _addServiceAreaLayers();
    if (!mounted) return;
    await _addPoiLayers();
    if (!mounted) return;

    await _setMapLanguage();
    if (!mounted) return;

    unawaited(_setOverlap());

    await _restoreAllGeometry();

    if (!_fullyLoadedCompleter.isCompleted) {
      _fullyLoadedCompleter.complete();
    }
  }

  Future<void> _setMapLanguage() async {
    final controller = await _controller;
    if (!mounted) return;
    await controller.setMapLanguage(widget.locale);
  }

  Future<void> _restoreAllGeometry() async {
    // Use [_lineManagerInstance] directly instead of [_lineManager]
    // because _fullyLoadedCompleter is not completed yet
    final lineManager = _lineManagerInstance;
    final symbolManager = _iconManagerInstance;
    final circleManager = _circleManagerInstance;

    final brightness = MediaQuery.platformBrightnessOf(context);
    await Future.wait([
      lineManager.restore(brightness),
      symbolManager.restore(brightness),
      circleManager.restore(brightness),
    ]);
  }

  Future<void> _setOverlap() async {
    final controller = await _controller;
    await controller.setSymbolIconAllowOverlap(widget.allowIconsOverlap);
  }

  Future<void> _afterStyleReady() async {
    await _fullyLoadedCompleter.future;
    await _mapStyleLoadLock.synchronized(() async {});
  }
}
