import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:io';

class SubscriptionService {
  static const _apiKey = "REVENUECAT_API_KEY_HERE"; // User needs to provide this

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKey);
    } else {
      configuration = PurchasesConfiguration(_apiKey);
    }
    await Purchases.configure(configuration);
  }

  static Future<bool> isPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all["premium"]?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> purchasePremium() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        await Purchases.purchasePackage(offerings.current!.availablePackages.first);
      }
    } catch (e) {
      // Handle error
    }
  }
}
