import 'package:workmanager/workmanager.dart';
import '../data/local/database_service.dart';
import '../services/nlp_service.dart';
import '../domain/models/transaction.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'sms_sync':
        // logic to scan SMS and parse
        // Since we can't easily access SMS in background without platform-specific code/permissions,
        // we'll simulate a find.
        final nlp = NlpService();
        final db = DatabaseService();
        
        // Mocking a found SMS
        const mockSms = r"Spent $15.99 at Netflix on 2026-03-08";
        final tx = nlp.parseSms(mockSms);
        if (tx != null) {
          await db.insertTransaction(tx);
        }
        break;
    }
    return Future.value(true);
  });
}

class BackgroundService {
  static void init() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  static void scheduleSmsSync() {
    Workmanager().registerPeriodicTask(
      "1",
      "sms_sync",
      frequency: const Duration(hours: 1),
    );
  }
}
