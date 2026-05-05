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

    await controller.addLayer(
      sourceId,
      "no_service_area_layer_id_$index",
      FillLayerProperties(
        fillColor: noServiceAreaLayer.fillColor.toHexStringRGB(),
        fillOpacity: noServiceAreaLayer.fillColor.a,
      ),
      belowLayerId: insertBelowLayer,
      enableInteraction: false,
    );

    if (hashLines != null) {
      final patternBytes = await _createHashLinesPattern(hashLines: hashLines);
      if (!mounted) return;
      final patternId = "no_service_area_hash_lines_$index";
      await controller.addImage(patternId, patternBytes);
      if (!mounted) return;

      if (!mounted) return;

      await controller.addLayer(
        sourceId,
        "no_service_area_hash_lines_layer_id_$index",
        FillLayerProperties(fillOpacity: 1, fillPattern: patternId),
        belowLayerId: insertBelowLayer,
        enableInteraction: false,
      );
    }

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
      enableInteraction: false,
    );
  }
}

Future<Uint8List> _createHashLinesPattern({
  required NoServiceAreaHashLines hashLines,
}) async {
  final tileSize = max(32, (hashLines.spacing * 4).ceil());
  final tileDimension = tileSize.toDouble();
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

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
