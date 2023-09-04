import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> testNotifications() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('test', 'Notificaciones de prueba');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        1, "Test", "Esta es una notificacion de pruebas", notificationDetails);
  }

  Future<void> showNotification(
    int matchId,
    String team1,
    String team2,
    String nombrePartido,
    String liga,
    tz.TZDateTime fechaPartido,
  ) async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('eventos', 'Notificaciones de partidos');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    int notificationId = calcularId(matchId);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      (team1 != 'TBD' && team2 != 'TBD')
          ? '$team1 Vs. $team2'
          : '$nombrePartido | $liga',
      (team1 != 'TBD' && team2 != 'TBD')
          ? '¡Corre! El partido "$nombrePartido" de la liga "$liga" empezará pronto'
          : '¡Corre! El partido empezará pronto',
      fechaPartido,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<bool> checkNotificationExists(int id) async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    int notificationId = calcularId(id);
    for (var notification in pendingNotifications) {
      if (notification.id == notificationId) {
        return true;
      }
    }

    return false;
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(calcularId(notificationId));
  }

  int calcularId(int number) {
    number = number - 13803666586180000;
    int count = 0;
    int sum = 0;
    int num = number.abs();

    while (num != 0) {
      sum += num % 10;
      num ~/= 10;
      count++;
    }

    double average = sum / count;
    int result = average.toInt();

    // Si hay decimales, convertirlos en parte del entero resultante
    if (average != result.toDouble()) {
      int decimalPart = (average * 10).toInt();
      result = result * 10 + decimalPart;
    }

    if (number < 0) {
      result *= -1;
    }

    return result;
  }
}
