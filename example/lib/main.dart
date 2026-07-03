import 'package:flutter/material.dart';

import 'package:example/examples/map_bottom_sheet.dart';
import 'package:example/examples/route_and_icons_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}

/// A single selectable example in the drawer.
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

/// App shell hosting the navigation drawer and the currently-selected example.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  void _select(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final example = _examples[_selectedIndex];

    return Scaffold(
      appBar: AppBar(title: Text(example.title)),
      drawer: Drawer(
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
                    final e = _examples[index];
                    return ListTile(
                      leading: Icon(e.icon),
                      title: Text(e.title),
                      subtitle: Text(e.subtitle),
                      selected: index == _selectedIndex,
                      onTap: () => _select(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // A key per index ensures each example is fully rebuilt (fresh map
      // controllers) when switching pages.
      body: KeyedSubtree(
        key: ValueKey(_selectedIndex),
        child: example.builder(context),
      ),
    );
  }
}
