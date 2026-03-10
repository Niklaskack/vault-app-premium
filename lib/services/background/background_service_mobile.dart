import 'package:workmanager/workmanager.dart';
import '../../data/local/database_service.dart';
import '../../services/nlp_service.dart';
import '../../domain/models/transaction.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'sms_sync':
        final nlp = NlpService();
        final db = DatabaseService();
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
