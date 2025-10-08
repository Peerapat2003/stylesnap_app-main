import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scans = FirebaseFirestore.instance.collection('scans').orderBy('createdAt', descending: true).snapshots();

    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: scans,
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('ยังไม่มีข้อมูล'));
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Image.network(d['imageUrl'], width: 60, fit: BoxFit.cover),
                  title: Text(d['label']),
                  subtitle: Text('Confidence: ${(d['confidence'] * 100).toStringAsFixed(1)}%'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
