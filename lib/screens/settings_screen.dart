import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final void Function(bool dark) onThemeChanged;
  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: onThemeChanged,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('StyleSnap-AI v1.0 — powered by Flutter, Firebase & TFLite'),
          ),
        ],
      ),
    );
  }
}
