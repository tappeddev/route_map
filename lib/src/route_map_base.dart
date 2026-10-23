import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';
import 'package:route_map/src/annotation_manager/route_map_area_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_circle_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_icon_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_layer_manager.dart';
import 'package:route_map/src/annotation_manager/route_map_line_manager.dart';
import 'package:route_map/src/route_map_camera_update.dart';
import 'package:route_map/src/route_map_geometry_extension.dart';
import 'package:route_map/src/utils/coalescing_runner.dart';
import 'package:synchronized/synchronized.dart';

part 'poi_layer_extension.dart';

part 'route_map_controller.dart';

part 'route_map_service_area_layer.dart';

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
  final void Function(CameraPosition cameraPosition)? onCameraMove;
  final VoidCallback? onCameraIdle;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  final bool allowIconsOverlap;

  /// If true, icons are not preserving space allowing other items like POIs to be visible even if they collide with the icon.
  final bool ignoreIconsPlacement;

  /// Enables perspective gestures when the active [styleUrl] supports them.
  final bool tiltGesturesEnabled;

  /// The latest app-provided location fix, forwarded to MapLibre after loading.
  ///
  /// A non-null fix enables the native location indicator. Set this
  /// to null to hide it. New fixes are applied when the widget rebuilds; fixes
  /// received before the style is ready are coalesced to the latest value.
  ///
  /// Uses [ManualLocationSource], so the map does not request location
  /// permission or start the device's location engine.
  final ManualLocationUpdate? location;

  /// Camera follow mode for the native location puck.
  ///
  /// Only applied while [location] is non-null.
  final MyLocationTrackingMode myLocationTrackingMode;

  /// Rendering mode for the native location puck.
  ///
  /// Only applied while [location] is non-null.
  final MyLocationRenderMode myLocationRenderMode;

  /// Called when native camera tracking changes, including user gestures.
  ///
  /// Also reports [MyLocationTrackingMode.none] when [location] is set to
  /// null while tracking.
  final void Function(MyLocationTrackingMode mode)? onCameraTrackingChanged;

  /// Called when a user gesture dismisses native camera tracking.
  final VoidCallback? onCameraTrackingDismissed;
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

  /// Which gestures should be consumed by the map (iOS / Android).
  ///
  /// Needed when the map is inside another widget handling gestures, e.g. a
  /// scrollable page would take the vertical drags away from the map. Pass
  /// `{Factory(() => EagerGestureRecognizer())}` to let the map handle all
  /// gestures. Without recognizers, the map only gets the gestures nobody
  /// else claims.
  ///
  /// It has no effect on web, where the map receives the events directly.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

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
    this.onCameraMove,
    this.onCameraIdle,
    this.onFeatureDrag,
    this.onFeatureHover,
    this.onPoiTapped,
    this.allowIconsOverlap = false,
    this.ignoreIconsPlacement = false,
    this.tiltGesturesEnabled = false,
    this.location,
    this.myLocationTrackingMode = MyLocationTrackingMode.none,
    this.myLocationRenderMode = MyLocationRenderMode.normal,
    this.onCameraTrackingChanged,
    this.onCameraTrackingDismissed,
    this.gestureRecognizers,
  });

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  final _fullyLoadedCompleter = Completer<void>();
  final _disposedCompleter = Completer<void>();
  final _controllerCompleter = Completer<MapLibreMapController>();
  bool _wasCameraMoving = false;
  VoidCallback? _cameraStateListener;
  ManualLocationUpdate? _lastLocation;

  // Incremented when the location or style changes. An in-flight
  // update may only mark its fix as applied if its captured revision still
  // matches, so an older completion cannot suppress a required resend.
  int _locationRevision = 0;

  late final _locationUpdateRunner = CoalescingRunner(
    _syncLocation,
    shouldRerun: () => mounted,
  );

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

  // Set in onMapCreated. Use them only after [_waitForStyleReady], which also
  // waits for an in-progress style reload to finish.
  late final RouteMapIconManager _iconManager;

  late final RouteMapLineManager _lineManager;

  late final RouteMapCircleManager _circleManager;

  late final RouteMapLayerManager _layerManager;

  late final RouteMapAreaManager _areaManager;

  /// Currently materialised POI layers (keyed by layer identifier).
  final Map<String, _PoiLayerEntry> _poiLayers = {};

  Future<MapLibreMapController> get _controller => _controllerCompleter.future;

  @override
  void initState() {
    super.initState();
    widget.controller._attachState(this);
    _scheduleLocationUpdate();
  }

  @override
  void dispose() {
    _disposedCompleter.complete();
    _removeListeners();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RouteMap oldWidget) {
    if (widget.locale != oldWidget.locale) {
      _setMapLanguage();
    }
    if (widget.location != oldWidget.location) {
      _locationRevision++;
      _lastLocation = null;
      _scheduleLocationUpdate();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _scheduleLocationUpdate() {
    // Let MapLibre apply the new source/visibility options before sending fixes.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _locationUpdateRunner.schedule();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> _syncLocation() async {
    // Handle failures per attempt so a queued newer fix still gets its turn.
    try {
      await _applyLocation();
    } catch (error, stack) {
      if (!mounted) return;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'route_map',
          context: ErrorDescription('while updating the native location'),
        ),
      );
    }
  }

  Future<void> _applyLocation() async {
    if (widget.location == null) {
      _lastLocation = null;
      return;
    }
    await _waitForStyleReady();
    if (!mounted) return;

    final controller = await _controller;
    if (!mounted) return;
    final location = widget.location;
    if (location == null) {
      _lastLocation = null;
      return;
    }
    if (identical(location, _lastLocation)) return;
    final revision = _locationRevision;
    await controller.updateManualLocation(location);
    if (_locationRevision == revision) _lastLocation = location;
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
    await _waitForStyleReady();
    if (!mounted) return;
    widget.onFeatureDrag?.call(
      _iconManager.findIconBySymbol(annotation).identifier,
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
    await _waitForStyleReady();
    if (!mounted) return;
    final id = switch (annotation) {
      final Symbol symbol => _iconManager.findIconBySymbol(symbol).identifier,
      final Line line => _lineManager.findRouteByHoveredLine(line)?.identifier,
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
        // Enable the current locations layer, once the location is available
        // Also fine that the first location is null, whenever the location is available, we enable the layer
        myLocationEnabled: widget.location != null,
        locationSource: const ManualLocationSource(),
        // Fall back to the defaults while the location is hidden: MapLibreMap
        // asserts on a non-normal render mode without a location, and iOS
        // shows the location again for any tracking mode other than none.
        myLocationTrackingMode: widget.location != null
            ? widget.myLocationTrackingMode
            : MyLocationTrackingMode.none,
        myLocationRenderMode: widget.location != null
            ? widget.myLocationRenderMode
            : MyLocationRenderMode.normal,
        onCameraTrackingChanged: (mode) =>
            widget.onCameraTrackingChanged?.call(mode),
        onCameraTrackingDismissed: () =>
            widget.onCameraTrackingDismissed?.call(),
        trackCameraPosition: widget.trackCameraPosition,
        cameraTargetBounds:
            widget.cameraTargetBounds ?? CameraTargetBounds.unbounded,
        minMaxZoomPreference:
            widget.minMaxZoomPreference ?? MinMaxZoomPreference.unbounded,
        // Perspective gestures are opt-in because not every style supports 3D.
        // https://www.nextpit.com/forum/561686/how-to-use-google-maps-secret-gestures
        tiltGesturesEnabled: widget.tiltGesturesEnabled,
        gestureRecognizers: widget.gestureRecognizers,
        onMapClick: widget.onMapClicked,
        onCameraMove: (position) => widget.onCameraMove?.call(position),
        onCameraIdle: widget.onCameraIdle,
        onMapCreated: (controller) {
          _iconManager = RouteMapIconManager(controller: controller);
          _lineManager = RouteMapLineManager(controller: controller);
          _circleManager = RouteMapCircleManager(controller: controller);
          _layerManager = RouteMapLayerManager(controller: controller);
          _areaManager = RouteMapAreaManager(
            controller: controller,
            layerManager: _layerManager,
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
            // Therefore, we use a lock which is awaited in [_waitForStyleReady].
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
    await _layerManager.removeAll();
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
    _locationRevision++;
    _lastLocation = null;
    _scheduleLocationUpdate();
  }

  Future<void> _setMapLanguage() async {
    final controller = await _controller;
    if (!mounted) return;
    await controller.setMapLanguage(widget.locale);
  }

  Future<void> _restoreAllGeometry() async {
    final brightness = MediaQuery.platformBrightnessOf(context);

    // The areas are style layers, which were removed together with the
    // other style content, so they have to be added again. This isn't done in
    // parallel with the annotations, since the layers are inserted relative to
    // the annotation layers.
    await _areaManager.restore(brightness);
    if (!mounted) return;

    await Future.wait([
      _lineManager.restore(brightness),
      _iconManager.restore(brightness),
      _circleManager.restore(brightness),
    ]);
  }

  Future<void> _setOverlap() async {
    final controller = await _controller;
    await controller.setSymbolIconAllowOverlap(widget.allowIconsOverlap);
  }

  /// Waits until the native map is created, or until the map is disposed.
  /// Check [mounted] right after, before using the controller.
  Future<void> _waitForMapCreated() async {
    await Future.any([_controllerCompleter.future, _disposedCompleter.future]);
  }

  /// Waits until the style is ready, or until the map is disposed. Check
  /// [mounted] right after, before using the managers.
  Future<void> _waitForStyleReady() async {
    await Future.any([_fullyLoadedCompleter.future, _disposedCompleter.future]);
    if (!mounted) return;
    await _mapStyleLoadLock.synchronized(() async {});
  }
}
