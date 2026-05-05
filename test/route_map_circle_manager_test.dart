import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_map/route_map.dart';

void main() {
  test('circle theme keeps optional styling fields nullable by default', () {
    const theme = RouteMapCircleTheme(radius: 12, color: Color(0xFF0000FF));

    expect(theme.opacity, isNull);
    expect(theme.blur, isNull);
    expect(theme.strokeWidth, isNull);
    expect(theme.strokeColor, isNull);
    expect(theme.strokeOpacity, isNull);
    expect(theme.draggable, isFalse);
  });

  test('circle keeps dark theme optional by default', () {
    const circle = RouteMapCircle(
      identifier: 'circle-id',
      latLng: LatLng(30, 31),
      theme: RouteMapCircleTheme(radius: 12, color: Color(0xFF0000FF)),
    );

    expect(circle.darkTheme, isNull);
  });
}
