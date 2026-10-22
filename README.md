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
it. Set `enableManualLocationDisplay: false` to hide it while retaining the fix.
The latest fix is applied after loading and restored after style changes.
Intermediate fixes received while loading or sending an update are coalesced.
Rebuilding with the same fix instance does not resend it; provide a new instance
for each observation, including accuracy-only or timestamp-only changes.

Riverpod is optional: `location` is a regular widget property and works with any
state-management approach. RouteMap does not subscribe to your provider.

For imperative updates, set `enableManualLocationDisplay: true` and forward fixes
to the controller instead of setting `location`:

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

### Map screenshots

After the map and its geometry have loaded, capture the current viewport:

```dart
final png = await controller.takeSnapshot(
  timeout: const Duration(seconds: 10),
);
```

The native implementation captures the existing renderer so that inline JSON
styles, runtime route layers and custom marker images appear in the PNG. The
timeout bounds the native snapshot call; call this after map creation/loading.
Native errors propagate to the caller.

This requires snapshot fixes that are not in the published `maplibre_gl 0.27.1`.
This branch pins `tappeddev/flutter-maplibre-gl` to
`b4b9a8c8117c3804323539cd7759ffdaff28779f` (the three snapshot-specific commits
on top of upstream `v0.27.1`). The platform interface and web implementation
remain on their published `0.27.1` releases. A consuming app's dependency override
must not replace this pin with the unpatched package. Web behavior is unchanged.

The fix and native regression fixture are described in
[flutter-maplibre-gl PR #1](https://github.com/tappeddev/flutter-maplibre-gl/pull/1).
That PR was closed without merging; this pin deliberately selects its existing
fix commit. Return to a published dependency when the native fixes are released.
The temporary Git dependency prevents publishing this branch to pub.dev until
it is replaced with a hosted release.

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
