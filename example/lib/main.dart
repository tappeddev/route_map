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

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _mobileBreakpoint = 600.0;

  int _selectedIndex = 0;

  void _select(int index) => setState(() => _selectedIndex = index);

  void _selectFromDrawer(int index) {
    _select(index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final example = _examples[_selectedIndex];
    final isMobile = MediaQuery.sizeOf(context).width < _mobileBreakpoint;

    return Scaffold(
      appBar: AppBar(title: Text(example.title)),
      drawer: isMobile ? _buildDrawer() : null,
      body: isMobile ? _buildSelectedExample() : _buildRailLayout(),
    );
  }

  Widget _buildRailLayout() {
    return Row(
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
        Expanded(child: _buildSelectedExample()),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "route_map examples",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _examples.length,
                itemBuilder: (context, index) {
                  final example = _examples[index];
                  return ListTile(
                    leading: Icon(example.icon),
                    title: Text(example.title),
                    subtitle: Text(example.subtitle),
                    selected: index == _selectedIndex,
                    onTap: () => _selectFromDrawer(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedExample() {
    final example = _examples[_selectedIndex];

    return KeyedSubtree(
      key: ValueKey(_selectedIndex),
      child: example.builder(context),
    );
  }
}

// region example pages

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

// endregion
