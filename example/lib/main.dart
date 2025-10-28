import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Map Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _mapController = RouteMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //TODO tarek. this is not working
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _mapController.drawRoute(
        route: const RouteMapRoute(
          identifier: "route",
          points: [LatLng(48.562479, 7.747656), LatLng(48.117342, 7.264303)],
          theme: RouteMapRouteTheme(
            lineWidth: 4,
            color: Colors.red,
            backLineColor: Colors.grey,
            backLineWidth: 6,
          ),
        ),
        animateCamera: true,
      );
    });*/

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RouteMap(
        minMaxZoomPreference: const MinMaxZoomPreference(5, 18),
        styleUrl: null,
        locale: "en",
        zoomPadding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 60),
        allowIconsOverlap: true,
        ignoreIconsPlacement: true,
        controller: _mapController,
        initialCameraPosition: const CameraPosition(
          target: LatLng(48.123287, 11.572062),
          zoom: 15,
        ),
        onMapClicked: (_, location) async {},
      ),
    );
  }
}
