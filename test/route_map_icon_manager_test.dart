import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_map/src/annotation_manager/route_map_icon_manager.dart';

void main() {
  group('tintSvg', () {
    test('keeps fill="none" of an outlined icon', () {
      const svg =
          '<svg fill="none"><path d="M0 0" stroke="#021320" stroke-width="1.5"/></svg>';

      final tinted = tintSvg(svg, color: const Color(0xFFFFFFFF));

      expect(
        tinted,
        '<svg fill="none"><path d="M0 0" stroke="#ffffff" stroke-width="1.5"/></svg>',
      );
    });

    test('replaces the fill of a filled icon', () {
      const svg = '<svg fill="none"><path d="M0 0" fill="#021320"/></svg>';

      final tinted = tintSvg(svg, color: const Color(0xFFFF0000));

      expect(tinted, '<svg fill="none"><path d="M0 0" fill="#ff0000"/></svg>');
    });

    test('keeps stroke="none"', () {
      const svg = '<path stroke="none" fill="#021320"/>';

      final tinted = tintSvg(svg, color: const Color(0xFF00FF00));

      expect(tinted, '<path stroke="none" fill="#00ff00"/>');
    });
  });
}
