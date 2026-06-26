import 'dart:ui';

import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_icon/route_map_icon.dart';
import 'package:route_map/src/model/route_map_icon_anchor.dart';

/// Describes a clustered, optionally interactive point-of-interest overlay.
///
/// A [RouteMapPoiLayer] is a thin declarative wrapper around a MapLibre
/// GeoJSON source plus one or more symbol/circle layers.
///
/// The actual GeoJSON data is loaded lazily via [createSource] so that
/// callers can fetch it from disk, network or any other async source.
class RouteMapPoiLayer {
  /// Unique identifier — used for visibility toggling and removal.
  final String identifier;

  /// Async source loader. May be invoked more than once if the layer needs
  /// to be re-created (e.g. after a style change).
  final Future<GeojsonSourceProperties> Function() createSource;

  /// One or more categories that filter the source's features and render
  /// them with different icons / labels.
  final List<RouteMapPoiCategory> categories;

  /// When non-null, clustering is rendered using these visual properties.
  /// Note: the underlying [GeojsonSourceProperties] returned from
  /// [createSource] must also be configured with `cluster: true` for this
  /// to take effect.
  final RouteMapPoiClusterTheme? clusterTheme;

  /// Initial visibility — defaults to `true`.
  final bool initiallyVisible;

  /// Optional layer-id from the underlying style below which all of this
  /// POI layer's sub-layers are inserted. Useful to keep POIs underneath
  /// other top-level annotations.
  final String? belowLayerId;

  const RouteMapPoiLayer({
    required this.identifier,
    required this.createSource,
    required this.categories,
    this.clusterTheme,
    this.initiallyVisible = true,
    this.belowLayerId,
  });
}

/// One filtered "sub-layer" within a [RouteMapPoiLayer].
///
/// Visually identical to [RouteMapIcon] — every feature is rendered as a
/// pin-shaped marker (the [markerPath] filled with [theme.background])
/// containing the supplied SVG icon.
class RouteMapPoiCategory {
  /// Stable identifier — forwarded back to the caller via
  /// [RouteMapPoiTappedEvent.categoryIdentifier].
  final String identifier;

  /// GeoJSON filter expression applied to the source's features.
  /// Example: `['==', ['get', 'type'], 'service']`.
  final List<Object> filter;

  /// Outline of the pin background, identical to [RouteMapIcon.markerPath].
  /// Pass the same path you use for the regular icons so the POI markers
  /// match visually.
  final Path markerPath;

  /// SVG asset path of the icon drawn inside the pin. All `fill="…"` /
  /// `stroke="…"` attributes are overridden with [theme.foreground].
  final String svgIconPath;

  /// Pin background + foreground theme (light mode).
  final RouteMapIconTheme theme;

  /// Optional dark-mode theme. Defaults to [theme].
  final RouteMapIconTheme? darkTheme;

  /// Whether tapping a feature of this category should trigger
  /// `onPoiTapped`.
  final bool interactive;

  /// Optional label rendered next to the icon (typically below it).
  final RouteMapPoiCategoryLabel? label;

  /// Anchor of the rendered icon image.
  final RouteMapIconAnchor anchor;

  const RouteMapPoiCategory({
    required this.identifier,
    required this.filter,
    required this.markerPath,
    required this.svgIconPath,
    required this.theme,
    this.darkTheme,
    this.interactive = false,
    this.label,
    this.anchor = RouteMapIconAnchor.bottom,
  });
}

/// Optional text label rendered for the features of a [RouteMapPoiCategory].
class RouteMapPoiCategoryLabel {
  /// GeoJSON expression returning the label text.
  /// Example: `['concat', ['literal', 'Service '], ['get', 'master-id']]`.
  final List<Object> textExpression;

  /// Foreground color of the rendered text in light mode.
  final Color color;

  /// Optional dark-mode color (defaults to [color]).
  final Color? darkColor;

  /// Color of the outline drawn around the text (used to keep it legible
  /// on busy map backgrounds).
  final Color haloColor;

  /// Optional dark-mode halo color (defaults to [haloColor]).
  final Color? darkHaloColor;

  /// Width of the halo outline.
  final double haloWidth;

  /// Font size of the label.
  final double textSize;

  /// Anchor of the label relative to the icon.
  final RouteMapIconAnchor anchor;

  const RouteMapPoiCategoryLabel({
    required this.textExpression,
    required this.color,
    required this.haloColor,
    this.darkColor,
    this.darkHaloColor,
    this.haloWidth = 3,
    this.textSize = 14,
    this.anchor = RouteMapIconAnchor.top,
  });
}

/// Theme applied to clustered POI features.
///
/// MapLibre's clustering produces synthetic features with a `point_count`
/// property — when [RouteMapPoiLayer.clusterTheme] is non-null, route_map
/// renders a circle background + the point count on top of every clustered
/// feature.
class RouteMapPoiClusterTheme {
  /// Background color of the cluster circle (light mode).
  final Color circleColor;

  /// Optional dark-mode background color.
  final Color? darkCircleColor;

  /// Color of the outline of the cluster circle (light mode).
  final Color circleStrokeColor;

  /// Optional dark-mode outline color.
  final Color? darkCircleStrokeColor;

  /// Color of the count text rendered on top of the circle (light mode).
  final Color textColor;

  /// Optional dark-mode count text color.
  final Color? darkTextColor;

  /// Radius of the cluster circle.
  final double circleRadius;

  /// Outline width of the cluster circle.
  final double circleStrokeWidth;

  /// Font size of the count text.
  final double textSize;

  const RouteMapPoiClusterTheme({
    required this.circleColor,
    required this.circleStrokeColor,
    required this.textColor,
    this.darkCircleColor,
    this.darkCircleStrokeColor,
    this.darkTextColor,
    this.circleRadius = 12,
    this.circleStrokeWidth = 1,
    this.textSize = 16,
  });
}

/// Payload of the `onPoiTapped` callback.
class RouteMapPoiTappedEvent {
  /// Identifier of the [RouteMapPoiLayer] containing the tapped feature.
  final String layerIdentifier;

  /// Identifier of the [RouteMapPoiCategory] the feature belongs to.
  final String categoryIdentifier;

  /// Raw feature id as reported by MapLibre. For features that have an
  /// explicit `id` set in the source GeoJSON this will be that id (as a
  /// stringified value); otherwise an auto-generated id.
  final String featureId;

  /// Geographic position of the tap.
  final LatLng latLng;

  const RouteMapPoiTappedEvent({
    required this.layerIdentifier,
    required this.categoryIdentifier,
    required this.featureId,
    required this.latLng,
  });
}
