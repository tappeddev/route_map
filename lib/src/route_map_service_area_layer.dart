part of 'route_map_base.dart';

extension _RouteMapServiceAreaLayerState on _RouteMapState {
  Future<void> _addServiceAreaLayers() async {
    final serviceAreaLayers = widget.serviceAreaLayers;
    if (serviceAreaLayers.isEmpty) return;
    final controller = await _controller;
    if (!mounted) return;

    for (var index = 0; index < serviceAreaLayers.length; index++) {
      await _addServiceAreaLayer(
        controller: controller,
        serviceAreaLayer: serviceAreaLayers[index],
        index: index,
      );
      if (!mounted) return;
    }
  }

  Future<void> _addServiceAreaLayer({
    required MapLibreMapController controller,
    required ServiceAreaLayer serviceAreaLayer,
    required int index,
  }) async {
    final source = await serviceAreaLayer.createSource();
    if (!mounted) return;

    final sourceId = "service_area_source_id_$index";
    await _layerManagerInstance.addSource(sourceId, source);
    if (!mounted) return;

    await _layerManagerInstance.addLayer(
      sourceId,
      "service_area_layer_id_$index",
      FillLayerProperties(
        fillColor: serviceAreaLayer.fillColor.toHexStringRGB(),
        fillOpacity: serviceAreaLayer.fillColor.a,
      ),
      belowLayerId: serviceAreaLayer.belowLayerId,
      enableInteraction: false,
    );
    if (!mounted) return;

    final hashLines = serviceAreaLayer.hashLines;
    if (hashLines != null) {
      final patternBytes = await _createHashLinesPattern(hashLines: hashLines);
      if (!mounted) return;
      final patternId = "service_area_hash_lines_$index";
      await _layerManagerInstance.addImage(patternId, patternBytes);
      if (!mounted) return;

      await _layerManagerInstance.addLayer(
        sourceId,
        "service_area_hash_lines_layer_id_$index",
        FillLayerProperties(fillOpacity: 1, fillPattern: patternId),
        belowLayerId: serviceAreaLayer.belowLayerId,
        enableInteraction: false,
      );
      if (!mounted) return;
    }

    final border = serviceAreaLayer.border;
    if (border == null) return;

    final borderSource = await border.createSource();
    if (!mounted) return;

    final borderSourceId = "service_area_border_source_id_$index";
    await _layerManagerInstance.addSource(borderSourceId, borderSource);
    if (!mounted) return;

    await _layerManagerInstance.addLayer(
      borderSourceId,
      "service_area_border_layer_id_$index",
      LineLayerProperties(
        lineColor: border.color.toHexStringRGB(),
        lineOpacity: border.color.a,
        lineWidth: border.width,
      ),
      belowLayerId: serviceAreaLayer.belowLayerId,
      enableInteraction: false,
    );
  }
}

Future<Uint8List> _createHashLinesPattern({
  required ServiceAreaHashLines hashLines,
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
    throw StateError("Failed to create service area hash lines pattern");
  }

  return byteData.buffer.asUint8List();
}
