class ReceiptData {
  final String merchant;
  final double amount;
  ReceiptData({required this.merchant, required this.amount});
}

abstract class OcrServiceInterface {
  Future<ReceiptData?> scanImage(String imagePath);
  void dispose();
}
