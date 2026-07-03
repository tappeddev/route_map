import 'package:example/util/example_service_area.dart';
import 'package:example/util/style_url.dart';
import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';

class MapBottomSheetPage extends StatefulWidget {
  const MapBottomSheetPage({super.key});

  @override
  State<MapBottomSheetPage> createState() => _MapBottomSheetPageState();
}

class _MapBottomSheetPageState extends State<MapBottomSheetPage> {
  final _smallMapController = RouteMapController();

  Future<void> _openSheet() {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (_) => const _DetailedMapSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 240,
              child: RouteMap(
                styleUrl: getStyleUrl(context),
                locale: "en",
                zoomPadding: const EdgeInsets.all(24),
                controller: _smallMapController,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(48.13, 11.62),
                  zoom: 7.5,
                ),
                serviceAreaLayers: serviceAreaLayers(),
                onMapClicked: (_, _) {},
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _openSheet,
            icon: const Icon(Icons.open_in_full),
            label: const Text("Open map"),
          ),
        ],
      ),
    );
  }
}

/// Detailed map shown inside the modal sheet. The sheet is resizable by
/// dragging the handle, and the refresh button toggles the style at runtime.
class _DetailedMapSheet extends StatefulWidget {
  const _DetailedMapSheet();

  @override
  State<_DetailedMapSheet> createState() => _DetailedMapSheetState();
}

class _DetailedMapSheetState extends State<_DetailedMapSheet> {
  final _controller = RouteMapController();
  double _heightFactor = 0.6;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: _heightFactor,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _heightFactor =
                        (_heightFactor - details.primaryDelta! / maxHeight)
                            .clamp(0.3, 1.0);
                  });
                },
                child: SizedBox(
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RouteMap(
                  styleUrl: getStyleUrl(context),
                  locale: "en",
                  zoomPadding: const EdgeInsets.all(40),
                  controller: _controller,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(48.13, 11.62),
                    zoom: 8.5,
                  ),
                  serviceAreaLayers: serviceAreaLayers(),
                  onMapClicked: (_, _) {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
