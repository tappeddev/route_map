import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:route_map/route_map.dart';

class RouteMapIconManager {
  final MapLibreMapController controller;
  Brightness _brightness = Brightness.light;

  // ⚠️ the values are the scaling and not the actual size!
  double get iconScale => kIsWeb ? 0.5 : 1.5;

  /// There is no need to create the same icon image multiple times,
  /// that why we cache the hashcode of [RouteMapIcon].
  final _cachedImages = <int>[];

  /// The key is the symbol id by maplibre
  /// the value is the icon object from the user.
  final _symbolMap = <String, RouteMapIcon>{};

  RouteMapIconManager({required this.controller});

  RouteMapIcon findIconBySymbol(Symbol symbol) => _symbolMap[symbol.id]!;

  Future<void> restore(Brightness brightness) async {
    _brightness = brightness;
    final mapIcons = _symbolMap.values.toList();
    _cachedImages.clear();
    await removeIcons();
    for (final icon in mapIcons) {
      if (controller.isDisposed) return;
      await drawIcon(icon);
    }
  }

  // inspiration from: https://stackoverflow.com/a/78289149
  Future<void> addImageToCacheIfNeeded(
    MapLibreMapController controller, {
    required RouteMapIcon mapIcon,
  }) async {
    if (_cachedImages.contains(mapIcon.hashCode)) return;

    final uint8List = await _generatePngMarker(mapIcon: mapIcon);
    if (controller.isDisposed) return;
    await controller.addImage(mapIcon.identifier, uint8List);
    _cachedImages.add(mapIcon.hashCode);
  }

  Future<void> removeIconsWhere(bool Function(RouteMapIcon icon) test) async {
    final iconsToRemove = _symbolMap.values.where(test).toList();

    if (iconsToRemove.isEmpty) return;

    for (var icon in iconsToRemove) {
      await removeIcon(identifier: icon.identifier);
    }
  }

  Future<void> removeIcons() async {
    final symbols = controller.symbols.toList();

    if (symbols.isEmpty) return;

    await controller.removeSymbols(symbols);

    for (var symbol in symbols) {
      _symbolMap.remove(symbol.id);
    }
  }

  Future<void> removeIcon({required String identifier}) async {
    final searchedSymbolId = _symbolMap.entries
        .firstWhereOrNull((entry) => entry.value.identifier == identifier)
        ?.key;

    if (searchedSymbolId == null) {
      return;
    }

    final symbol = controller.symbols.firstWhereOrNull(
      (symbol) => symbol.id == searchedSymbolId,
    );

    if (symbol == null) {
      return;
    }

    await controller.removeSymbol(symbol);
    _symbolMap.remove(symbol.id);
  }

  Future<void> drawIcon(RouteMapIcon mapIcon) async {
    await addImageToCacheIfNeeded(controller, mapIcon: mapIcon);
    if (controller.isDisposed) return;
    final existingSymbolEntry = _symbolMap.entries.firstWhereOrNull(
      (entry) => entry.value.identifier == mapIcon.identifier,
    );
    final symbolOptions = _buildSymbolOptions(mapIcon);

    if (existingSymbolEntry != null) {
      final symbol = controller.symbols.firstWhereOrNull(
        (symbol) => symbol.id == existingSymbolEntry.key,
      );
      if (symbol != null) {
        await controller.updateSymbol(symbol, symbolOptions);
        _symbolMap[symbol.id] = mapIcon;
        return;
      }
      _symbolMap.remove(existingSymbolEntry.key);
    }

    if (controller.isDisposed) return;
    final symbol = await controller.addSymbol(symbolOptions);
    _symbolMap[symbol.id] = mapIcon;
  }

  SymbolOptions _buildSymbolOptions(RouteMapIcon mapIcon) {
    final label = mapIcon.label;
    final hasLabel = label != null;

    return SymbolOptions(
      geometry: mapIcon.latLng,
      iconImage: mapIcon.identifier,
      iconAnchor: mapIcon.anchor.mglIconValue,
      iconSize: iconScale,
      iconRotate: mapIcon.rotationDegrees,
      textField: hasLabel ? label : null,
      textAnchor: hasLabel ? RouteMapIconAnchor.top.mglIconValue : null,
      textHaloWidth: hasLabel ? 3 : null,
      draggable: mapIcon.draggable,
    );
  }

  Future<Uint8List> _generatePngMarker({required RouteMapIcon mapIcon}) async {
    final theme = switch (_brightness) {
      Brightness.dark => mapIcon.darkTheme ?? mapIcon.theme,
      Brightness.light => mapIcon.theme,
    };
    return rasterizePinMarker(
      markerPath: mapIcon.markerPath,
      theme: theme,
      svgIconPath: mapIcon.svgIconPath,
      text: mapIcon.text,
    );
  }
}
