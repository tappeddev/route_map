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
