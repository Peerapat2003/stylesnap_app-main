import 'package:flutter/material.dart';
import 'package:style_snap/screens/favourites_screen.dart';
import 'package:style_snap/screens/home_screen.dart';
import 'package:style_snap/screens/scan_screen.dart';
import 'package:style_snap/screens/search_screen.dart';
import 'package:style_snap/screens/settings_screen.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  const CustomNavigationBar({super.key, required this.currentIndex});

  void onTabTapped(BuildContext context, int index) {
    final screens = [
      const HomeScreen(),
      const SearchScreen(),
      const ScanScreen(),
      const FavouritesScreen(),
      SettingsScreen(onThemeChanged: (bool dark) {},)
    ];
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => screens[index]));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (i) => onTabTapped(context, i),
      selectedItemColor: const Color(0xFF6ED6D6),
      unselectedItemColor: Colors.grey[400],
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Fav'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
      ],
    );
  }
}
