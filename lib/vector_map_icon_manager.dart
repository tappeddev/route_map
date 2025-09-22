import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:vector_map/vector_map_icon/vector_map_icon.dart';
import 'package:vector_map/vector_map_icon_anchor.dart';

class VectorMapIconManager {
  final MapLibreMapController controller;

  // ⚠️ the values are the scaling and not the actual size!
  double get iconScale => kIsWeb ? 0.5 : 1.5;

  /// There is no need to create the same image multiple times, that why we cache the identifier.
  final _cachedImages = <String>[];

  /// The key is the created identifier by the [SymbolOptions]
  /// the value is the object from the user.
  final _symbolMap = <String, VectorMapIcon>{};

  VectorMapIconManager({required this.controller});

  Future<List<VectorMapIcon>> beforeRestore() async {
    final mapIcons = _symbolMap.values.toList();

    _cachedImages.clear();
    await removeIcons();
    return mapIcons;
  }

  Future<void> restore(List<VectorMapIcon> mapIcons) async {
    for (final icon in mapIcons) {
      await drawIcon(icon);
    }
  }

  // inspiration from: https://stackoverflow.com/a/78289149
  Future<void> addImageToCacheIfNeeded(
    MapLibreMapController controller, {
    required VectorMapIcon mapIcon,
  }) async {
    if (_cachedImages.contains(mapIcon.identifier)) return;

    final uint8List = await _generatePngMarker(
      svgIcon: mapIcon.svgIcon,
      text: mapIcon.text,
      size: mapIcon.size,
      theme: mapIcon.theme,
      drawPath: mapIcon.drawPath,
      drawCircleAroundIcon: mapIcon.theme.drawCircleAroundIcon,
      padding: mapIcon.theme.padding,
      strokeWidth: mapIcon.theme.strokeWidth,
    );

    await controller.addImage(mapIcon.identifier, uint8List);

    _cachedImages.add(mapIcon.identifier);
  }

  Future<void> removeIcons() async {
    final symbols = controller.symbols.toList();

    if (symbols.isEmpty) return;

    await controller.removeSymbols(symbols);

    for (var symbol in symbols) {
      _symbolMap.remove(symbol.id);
    }
  }

  Future<void> removeViaIcons() async {
    final symbols = controller.symbols.toList();
    final viaSymbols =
        symbols
            .where((s) => s.options.iconImage?.startsWith("via") ?? false)
            .toList();

    if (viaSymbols.isEmpty) return;
    for (var symbol in viaSymbols) {
      await controller.removeSymbol(symbol);
      _symbolMap.remove(symbol.id);
    }
  }

  Future<void> removeIcon({required String identifier}) async {
    final searchedSymbolId =
        _symbolMap.entries
            .firstWhereOrNull((entry) => entry.value.identifier == identifier)
            ?.key;

    if (searchedSymbolId == null) {
      return;
    }

    final symbol = controller.symbols.firstWhereOrNull(
      (symbol) => symbol.id == searchedSymbolId,
    );

    if (symbol == null) {
      return;
    }

    await controller.removeSymbol(symbol);
    _symbolMap.remove(symbol.id);
  }

  Future<String> drawIcon(VectorMapIcon mapIcon) async {
    await addImageToCacheIfNeeded(controller, mapIcon: mapIcon);

    await removeIcon(identifier: mapIcon.identifier);

    final label = mapIcon.label;
    final hasLabel = label != null;

    final symbol = await controller.addSymbol(
      SymbolOptions(
        geometry: mapIcon.latLng,
        iconImage: mapIcon.identifier,
        iconAnchor: mapIcon.anchor.mglIconValue,
        iconSize: iconScale,
        textField: hasLabel ? label : null,
        textAnchor: hasLabel ? VectorMapIconAnchor.top.mglIconValue : null,
        // textColor: hasLabel ? appTheme.objectsDefault.toHexStringRGB() : null,
        // textHaloColor: hasLabel ? appTheme.surfaceCard.toHexStringRGB() : null,
        textHaloWidth: hasLabel ? 3 : null,
        draggable: mapIcon.draggable,
      ),
    );

    _symbolMap[symbol.id] = mapIcon;
    return symbol.id;
  }

  Future<void> allowOverlap() async {
    await controller.setSymbolIconAllowOverlap(true);
    await controller.setSymbolIconIgnorePlacement(true);
    // text should not overlay, since this decrease the readability and it just looks weird...
    await controller.setSymbolTextAllowOverlap(false);
    await controller.setSymbolTextIgnorePlacement(false);
  }
}

Future<Uint8List> _generatePngMarker({
  required String? svgIcon,
  required String? text,
  required Size size,
  required VectorMapIconTheme theme,
  required Function(Size) drawPath,
  required bool drawCircleAroundIcon,
  required double strokeWidth,
  required double padding,
}) async {
  final colorHex = theme.foreground.toHexStringRGB();
  final circleRadius = size.width / 2 - padding;
  final circleOffset = padding + circleRadius;

  // Create a canvas to draw on
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..style = PaintingStyle.fill;

  // Draw Marker
  paint.color = theme.background;
  canvas.drawPath(drawPath(size), paint);
  // Draw Stroke
  if (strokeWidth != 0) {
    final strokeSize = Size(
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    canvas.drawPath(
      drawPath(strokeSize),
      Paint()
        ..color = const Color(0xFF7A7A7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }
  // Draw white circle
  if (drawCircleAroundIcon) {
    paint.color = Color(0xffffffff);
    canvas.drawCircle(Offset(circleOffset, circleOffset), circleRadius, paint);
  }

  if (svgIcon != null) {
    // Load SVG and override color
    final rawSvg = (await rootBundle.loadString(svgIcon))
        .replaceAll(RegExp(r'fill="[^"]*"'), 'fill="$colorHex"')
        .replaceAll(RegExp(r'stroke="[^"]*"'), 'stroke="$colorHex"');

    final loader = SvgStringLoader(rawSvg);
    final pictureInfo = await vg.loadPicture(loader, null);

    // Draw the SVG icon
    final iconWidth =
        drawCircleAroundIcon ? circleRadius * 1.2 : size.width - padding * 2;
    final iconHeight =
        drawCircleAroundIcon ? circleRadius * 1.2 : size.height - padding * 2;
    // Compute scaling factors
    final iconScaleX = iconWidth / pictureInfo.size.width;
    final iconScaleY = iconHeight / pictureInfo.size.height;

    // Use the smaller scale to contain
    final iconScale = iconScaleX < iconScaleY ? iconScaleX : iconScaleY;

    // Center the scaled picture
    final dx = circleOffset - (pictureInfo.size.width * iconScale / 2);
    final dy = circleOffset - (pictureInfo.size.height * iconScale / 2);

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(iconScale, iconScale);
    canvas.drawPicture(pictureInfo.picture);
    canvas.restore();
    pictureInfo.picture.dispose();
  }

  if (text != null) {
    // Draw the number in the center of th circle
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.foreground,
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

  // End recording and convert to image
  return _recorderToPng(recorder, size);
}

Future<Uint8List> _recorderToPng(
  PictureRecorder recorder,
  Size imageSize,
) async {
  // End recording and convert to image
  final picture = recorder.endRecording();
  final img = await picture.toImage(
    imageSize.width.toInt(),
    imageSize.height.toInt(),
  );
  // Convert image to PNG byte data
  final byteData = await img.toByteData(format: ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  picture.dispose();
  img.dispose();
  return pngBytes;
}
