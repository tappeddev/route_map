<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

### App-provided user locations

Enable `enableManualLocationDisplay: true` on `RouteMap`, then forward fixes
from your location provider to its controller:

```dart
await controller.updateManualLocation(
  location: const LatLng(48.123287, 11.572062),
  horizontalAccuracy: 10, // metres
  bearing: 90, // degrees
  speed: 5, // metres per second
  timestamp: DateTime.now(),
);
```

MapLibre draws the native location indicator and accuracy visualization. It does
not request location permission or start its own device-location engine in manual
mode; your app owns the provider, its permissions, and its subscription lifecycle.
Updates wait until the map's style is ready.

Use `myLocationTrackingMode` and `myLocationRenderMode` to configure native camera
following and indicator rendering. Both enums are exported by
`package:route_map/route_map.dart`. To hide the indicator, rebuild the map with
`enableManualLocationDisplay: false`.

The custom `RouteMapUserLocationIndicator` models and
`drawUserLocationIndicator` / `removeUserLocationIndicator` methods have been
removed. Replace custom drawing with the native API above; custom indicator
icons and themes are no longer part of RouteMap's location API. The old
`accuracyWidth` was a screen-space width; pass your provider's accuracy in metres
as `horizontalAccuracy` instead.

See the **Manual location** example to inject fixes by tapping the map.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
