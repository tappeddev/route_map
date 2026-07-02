import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';

/// A small map plus a button that opens a draggable bottom sheet containing a
/// more detailed map. Both maps render the same (fairly complex) no-service
/// area so the layer setup runs on every style load.
///
/// Dragging / resizing the sheet embeds the map in an animated container and
/// the refresh button reloads the style at runtime — both re-fire
/// `onStyleLoadedCallback`, which is what surfaces issue #13
/// (`sourceAlreadyExists` for `no_service_area_source_id_0`).
const _lightStyle =
    "https://basemaps.cartocdn.com/gl/positron-gl-style/style.json";
const _darkStyle =
    "https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json";

/// A more complex service area: a multi-polygon (two separate areas) where the
/// first polygon also has a hole.
const Map<String, Object?> serviceAreaGeoJson = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": <String, Object?>{},
      "geometry": {
        "type": "MultiPolygon",
        "coordinates": [
          [
            // Polygon 1 — irregular outer ring ...
            [
              [11.35, 48.00],
              [11.50, 47.97],
              [11.66, 48.02],
              [11.74, 48.12],
              [11.70, 48.24],
              [11.58, 48.30],
              [11.45, 48.27],
              [11.36, 48.18],
              [11.30, 48.09],
              [11.35, 48.00],
            ],
            // ... with a hole in the middle.
            [
              [11.50, 48.10],
              [11.60, 48.10],
              [11.62, 48.17],
              [11.53, 48.19],
              [11.48, 48.15],
              [11.50, 48.10],
            ],
          ],
          [
            // Polygon 2 — a separate area to the east.
            [
              [11.82, 48.02],
              [11.95, 48.05],
              [11.98, 48.14],
              [11.90, 48.20],
              [11.80, 48.13],
              [11.82, 48.02],
            ],
          ],
        ],
      },
    },
  ],
};

Future<GeojsonSourceProperties> createServiceAreaSource() async {
  return const GeojsonSourceProperties(data: serviceAreaGeoJson);
}

List<NoServiceAreaLayer> noServiceAreaLayers() => [
  NoServiceAreaLayer(
    createSource: createServiceAreaSource,
    fillColor: Colors.grey.withValues(alpha: 0.45),
    hashLines: const NoServiceAreaHashLines(
      color: Colors.black26,
      spacing: 10,
    ),
    border: const NoServiceAreaBorder(
      createSource: createServiceAreaSource,
      color: Colors.redAccent,
      width: 2,
    ),
  ),
];

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
      isScrollControlled: true,
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
                key: const Key("small map - map_bottom_sheet"),
                styleUrl: _lightStyle,
                locale: "en",
                zoomPadding: const EdgeInsets.all(24),
                controller: _smallMapController,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(48.13, 11.62),
                  zoom: 7.5,
                ),
                noServiceAreaLayers: noServiceAreaLayers(),
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
  final String _styleUrl = _lightStyle;

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
                  key: const Key("map_bottom_sheet"),
                  styleUrl: _styleUrl,
                  locale: "en",
                  zoomPadding: const EdgeInsets.all(40),
                  controller: _controller,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(48.13, 11.62),
                    zoom: 8.5,
                  ),
                  noServiceAreaLayers: noServiceAreaLayers(),
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
