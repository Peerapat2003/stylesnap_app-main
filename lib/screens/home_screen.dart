import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static File? lastImage;
  static Map<String, dynamic>? lastResult;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final res = HomeScreen.lastResult;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome 👋', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          if (res != null && HomeScreen.lastImage != null) ...[
            const Text('ผลการสแกนล่าสุด:'),
            const SizedBox(height: 8),
            Image.file(HomeScreen.lastImage!, height: 200),
            Text('${res['label']} (${(res['confidence'] * 100).toStringAsFixed(2)}%)'),
          ] else
            const Text('ยังไม่มีการสแกนล่าสุด'),
          const SizedBox(height: 16),
          const Divider(),
          const Text('อัปเดตล่าสุดจากผู้ใช้ทั้งหมด', style: TextStyle(fontWeight: FontWeight.bold)),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('scans').orderBy('createdAt', descending: true).limit(5).snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snap.data!.docs;
              return Column(
                children: docs.map((d) {
                  final data = d.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Image.network(data['imageUrl'], width: 60, fit: BoxFit.cover),
                    title: Text(data['label']),
                    subtitle: Text('Conf: ${(data['confidence'] * 100).toStringAsFixed(1)}%'),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
