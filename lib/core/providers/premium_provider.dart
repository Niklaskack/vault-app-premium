import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/subscription_service.dart';

final isPremiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<bool> {
  PremiumNotifier() : super(false) {
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    state = await SubscriptionService.isPremium();
  }

  Future<void> refresh() async {
    await _checkStatus();
  }
}
