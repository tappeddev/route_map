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
    required Size size,
    required LatLng latLng,
    required String identifier,
    required RouteMapIconTheme theme,
    RouteMapIconTheme? darkTheme,
    String? svgIconPath,
    String? text,
    required Path Function(Size) drawPath,
    String? label,
    @Default(false) bool draggable,
    @Default(RouteMapIconAnchor.bottom) RouteMapIconAnchor anchor,
  }) = _RouteMapIcon;
}

@freezed
abstract class RouteMapIconTheme with _$RouteMapIconTheme {
  const factory RouteMapIconTheme({
    required Color background,
    required Color foreground,
    @Default(false) bool drawCircleAroundIcon,
    @Default(0) double strokeWidth,
    @Default(10) double padding,
  }) = _RouteMapIconTheme;
}
