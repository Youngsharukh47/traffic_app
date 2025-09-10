import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/routes_screen.dart';
import 'screens/traffic_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const NairobiTrafficApp());
}

class NairobiTrafficApp extends StatelessWidget {
  const NairobiTrafficApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nairobi Traffic App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    RoutesScreen(),
    TrafficScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.route), label: "Routes"),
          BottomNavigationBarItem(icon: Icon(Icons.traffic), label: "Traffic"),
          BottomNavigationBarItem(icon: Icon(Icons.miscellaneous_services), label: "Services"),
        ],
      ),
    );
  }
}
