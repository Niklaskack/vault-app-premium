import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../domain/models/transaction.dart';
import 'nlp_service_interface.dart';

class NlpService implements NlpServiceInterface {
  Interpreter? _interpreter;

  @override
  Future<void> initTflite() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/transaction_parser.tflite');
      print('TFLite model loaded successfully');
    } catch (e) {
      print('Failed to load TFLite model: $e');
    }
  }
  
  @override
  Transaction? parseSms(String smsContent) {
    if (_interpreter != null) {
      return _parseWithTflite(smsContent);
    }
    return _parseWithRules(smsContent);
  }

  Transaction? _parseWithTflite(String smsContent) {
    return _parseWithRules(smsContent);
  }

  Transaction? _parseWithRules(String smsContent) {
    final amountRegex = RegExp(r'\$(\d+\.\d+)');
    final merchantRegex = RegExp(r'at\s+([A-Za-z\s]+)\s+on');
    
    final amountMatch = amountRegex.firstMatch(smsContent);
    final merchantMatch = merchantRegex.firstMatch(smsContent);
    
    if (amountMatch != null && merchantMatch != null) {
      final amount = double.parse(amountMatch.group(1)!);
      final merchant = merchantMatch.group(1)!.trim();
      
      return Transaction(
        merchant: merchant,
        amount: amount,
        date: DateTime.now(),
        type: TransactionType.expense,
        rawSms: smsContent,
        isParsed: true,
      );
    }
    return null;
  }

  @override
  Transaction? parseSentence(String sentence) {
    if (sentence.isEmpty) return null;

    final lower = sentence.toLowerCase();
    double amount = 0.0;
    String merchant = '';

    final amountRegex = RegExp(r'(\d+[\.,]?\d{0,2})');
    final matches = amountRegex.allMatches(sentence);
    for (var match in matches) {
      final val = double.tryParse(match.group(1)?.replaceAll(',', '.') ?? '');
      if (val != null && val > 0) {
        amount = val;
        break;
      }
    }

    final merchantRegex = RegExp(r'(?:at|from|to)\s+([a-zA-Z0-9\s]+?)(?:\s+for|\s+on|\s+yesterday|$)');
    final merchantMatch = merchantRegex.firstMatch(lower);
    if (merchantMatch != null) {
      merchant = sentence.substring(merchantMatch.start + merchantMatch.group(0)!.indexOf(merchantMatch.group(1)!), merchantMatch.end).trim();
    } else {
      final words = sentence.split(' ');
      if (words.length > 2) {
        merchant = words.last; 
      }
    }

    if (amount == 0 && merchant.isEmpty) return null;

    return Transaction(
      merchant: merchant.isEmpty ? 'Unknown' : merchant,
      amount: amount,
      date: DateTime.now(),
      category: TransactionCategory.other,
    );
  }
}
