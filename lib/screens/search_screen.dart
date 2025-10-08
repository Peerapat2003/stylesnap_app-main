import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = ['Business Casual', 'Casual', 'Sport', 'Streetwear', 'Vintage'];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search style...',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
          const SizedBox(height: 12),
          ...styles.map((s) => Card(child: ListTile(title: Text(s), trailing: const Icon(Icons.arrow_forward_ios)))),
        ],
      ),
    );
  }
}
