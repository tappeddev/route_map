/// Mapper for the native: [MGLIconAnchor]
enum VectorMapIconAnchor {
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

  const VectorMapIconAnchor(this.mglIconValue);
}
