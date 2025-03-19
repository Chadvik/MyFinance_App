import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Initialize notifications
  Future<void> init() async {
    // Initialize Awesome Notifications
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher', // Icon for Android (uses app icon)
      [
        NotificationChannel(
          channelKey: 'my_finance_channel',
          channelName: 'My Finance Notifications',
          channelDescription: 'Notifications for My Finance app',
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Public,
          playSound: true,
        ),
      ],
      debug: true, // Enable debug logs for troubleshooting
    );

    // Request notification permission (covers Android 13+ and iOS)
    final granted = await AwesomeNotifications().requestPermissionToSendNotifications();
    if (!granted) {
      print('Notification permission not granted');
      // Optionally inform the user (e.g., show a dialog)
    }

    // Initialize timezone data
    tz.initializeTimeZones();
    // Use the device's local timezone (no need for flutter_native_timezone here)
    tz.setLocalLocation(tz.local);
  }

  // Schedule a notification with a unique ID
  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    try {
      final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'my_finance_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true, // Wake up screen when notification fires
          category: NotificationCategory.Reminder,
        ),
        schedule: NotificationCalendar.fromDate(
          date: scheduledDateTime,
          preciseAlarm: true, // Use exact timing (requires permission)
          allowWhileIdle: true, // Allow in Doze mode
        ),
      );
      print('Notification scheduled: $title at ${DateFormat.yMd().add_jms().format(scheduledTime)}');
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }

  // Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    try {
      await AwesomeNotifications().cancel(id);
      print('Notification $id canceled');
    } catch (e) {
      print('Error canceling notification: $e');
      rethrow;
    }
  }
}