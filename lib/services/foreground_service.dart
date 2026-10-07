import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../core/foreground_task.dart';

/// Encapsula o ciclo de vida do foreground service do Android.
class ForegroundService {
  static const int _serviceId = 1001;
  static const String _notificationTitle = 'Timer Boxe';

  /// Solicita permissão de notificação caso ainda não concedida.
  static Future<void> requestPermission() async {
    final perm = await FlutterForegroundTask.checkNotificationPermission();
    if (perm != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  /// Inicia o foreground service. Não faz nada se já estiver rodando.
  static Future<void> start(String notificationText) async {
    if (await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.startService(
      serviceId: _serviceId,
      notificationTitle: _notificationTitle,
      notificationText: notificationText,
      callback: foregroundTaskEntryPoint,
    );
  }

  /// Para o foreground service. Não faz nada se não estiver rodando.
  static Future<void> stop() async {
    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.stopService();
    }
  }

  /// Atualiza o texto da notificação persistente.
  static void updateNotification(String text) {
    FlutterForegroundTask.updateService(
      notificationTitle: _notificationTitle,
      notificationText: text,
    );
  }
}
