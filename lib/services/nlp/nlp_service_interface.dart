import '../../domain/models/transaction.dart';

abstract class NlpServiceInterface {
  Future<void> initTflite();
  Transaction? parseSms(String smsContent);
  Transaction? parseSentence(String sentence);
}
