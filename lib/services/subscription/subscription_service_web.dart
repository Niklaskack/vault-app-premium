class SubscriptionService {
  static Future<void> init() async {
    print('Subscription Service: Web simulation initialized.');
  }

  static Future<bool> isPremium() async {
    return true; 
  }

  static Future<void> purchasePremium() async {
    print('Purchase is not implemented on Web.');
  }
}
