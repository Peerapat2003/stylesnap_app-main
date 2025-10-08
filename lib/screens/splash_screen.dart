import 'package:flutter/material.dart';
// Splash screen now not directly depending on HomeScreen; navigation handled via callback.

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const SplashScreen({super.key, this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use post frame + mounted check to avoid using context across async gap.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      widget.onFinished?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 230),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.blueAccent,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
