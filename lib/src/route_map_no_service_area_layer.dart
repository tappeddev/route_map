part of 'route_map_base.dart';

extension _RouteMapNoServiceAreaLayerState on _RouteMapState {
  Future<void> _addNoServiceAreaLayers() async {
    final noServiceAreaLayers = widget.noServiceAreaLayers;
    if (noServiceAreaLayers.isEmpty) return;
    final controller = await _controller;
    if (!mounted) return;

    for (var index = 0; index < noServiceAreaLayers.length; index++) {
      await _addNoServiceAreaLayer(
        controller: controller,
        noServiceAreaLayer: noServiceAreaLayers[index],
        index: index,
      );
    }
  }

  Future<void> _addNoServiceAreaLayer({
    required MapLibreMapController controller,
    required NoServiceAreaLayer noServiceAreaLayer,
    required int index,
  }) async {
    /// The no service layer needs to be below the manager layers, to show
    /// all lines, icons, images above the grey layer and not below.
    final belowLayerId = noServiceAreaLayer.belowLayerId;

    final topLayers = [
      ...controller.lineManager!.layerIds,
      ...controller.symbolManager!.layerIds,
      ...controller.circleManager!.layerIds,
      ...controller.fillManager!.layerIds,
      ?belowLayerId,
    ];
    final allLayerIds = await controller.getLayerIds();

    final insertBelowLayer = allLayerIds
        .map((layerId) => layerId.toString())
        .firstWhere((layerId) => topLayers.contains(layerId));

    if (!mounted) return;

    final source = await noServiceAreaLayer.createSource();

    if (!mounted) return;

    final sourceId = "no_service_area_source_id_$index";
    await controller.addSource(sourceId, source);
    if (!mounted) return;

    final hashLines = noServiceAreaLayer.hashLines;
    final fillPatternId = hashLines == null
        ? null
        : "no_service_area_hash_lines_$index";
    if (hashLines != null && fillPatternId != null) {
      final patternBytes = await _createHashLinesPattern(
        backgroundColor: noServiceAreaLayer.fillColor,
        hashLines: hashLines,
      );
      if (!mounted) return;
      await controller.addImage(fillPatternId, patternBytes);
      if (!mounted) return;
    }

    await controller.addLayer(
      sourceId,
      "no_service_area_layer_id_$index",
      FillLayerProperties(
        fillColor: hashLines == null
            ? noServiceAreaLayer.fillColor.toHexStringRGB()
            : null,
        fillOpacity: hashLines == null ? noServiceAreaLayer.fillColor.a : 1,
        fillPattern: fillPatternId,
      ),
      belowLayerId: insertBelowLayer,
      enableInteraction: noServiceAreaLayer.enableInteraction,
    );

    final border = noServiceAreaLayer.border;
    if (border == null) return;

    if (!mounted) return;

    final borderSource = await border.createSource();
    if (!mounted) return;

    final borderSourceId = "no_service_area_border_source_id_$index";
    await controller.addSource(borderSourceId, borderSource);
    if (!mounted) return;

    await controller.addLayer(
      borderSourceId,
      "no_service_area_border_layer_id_$index",
      LineLayerProperties(
        lineColor: border.color.toHexStringRGB(),
        lineOpacity: border.color.a,
        lineWidth: border.width,
      ),
      belowLayerId: insertBelowLayer,
      enableInteraction: noServiceAreaLayer.enableInteraction,
    );
  }
}

Future<Uint8List> _createHashLinesPattern({
  required Color backgroundColor,
  required NoServiceAreaHashLines hashLines,
}) async {
  final tileSize = max(32, (hashLines.spacing * 4).ceil());
  final tileDimension = tileSize.toDouble();
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, tileDimension, tileDimension),
    ui.Paint()..color = backgroundColor,
  );

  final linePaint = ui.Paint()
    ..color = hashLines.color
    ..strokeWidth = hashLines.width
    ..style = ui.PaintingStyle.stroke;

  for (
    var offset = -tileDimension;
    offset <= tileDimension * 2;
    offset += hashLines.spacing
  ) {
    canvas.drawLine(
      ui.Offset(offset, tileDimension),
      ui.Offset(offset + tileDimension, 0),
      linePaint,
    );
  }

  final image = await recorder.endRecording().toImage(tileSize, tileSize);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) {
    throw StateError("Failed to create no service area hash lines pattern");
  }

  return byteData.buffer.asUint8List();
}
