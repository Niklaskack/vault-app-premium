abstract class SubscriptionServiceInterface {
  Future<void> init();
  Future<bool> isPremium();
  Future<void> purchasePremium();
}
