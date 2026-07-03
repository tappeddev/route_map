import 'package:flutter/material.dart';

import 'package:example/examples/map_bottom_sheet.dart';
import 'package:example/examples/route_and_icons_example.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Map Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}

/// A single selectable example in the navigation rail.
class ExamplePage {
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;

  const ExamplePage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.builder,
  });
}

final _examples = <ExamplePage>[
  ExamplePage(
    title: "Route & Icons",
    subtitle: "Draw a route with start/end pins",
    icon: Icons.route,
    builder: (_) => const RouteAndIconsExample(),
  ),
  ExamplePage(
    title: "Map bottom sheet",
    subtitle: "Detailed map in a draggable sheet",
    icon: Icons.layers,
    builder: (_) => const MapBottomSheetPage(),
  ),
];

/// App shell hosting the navigation rail and the currently-selected example.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  void _select(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final example = _examples[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: Text(example.title)),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            selectedIndex: _selectedIndex,
            onDestinationSelected: _select,
            destinations: [
              for (final e in _examples)
                NavigationRailDestination(
                  icon: Icon(e.icon),
                  selectedIcon: Icon(e.icon),
                  label: Text(e.title),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: example.builder(context),
            ),
          ),
        ],
      ),
    );
  }
}
