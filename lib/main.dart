import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:style_snap/screens/favourites_screen.dart';
import 'package:style_snap/screens/home_screen.dart';
import 'package:style_snap/screens/scan_screen.dart';
import 'package:style_snap/screens/search_screen.dart';
import 'package:style_snap/screens/settings_screen.dart';
import 'package:style_snap/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NOTE: Your android/google-services.json (project stylesnap-ai-cc2c1) and
  // firebase_options.dart (project stylesnap-ai-4cb1f) are from DIFFERENT Firebase projects.
  // This causes a duplicate-app error when trying to initialize with explicit options
  // while a default app is already configured natively. Short-term we catch the error
  // so the app doesn't crash. Long-term: regenerate firebase_options.dart to match
  // google-services.json OR replace google-services.json with the one from stylesnap-ai-4cb1f to unify.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      // Safe to ignore: Firebase default app already initialized natively.
    } else {
      rethrow;
    }
  }
  runApp(const StyleSnapApp());
}

class StyleSnapApp extends StatefulWidget {
  const StyleSnapApp({super.key});
  @override
  State<StyleSnapApp> createState() => _StyleSnapAppState();
}

class _StyleSnapAppState extends State<StyleSnapApp> {
  ThemeMode _mode = ThemeMode.system;
  void _toggle(bool dark) =>
      setState(() => _mode = dark ? ThemeMode.dark : ThemeMode.light);
  // Navigator key to allow navigation from callbacks without relying on an out-of-scope context.
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      title: 'StyleSnap-AI',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      // Start with splash then navigate to the main shell.
      home: SplashScreen(
        onFinished:
            () => _navKey.currentState?.pushReplacement(
              MaterialPageRoute(
                builder: (_) => RootShell(onThemeChanged: _toggle),
              ),
            ),
      ),
    );
  }
}

class RootShell extends StatefulWidget {
  final void Function(bool dark) onThemeChanged;
  const RootShell({super.key, required this.onThemeChanged});
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _idx = 0;
  late final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const ScanScreen(),
    const FavouritesScreen(),
    SettingsScreen(onThemeChanged: widget.onThemeChanged),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Fav',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
