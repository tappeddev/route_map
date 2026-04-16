import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_map/src/manager/route_map_line_manager.dart';
import 'package:route_map/src/model/route_map_route/route_map_route.dart';

void main() {
  test('existing route with same backline shape updates in place', () {
    const previousTheme = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );
    const nextTheme = RouteMapRouteTheme(
      lineWidth: 7,
      color: Color(0xFF00FF00),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );

    final strategy = resolveRouteMutationStrategy(
      hasExistingRoute: true,
      previousTheme: previousTheme,
      nextTheme: nextTheme,
    );

    expect(strategy, RouteMapRouteMutationStrategy.update);
  });

  test('backline presence changes require a rebuild', () {
    const previousTheme = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
    );
    const nextTheme = RouteMapRouteTheme(
      lineWidth: 6,
      color: Color(0xFF0000FF),
      backLineWidth: 8,
      backLineColor: Color(0xFFFFFFFF),
    );

    final strategy = resolveRouteMutationStrategy(
      hasExistingRoute: true,
      previousTheme: previousTheme,
      nextTheme: nextTheme,
    );

    expect(strategy, RouteMapRouteMutationStrategy.rebuild);
  });

  test('route theme keeps new smoothing fields optional by default', () {
    const theme = RouteMapRouteTheme(lineWidth: 6, color: Color(0xFF0000FF));

    expect(theme.lineJoin, isNull);
    expect(theme.lineBlur, isNull);
  });
}
