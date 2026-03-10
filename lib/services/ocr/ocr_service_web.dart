import 'ocr_service_interface.dart';

class OcrService implements OcrServiceInterface {
  @override
  Future<ReceiptData?> scanImage(String imagePath) async {
    print('OCR is not supported on Web in this implementation.');
    return ReceiptData(merchant: 'Web Demo', amount: 0.0);
  }

  @override
  void dispose() {
    // No-op
  }
}
