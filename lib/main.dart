import 'package:cradle/widgets/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'route/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initNotifications();
  //NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  // schedule push notifications for a week.
  // void schedulePushNotifications() async {
  //   NotificationManagement notificationManagement = NotificationManagement();
  //
  //
  //   tz.initializeTimeZones();
  //   tz.TZDateTime birthline = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime deadline = birthline.add(const Duration(days: 7));
  //   tz.TZDateTime indexDate = birthline;
  //
  //   while (deadline.isAfter(indexDate)) {
  //     // notificationManagement.removePushNotification(indexDate);
  //     bool isNotificationScheduled = await notificationManagement
  //         .isNotificationScheduledForThisDay(indexDate);
  //
  //     if (!isNotificationScheduled) {
  //       notificationManagement.addPushNotification(indexDate);
  //     }
  //     indexDate = indexDate.add(const Duration(days: 1));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // schedulePushNotifications();

    return ChangeNotifierProvider(
      create: (context) => ModeTheme(),
      child: DynamicTheme(
        child: const MyHomePage(title: 'CRADLE'),
      ),
    );
  }
}
