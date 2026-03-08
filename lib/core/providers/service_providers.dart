import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../services/bank_sync_service.dart';
import '../../services/nlp_service.dart';
import '../../services/analysis_service.dart';
import '../../services/ocr_service.dart';
import '../../services/voice_service.dart';

final authServiceProvider = Provider((ref) => AuthService());
final bankSyncServiceProvider = Provider((ref) => BankSyncService());
final nlpServiceProvider = Provider((ref) => NlpService());
final analysisServiceProvider = Provider((ref) => AnalysisService());
final ocrServiceProvider = Provider((ref) {
  final service = OcrService();
  ref.onDispose(() => service.dispose());
  return service;
});

final voiceServiceProvider = Provider((ref) {
  return VoiceService();
});
