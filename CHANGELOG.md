## 0.1.0

- Add declarative `RouteMap(location: ManualLocationUpdate(...))` updates,
  including automatic visibility, latest-fix coalescing and style restoration.
  Re-export `ManualLocationUpdate` for provider-driven consumers.
- Upgrade `maplibre_gl` to `^0.27.1` and require Flutter 3.29.0 or newer.
- Expose native manual location display and tracking through the released
  MapLibre API, alongside camera tilt, move callbacks and viewport padding.
- Breaking: remove the custom `RouteMapUserLocationIndicator` models and the
  controller's `drawUserLocationIndicator` / `removeUserLocationIndicator` APIs.
  Supply `RouteMap.location` for MapLibre's native location indicator; visibility
  and the manual location source are managed internally. Tracking and render
  mode enums are now re-exported.
- Breaking: the screen-space `accuracyWidth` is replaced by
  `ManualLocationUpdate.horizontalAccuracy`, in metres. Pass your provider's
  accuracy directly.

## 0.0.2

- Add support for drawing areas and circles

## 0.0.1

- Initial release of the `route_map` package
