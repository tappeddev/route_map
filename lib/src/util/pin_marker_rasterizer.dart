import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/src/model/route_map_icon/route_map_icon.dart';

/// Rasterizes a pin-shaped marker (the same kind that backs [RouteMapIcon])
/// to a PNG byte buffer suitable for `MapLibreMapController.addImage`.
///
/// The rendering matches the style used internally by `RouteMapIconManager`:
///
/// 1. Draws [markerPath] filled with [RouteMapIconTheme.background].
/// 2. Optionally draws a stroke around the marker.
/// 3. Optionally draws a white circle in the marker's "icon slot".
/// 4. Centers and tints [svgIconPath] (if supplied) using
///    [RouteMapIconTheme.foreground]; otherwise centers [text].
///
/// When [RouteMapIconTheme.foreground] is `null`, the original `fill="…"` /
/// `stroke="…"` attributes of the SVG are preserved instead of being
/// overridden. In that case [text] must not be used.
///
/// Exactly one of [svgIconPath] / [text] may be non-null.
Future<Uint8List> rasterizePinMarker({
  required Path markerPath,
  required RouteMapIconTheme theme,
  String? svgIconPath,
  String? text,
}) async {
  assert(
    svgIconPath == null || text == null,
    "Provide either svgIconPath or text, not both.",
  );
  assert(
    text == null || theme.foreground != null,
    "RouteMapIconTheme.foreground must be non-null when rendering text.",
  );

  final foreground = theme.foreground;
  final sizeBeforeStroke = markerPath.getBounds().size;
  final sizeWithStroke = Size(
    sizeBeforeStroke.width + theme.strokeWidth,
    sizeBeforeStroke.height + theme.strokeWidth,
  );
  final padding = theme.padding;
  final strokeWidth = theme.strokeWidth;
  final drawCircleAroundIcon = theme.drawCircleAroundIcon;

  final circleRadius = sizeBeforeStroke.width / 2 - padding;
  final circleOffset = padding + circleRadius;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..style = PaintingStyle.fill;

  canvas.translate(strokeWidth / 2, strokeWidth / 2);
  paint.color = theme.background;
  canvas.drawPath(markerPath, paint);

  if (strokeWidth != 0) {
    canvas.drawPath(
      markerPath,
      Paint()
        ..color = const Color(0xFF7A7A7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  if (drawCircleAroundIcon) {
    paint.color = const Color(0xffffffff);
    canvas.drawCircle(
      Offset(circleOffset, circleOffset),
      circleRadius,
      paint,
    );
  }

  if (svgIconPath != null) {
    final rawSvg = await rootBundle.loadString(svgIconPath);
    final tintedSvg = foreground == null
        ? rawSvg
        // ignore: deprecated_member_use
        : rawSvg
              .replaceAll(
                RegExp(r'fill="[^"]*"'),
                'fill="${foreground.toHexStringRGB()}"',
              )
              .replaceAll(
                RegExp(r'stroke="[^"]*"'),
                'stroke="${foreground.toHexStringRGB()}"',
              );

    final loader = SvgStringLoader(tintedSvg);
    final pictureInfo = await vg.loadPicture(loader, null);

    final iconWidth = drawCircleAroundIcon
        ? circleRadius * 1.3
        : sizeBeforeStroke.width - padding * 2;
    final iconHeight = drawCircleAroundIcon
        ? circleRadius * 1.3
        : sizeBeforeStroke.height - padding * 2;
    final iconScaleX = iconWidth / pictureInfo.size.width;
    final iconScaleY = iconHeight / pictureInfo.size.height;

    final iconScale = iconScaleX < iconScaleY ? iconScaleX : iconScaleY;

    final dx = circleOffset - (pictureInfo.size.width * iconScale / 2);
    final dy = circleOffset - (pictureInfo.size.height * iconScale / 2);

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(iconScale, iconScale);
    canvas.drawPicture(pictureInfo.picture);
    canvas.restore();
    pictureInfo.picture.dispose();
  } else if (text != null) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          // Asserted to be non-null above.
          color: foreground,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout();
    final offset = Offset(
      circleOffset - textPainter.width / 2,
      circleOffset - textPainter.height / 2,
    );
    textPainter.paint(canvas, offset);
  }

  final picture = recorder.endRecording();
  final image = await picture.toImage(
    sizeWithStroke.width.toInt(),
    sizeWithStroke.height.toInt(),
  );
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  picture.dispose();
  image.dispose();

  if (byteData == null) {
    throw StateError('Failed to rasterize pin marker.');
  }

  return byteData.buffer.asUint8List();
}
