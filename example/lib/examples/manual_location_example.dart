import 'package:example/util/style_url.dart';
import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';

/// Map taps stand in for fixes from an app-owned location provider.
class ManualLocationExample extends StatefulWidget {
  const ManualLocationExample({super.key});

  @override
  State<ManualLocationExample> createState() => _ManualLocationExampleState();
}

class _ManualLocationExampleState extends State<ManualLocationExample> {
  final _controller = RouteMapController();
  ManualLocationUpdate? _location;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RouteMap(
          controller: _controller,
          initialCameraPosition: const CameraPosition(
            target: LatLng(48.123287, 11.572062),
            zoom: 15,
          ),
          styleUrl: getStyleUrl(context),
          locale: 'en',
          zoomPadding: EdgeInsets.zero,
          location: _location,
          myLocationRenderMode: MyLocationRenderMode.normal,
          onMapClicked: (_, location) {
            setState(() {
              _location = ManualLocationUpdate(
                target: location,
                horizontalAccuracy: 20,
                timestamp: DateTime.now(),
              );
            });
          },
        ),
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Tap the map to inject a location fix (20 m accuracy).',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
