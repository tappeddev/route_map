import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_map/route_map.dart';

part 'route_map_icon.freezed.dart';

@freezed
abstract class RouteMapIcon with _$RouteMapIcon {
  @Assert(
    'svgIconPath == null || text == null',
    'Either svgIcon or text must be provided, not both.',
  )
  const factory RouteMapIcon({
    required Path markerPath,
    required LatLng latLng,
    required String identifier,
    required RouteMapIconTheme theme,
    RouteMapIconTheme? darkTheme,
    String? svgIconPath,
    String? text,
    String? label,
    double? rotationDegrees,
    @Default(false) bool draggable,
    @Default(RouteMapIconAnchor.bottom) RouteMapIconAnchor anchor,
  }) = _RouteMapIcon;

  const RouteMapIcon._();

  /// Stable key identifying the *rendered PNG* of this icon. Only fields
  /// that actually influence the pixel output are taken into account so
  /// that multiple icons sharing the same visuals (e.g. all via markers)
  /// can be registered under the same MapLibre image and reused for
  /// symbols at different [latLng]s.
  ///
  /// Excluded on purpose: [latLng], [identifier], [label] (drawn as a
  /// separate text field), [rotationDegrees], [anchor] and [draggable].
  ///
  /// [Path] has no content-based hash, so [identityHashCode] is used.
  /// In practice callers reuse the same [Path] instance for the same
  /// visual marker; if they don't, the worst case is a cache miss (an
  /// additional PNG generation) — never a collision.
  ///
  /// Null fields are kept as explicit `0` / `''` placeholders (instead
  /// of being filtered out) so that every field stays at a fixed
  /// position in the joined string. Filtering nulls would let values
  /// from different fields slide into the same slot and produce
  /// colliding keys — e.g. `svgIconPath: 'foo'` (text null) and
  /// `text: 'foo'` (svgIconPath null) would otherwise both collapse to
  /// `"...|foo"` even though they render completely different PNGs.
  String get imageKey => [
    identityHashCode(markerPath),
    theme.hashCode,
    darkTheme?.hashCode ?? 0,
    svgIconPath ?? '',
    text ?? '',
  ].join('|');
}

@freezed
abstract class RouteMapIconTheme with _$RouteMapIconTheme {
  const factory RouteMapIconTheme({
    required Color background,

    /// Foreground color used to tint the SVG icon (or render the text).
    ///
    /// When `null`, the original `fill="…"` / `stroke="…"` attributes of
    /// the SVG are preserved instead of being overridden. Useful for
    /// multi-color brand icons where the source colors should win.
    ///
    /// Must be non-null when `RouteMapIcon.text` is used.
    required Color? foreground,
    @Default(false) bool drawCircleAroundIcon,
    @Default(0) double strokeWidth,
    @Default(10) double padding,
  }) = _RouteMapIconTheme;
}
