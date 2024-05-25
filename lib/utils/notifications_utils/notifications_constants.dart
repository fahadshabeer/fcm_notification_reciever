import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationConstants {
  static DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
    notificationCategories: [
      DarwinNotificationCategory(
        'cat_1',
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.customDismissAction,
        },
      )
    ],
  );

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {}
}
