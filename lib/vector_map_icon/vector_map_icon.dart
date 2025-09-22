import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:vector_map/vector_map_icon_anchor.dart';

part 'vector_map_icon.freezed.dart';

@freezed
abstract class VectorMapIcon with _$VectorMapIcon {
  const VectorMapIcon._();

  @Assert(
    'svgIcon == null || text == null',
    'Either svgIcon or text must be provided, not both.',
  )
  const factory VectorMapIcon({
    required Size size,
    required LatLng latLng,
    required String identifier,
    required VectorMapIconTheme theme,
    String? svgIcon,
    String? text,
    required Function(Size) drawPath,
    String? label,
    @Default(false) bool draggable,
    @Default(VectorMapIconAnchor.bottom) VectorMapIconAnchor anchor,
  }) = _VectorMapIcon;
}

@freezed
abstract class VectorMapIconTheme with _$VectorMapIconTheme {
  const VectorMapIconTheme._();

  const factory VectorMapIconTheme({
    required Color background,
    required Color foreground,
    @Default(false) bool drawCircleAroundIcon,
    @Default(0) double strokeWidth,
    @Default(10) double padding,
  }) = _VectorMapIconTheme;
}
