import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  factory TFLiteService() => _instance;
  TFLiteService._internal();

  late Interpreter _interpreter;
  late List<String> _labels;
  bool _loaded = false;

  Future<void> loadModel() async {
    if (_loaded) return;
    _interpreter = await Interpreter.fromAsset('assets/models/stylesnap_fp16.tflite');
    final labelData = await File('assets/models/labels.txt').readAsString();
    _labels = labelData.split('\n').where((e) => e.isNotEmpty).toList();
    _loaded = true;
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (!_loaded) await loadModel();

    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final resized = img.copyResize(image, width: 224, height: 224);
    final input = List.generate(1, (_) => List.generate(224, (_) => List.generate(224, (_) => List.filled(3, 0.0))));

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resized.getPixel(x, y);
        input[0][y][x][0] = (pixel.r / 127.5) - 1.0;
        input[0][y][x][1] = (pixel.g / 127.5) - 1.0;
        input[0][y][x][2] = (pixel.b / 127.5) - 1.0;
      }
    }

    final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
    _interpreter.run(input, output);

    final confidences = output[0] as List<double>;
    final maxIdx = confidences.indexOf(confidences.reduce((a, b) => a > b ? a : b));

    return {'label': _labels[maxIdx], 'confidence': confidences[maxIdx]};
  }
}
