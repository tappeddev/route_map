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

Pass the current fix to `RouteMap.location`. RouteMap forwards updates to
MapLibre as the widget rebuilds:

```dart
RouteMap(
  location: ref.watch(provCurrentLocation), // ManualLocationUpdate?
  // ...other map options
)
```

The provider should return `ManualLocationUpdate?`, exported by
`package:route_map/route_map.dart`. If your provider returns an app-specific
model, convert it to this value at the app boundary:

```dart
ManualLocationUpdate(
  target: LatLng(fix.latitude, fix.longitude),
  horizontalAccuracy: fix.accuracy, // metres
  bearing: fix.heading, // direction of travel in degrees
  speed: fix.speed, // metres per second
  timestamp: fix.timestamp,
)
```

A non-null `location` enables the native indicator automatically; `null` hides
it. Visibility and the manual location source are managed internally.
The latest fix is applied after loading and restored after style changes.
Intermediate fixes received while loading or sending an update are coalesced.
Rebuilding with the same fix instance does not resend it; provide a new instance
for each observation, including accuracy-only or timestamp-only changes.

Riverpod is optional: `location` is a regular widget property and works with any
state-management approach. RouteMap does not subscribe to your provider.

MapLibre draws the native location indicator and accuracy visualization. It does
not request location permission or start its own device-location engine in manual
mode; your app owns the provider, its permissions, and its subscription lifecycle.
Updates wait until the map's style is ready.

Use `myLocationTrackingMode` and `myLocationRenderMode` to configure native camera
following and indicator rendering. Both enums are exported by
`package:route_map/route_map.dart`.

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
