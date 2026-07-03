import 'package:flutter/material.dart';

String getStyleUrl(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return isDarkMode
      ? "https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json"
      : "https://basemaps.cartocdn.com/gl/positron-gl-style/style.json";
}
