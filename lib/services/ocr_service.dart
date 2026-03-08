import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<ReceiptData?> scanImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    return _parseReceiptData(recognizedText.text);
  }

  ReceiptData _parseReceiptData(String text) {
    final lines = text.split('\n');
    String merchant = '';
    double amount = 0.0;

    // Logic: Merchant is usually on the first non-empty line
    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        merchant = line.trim();
        break;
      }
    }

    // Logic: Look for lines with currency patterns like '$ 10.00' or 'TOTAL 10.00'
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

  void dispose() {
    _textRecognizer.close();
  }
}

class ReceiptData {
  final String merchant;
  final double amount;
  ReceiptData({required this.merchant, required this.amount});
}
