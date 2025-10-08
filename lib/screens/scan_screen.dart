import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:style_snap/screens/home_screen.dart';
import '../../services/tflite_service.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _service = TFLiteService();
  File? _image;
  Map<String, dynamic>? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _service.loadModel();
  }

  Future<void> _pickImage(ImageSource src) async {
    final picked = await ImagePicker().pickImage(source: src);
    if (picked == null) return;
    setState(() {
      _image = File(picked.path);
      _loading = true;
    });

    final res = await _service.predict(_image!);
    await _saveResultToFirebase(_image!, res);

    setState(() {
      _result = res;
      _loading = false;
    });
    HomeScreen.lastImage = _image;
    HomeScreen.lastResult = res;
  }

  Future<void> _saveResultToFirebase(File image, Map<String, dynamic> result) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imgRef = storageRef.child('scans/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await imgRef.putFile(image);
    final url = await imgRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('scans').add({
      'label': result['label'],
      'confidence': result['confidence'],
      'imageUrl': url,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Scan Outfit', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (_image != null) ...[
            Image.file(_image!, height: 250),
            const SizedBox(height: 12),
            if (_result != null)
              Text(
                '${_result!['label']}  (${(_result!['confidence'] * 100).toStringAsFixed(2)}%)',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
          ],
        ],
      ),
    );
  }
}
