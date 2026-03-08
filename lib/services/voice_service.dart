import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/foundation.dart';

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;

  Future<bool> init() async {
    try {
      _isAvailable = await _speech.initialize(
        onStatus: (status) => debugPrint('Voice Status: $status'),
        onError: (error) => debugPrint('Voice Error: $error'),
      );
      return _isAvailable;
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
      return false;
    }
  }

  void startListening(Function(String) onResult) {
    if (!_isAvailable) return;
    
    _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
    );
  }

  void stopListening() {
    _speech.stop();
  }

  bool get isListening => _speech.isListening;
}
