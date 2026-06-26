import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Rasterizes an SVG asset to a PNG byte buffer suitable for
/// `MapLibreMapController.addImage`.
///
/// All `fill="…"` and `stroke="…"` attributes in the source SVG are
/// overridden with [color]. The result has square dimensions of [size]
/// logical pixels (multiplied by [devicePixelRatio] internally).
Future<Uint8List> rasterizeSvgAsset({
  required String assetPath,
  required Color color,
  required double size,
  double devicePixelRatio = 2,
}) async {
  final colorHex =
      '#'
      // ignore: deprecated_member_use
      '${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  final rawSvg = (await rootBundle.loadString(assetPath))
      .replaceAll(RegExp(r'fill="[^"]*"'), 'fill="$colorHex"')
      .replaceAll(RegExp(r'stroke="[^"]*"'), 'stroke="$colorHex"');

  final loader = SvgStringLoader(rawSvg);
  final pictureInfo = await vg.loadPicture(loader, null);

  final imageSize = (size * devicePixelRatio).toInt();
  final scaleX = imageSize / pictureInfo.size.width;
  final scaleY = imageSize / pictureInfo.size.height;
  final scale = scaleX < scaleY ? scaleX : scaleY;

  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.scale(scale, scale);
  canvas.drawPicture(pictureInfo.picture);
  pictureInfo.picture.dispose();

  final picture = recorder.endRecording();
  final image = await picture.toImage(imageSize, imageSize);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  picture.dispose();
  image.dispose();

  if (byteData == null) {
    throw StateError('Failed to rasterize SVG asset "$assetPath" to PNG.');
  }

  return byteData.buffer.asUint8List();
}
