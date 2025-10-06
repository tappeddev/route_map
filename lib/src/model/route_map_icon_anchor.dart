/// Mapper for the native: [MGLIconAnchor]
enum RouteMapIconAnchor {
  center("center"),
  left("left"),
  right("right"),
  top("top"),
  bottom("bottom"),
  topLeft("top-left"),
  topRight("top-right"),
  bottomLeft("bottom-left"),
  bottomRight("bottom-right");

  final String mglIconValue;

  const RouteMapIconAnchor(this.mglIconValue);
}
