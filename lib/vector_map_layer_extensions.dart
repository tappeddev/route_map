import 'package:vector_map/vector_map.dart';

class ServiceAreaLayer {
  final SourceProperties source;
  final SourceProperties fillColor;

  const ServiceAreaLayer({required this.source, required this.fillColor});
}

extension VectorMapStateLayerExtensions on VectorMapState {
  Future<void> addServiceAreaLayer({
    required ServiceAreaLayer serviceAreaLayer,
  }) async {
    /// The grey layer need to be below the manager, since we want to show
    /// all lines, icons, images above the grey layer and not below.
    Future<String> findFirstManagerLayoutId(
      MapLibreMapController controller,
    ) async {
      final managerLayerIds = [
        ...controller.lineManager!.layerIds,
        ...controller.symbolManager!.layerIds,
        ...controller.circleManager!.layerIds,
        ...controller.fillManager!.layerIds,
        // We also want to show the city-names, countries and so on on top of the gray layer,
        // to improve the orientation of the user
        "place-village",
      ];

      final allLayerIds = await controller.getLayerIds();

      return allLayerIds
          .map((layerId) => layerId.toString())
          .firstWhere((layerId) => managerLayerIds.contains(layerId));
    }

    final managerLayoutId = await findFirstManagerLayoutId(controller!);

    if (!mounted) return;

    if (!mounted) return;

    const sourceId = "service_area_source_id";

    await controller!.addSource(sourceId, serviceAreaLayer.source);

    await controller!.addLayer(
      sourceId,
      "service_area_layer_id",
      FillLayerProperties(
        fillColor: serviceAreaLayer.fillColor,
        fillOpacity: 0.8,
      ),
      belowLayerId: managerLayoutId,
      enableInteraction: false,
    );
  }
}
