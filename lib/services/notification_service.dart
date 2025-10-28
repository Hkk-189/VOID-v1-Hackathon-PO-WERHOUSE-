import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> showTransactionSuccess(String amount, String recipient) async {
    const androidDetails = AndroidNotificationDetails(
      'transaction_channel',
      'Transactions',
      channelDescription: 'Payment transaction notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      0,
      'Payment Successful',
      'Sent ₹$amount to $recipient',
      details,
    );
  }

  static Future<void> showSyncCompleted(int succeeded, int failed) async {
    const androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'Sync',
      channelDescription: 'Data sync notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      1,
      'Sync Completed',
      '$succeeded succeeded, $failed failed',
      details,
    );
  }

  static Future<void> showPaymentReceived(String amount, String sender) async {
    const androidDetails = AndroidNotificationDetails(
      'transaction_channel',
      'Transactions',
      channelDescription: 'Payment transaction notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      2,
      'Payment Received',
      'Received ₹$amount from $sender',
      details,
    );
  }

  static Future<void> showError(String title, String message) async {
    const androidDetails = AndroidNotificationDetails(
      'error_channel',
      'Errors',
      channelDescription: 'Error notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(
      3,
      title,
      message,
      details,
    );
  }
}
