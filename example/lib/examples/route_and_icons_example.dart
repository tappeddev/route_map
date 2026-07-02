import 'package:example/examples/map_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';

/// Original demo: draws a route with a start and end pin.
class RouteAndIconsExample extends StatefulWidget {
  const RouteAndIconsExample({super.key});

  @override
  State<RouteAndIconsExample> createState() => _RouteAndIconsExampleState();
}

class _RouteAndIconsExampleState extends State<RouteAndIconsExample> {
  final _mapController = RouteMapController();

  Path _getPinPath() {
    return Path()..addOval(const Rect.fromLTWH(0, 0, 36, 36));
  }

  Future<void> drawRoute() async {
    if (!mounted) return;

    await _mapController.removeRoutes();
    await _mapController.removeIcons();

    const start = LatLng(47.7826, 9.6106);
    const destination = LatLng(48.1371, 11.5754);

    await _mapController.drawIcon(
      RouteMapIcon(
        identifier: "start_pin",
        latLng: start,
        markerPath: _getPinPath(),
        text: "A",
        theme: const RouteMapIconTheme(
          background: Colors.green,
          foreground: Colors.white,
          strokeWidth: 2,
          padding: 4,
          drawCircleAroundIcon: true,
        ),
      ),
    );

    if (!mounted) return;

    await _mapController.drawIcon(
      RouteMapIcon(
        identifier: "end_pin",
        latLng: destination,
        markerPath: _getPinPath(),
        text: "B",
        theme: const RouteMapIconTheme(
          background: Colors.red,
          foreground: Colors.white,
          strokeWidth: 2,
          padding: 4,
          drawCircleAroundIcon: true,
        ),
      ),
    );

    if (!mounted) return;
    await _mapController.drawRoute(
      route: const RouteMapRoute(
        identifier: "route-identifier",
        points: [start, destination],
        theme: RouteMapRouteTheme(
          lineWidth: 5,
          color: Color.fromARGB(255, 85, 97, 117),
          backLineColor: Colors.black45,
          backLineWidth: 7,
        ),
      ),
      animateCamera: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final styleUrl = isDarkMode
        ? "https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json"
        : "https://basemaps.cartocdn.com/gl/positron-gl-style/style.json";

    return Stack(
      children: [
        RouteMap(
          key: const Key("route and icons example - route_map"),
          minMaxZoomPreference: const MinMaxZoomPreference(5, 18),
          styleUrl: styleUrl,
          locale: "en",
          zoomPadding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 60,
            bottom: 100,
          ),
          allowIconsOverlap: true,
          ignoreIconsPlacement: true,
          controller: _mapController,
          noServiceAreaLayers: noServiceAreaLayers(),
          initialCameraPosition: const CameraPosition(
            target: LatLng(48.123287, 11.572062),
            zoom: 15,
          ),
          onMapClicked: (_, _) {},
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: drawRoute,
            child: const Icon(Icons.route),
          ),
        ),
      ],
    );
  }
}
