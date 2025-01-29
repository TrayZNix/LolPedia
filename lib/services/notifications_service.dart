import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:lol_pedia/dinamic_general_variables.dart';
// ignore: depend_on_referenced_packages
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
    // await flutterLocalNotificationsPlugin.show(
    //     1, "Test", "Esta es una notificacion de pruebas", notificationDetails);
    String teamA = "test";
    String teamB = "test";
    await flutterLocalNotificationsPlugin.zonedSchedule(
      calcularId(teamA + teamB, DateTime.now().toIso8601String()),
      (teamA != 'TBD' && teamB != 'TBD') ? '$teamA Vs. $teamB' : 'test',
      (teamA != 'TBD' && teamB != 'TBD')
          ? '¡Corre! El partido "test" de la liga "test" empezará pronto'
          : '¡Corre! El partido empezará pronto',
      tz.TZDateTime.now(tz.getLocation("UTC")).add(const Duration(seconds: 2)),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotification(
    int matchId,
    String teamA,
    String teamB,
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

    int notificationId =
        calcularId(teamA + teamB, fechaPartido.toIso8601String());
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      (teamA != 'TBD' && teamB != 'TBD')
          ? '$teamA Vs. $teamB'
          : '$nombrePartido | $liga',
      (teamA != 'TBD' && teamB != 'TBD')
          ? '¡Corre! El partido "$nombrePartido" de la liga "$liga" empezará pronto'
          : '¡Corre! El partido empezará pronto',
      fechaPartido
          .subtract(GetIt.I.get<DynamicGeneralVariables>().timeZoneOffset),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<bool> checkNotificationExists(
      String teamA, String teamB, String fecha) async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    int notificationId = calcularId(teamA + teamB, fecha);
    for (var notification in pendingNotifications) {
      if (notification.id == notificationId) {
        return true;
      }
    }

    return false;
  }

  Future<void> cancelNotification(
      String teamA, String teamB, tz.TZDateTime fecha) async {
    await flutterLocalNotificationsPlugin
        .cancel(calcularId(teamA + teamB, fecha.toIso8601String()));
  }

  int calcularId(String teams, String fecha) {
    teams = teams + fecha;
    var numberHash = teams.hashCode;
    int count = 0;
    int sum = 0;
    int num = numberHash.abs();

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

    if (numberHash < 0) {
      result *= -1;
    }

    return numberHash;
  }
}
