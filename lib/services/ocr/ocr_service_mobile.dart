import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'ocr_service_interface.dart';

class OcrService implements OcrServiceInterface {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  Future<ReceiptData?> scanImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    return _parseReceiptData(recognizedText.text);
  }

  ReceiptData _parseReceiptData(String text) {
    final lines = text.split('\n');
    String merchant = '';
    double amount = 0.0;

    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        merchant = line.trim();
        break;
      }
    }

    final amountRegex = RegExp(r'(\d+[\.,]\d{2})');
    for (var line in lines) {
      if (line.toUpperCase().contains('TOTAL') || line.contains(r'$')) {
        final matches = amountRegex.allMatches(line);
        if (matches.isNotEmpty) {
          final amtStr = matches.last.group(1)?.replaceAll(',', '.');
          if (amtStr != null) {
            amount = double.tryParse(amtStr) ?? 0.0;
            break;
          }
        }
      }
    }

    return ReceiptData(merchant: merchant, amount: amount);
  }

  @override
  void dispose() {
    _textRecognizer.close();
  }
}
