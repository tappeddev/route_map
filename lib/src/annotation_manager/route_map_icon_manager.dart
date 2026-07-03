import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

class RouteMapIconManager {
  final MapLibreMapController controller;
  Brightness _brightness = Brightness.light;

  // ⚠️ the values are the scaling and not the actual size!
  double get iconScale => kIsWeb ? 0.5 : 1.5;

  /// Cache of MapLibre image keys that have already been registered via
  /// [MapLibreMapController.addImage]. The key is derived from the visual
  /// properties of a [RouteMapIcon] (see [RouteMapIcon.imageKey]) so that
  /// multiple icons sharing the same visuals (e.g. all via markers)
  /// reuse the same registered image instead of trying to re-add it
  /// under a colliding identifier.
  final _cachedImages = <String>{};

  /// The key is the symbol id by maplibre
  /// the value is the icon object from the user.
  final _symbolMap = <String, RouteMapIcon>{};

  RouteMapIconManager({required this.controller});

  RouteMapIcon findIconBySymbol(Symbol symbol) => _symbolMap[symbol.id]!;

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final mapIcons = _symbolMap.values.toList();
    _cachedImages.clear();
    await removeIcons();
    for (final icon in mapIcons) {
      if (controller.isDisposed) return;
      await drawIcon(icon);
    }
  }

  // inspiration from: https://stackoverflow.com/a/78289149
  Future<String> addImageToCacheIfNeeded(
    MapLibreMapController controller, {
    required RouteMapIcon mapIcon,
  }) async {
    final imageKey = mapIcon.imageKey;
    if (_cachedImages.contains(imageKey)) return imageKey;

    final uint8List = await _generatePngMarker(mapIcon: mapIcon);

    if (controller.isDisposed) return imageKey;
    // Re-check after the async gap in case another concurrent call
    // added the same image in the meantime.
    if (_cachedImages.contains(imageKey)) return imageKey;

    await controller.addImage(imageKey, uint8List);
    _cachedImages.add(imageKey);
    return imageKey;
  }

  Future<void> removeIconsWhere(bool Function(RouteMapIcon icon) test) async {
    final iconsToRemove = _symbolMap.values.where(test).toList();

    if (iconsToRemove.isEmpty) return;

    for (var icon in iconsToRemove) {
      await removeIcon(identifier: icon.identifier);
    }
  }

  Future<void> removeIcons() async {
    final symbols = controller.symbols.toList();

    if (symbols.isEmpty) return;

    await controller.removeSymbols(symbols);

    for (var symbol in symbols) {
      _symbolMap.remove(symbol.id);
    }
  }

  Future<void> removeIcon({required String identifier}) async {
    final searchedSymbolId = _symbolMap.entries
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

  Future<void> drawIcon(RouteMapIcon mapIcon) async {
    final imageKey = await addImageToCacheIfNeeded(
      controller,
      mapIcon: mapIcon,
    );
    if (controller.isDisposed) return;
    final existingSymbolEntry = _symbolMap.entries.firstWhereOrNull(
      (entry) => entry.value.identifier == mapIcon.identifier,
    );
    final symbolOptions = _buildSymbolOptions(mapIcon, imageKey);

    if (existingSymbolEntry != null) {
      final symbol = controller.symbols.firstWhereOrNull(
        (symbol) => symbol.id == existingSymbolEntry.key,
      );
      if (symbol != null) {
        await controller.updateSymbol(symbol, symbolOptions);
        _symbolMap[symbol.id] = mapIcon;
        return;
      }
      _symbolMap.remove(existingSymbolEntry.key);
    }

    if (controller.isDisposed) return;
    final symbol = await controller.addSymbol(symbolOptions);
    _symbolMap[symbol.id] = mapIcon;
  }

  SymbolOptions _buildSymbolOptions(RouteMapIcon mapIcon, String imageKey) {
    final label = mapIcon.label;
    final hasLabel = label != null;

    return SymbolOptions(
      geometry: mapIcon.latLng,
      iconImage: imageKey,
      iconAnchor: mapIcon.anchor.mglIconValue,
      iconSize: iconScale,
      iconRotate: mapIcon.rotationDegrees,
      textField: hasLabel ? label : null,
      textAnchor: hasLabel ? RouteMapIconAnchor.top.mglIconValue : null,
      textHaloWidth: hasLabel ? 3 : null,
      draggable: mapIcon.draggable,
    );
  }

  Future<Uint8List> _generatePngMarker({required RouteMapIcon mapIcon}) async {
    final theme = switch (_brightness) {
      Brightness.dark => mapIcon.darkTheme ?? mapIcon.theme,
      Brightness.light => mapIcon.theme,
    };

    final markerPath = mapIcon.markerPath;
    final sizeBeforeStroke = markerPath.getBounds().size;
    final sizeWithStroke = Size(
      sizeBeforeStroke.width + theme.strokeWidth,
      sizeBeforeStroke.height + theme.strokeWidth,
    );
    final padding = theme.padding;
    final strokeWidth = theme.strokeWidth;
    final drawCircleAroundIcon = theme.drawCircleAroundIcon;
    final svgIconPath = mapIcon.svgIconPath;
    final text = mapIcon.text;
    final foreground = theme.foreground;

    assert(
      text == null || foreground != null,
      "RouteMapIconTheme.foreground must be non-null when rendering text.",
    );

    final circleRadius = sizeBeforeStroke.width / 2 - padding;
    final circleOffset = padding + circleRadius;

    // Create a canvas to draw on
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw Marker
    // Half of stroke is outer and the other half is inner, tranlsate only half of stroke width
    canvas.translate(strokeWidth / 2, strokeWidth / 2);
    paint.color = theme.background;
    canvas.drawPath(markerPath, paint);
    // Draw Stroke
    if (strokeWidth != 0) {
      canvas.drawPath(
        markerPath,
        Paint()
          ..color = const Color(0xFF7A7A7A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
    // Draw white circle
    if (drawCircleAroundIcon) {
      paint.color = const Color(0xffffffff);
      canvas.drawCircle(
        Offset(circleOffset, circleOffset),
        circleRadius,
        paint,
      );
    }

    if (svgIconPath != null) {
      // Load SVG and (optionally) override its fill / stroke. When
      // [foreground] is null, the original SVG colors are preserved.
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

      // Draw the SVG icon
      final iconWidth = drawCircleAroundIcon
          ? circleRadius * 1.3
          : sizeBeforeStroke.width - padding * 2;
      final iconHeight = drawCircleAroundIcon
          ? circleRadius * 1.3
          : sizeBeforeStroke.height - padding * 2;
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

    // End recording and convert to image
    return _recorderToPng(recorder, sizeWithStroke);
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
}
