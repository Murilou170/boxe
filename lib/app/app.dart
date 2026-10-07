import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../ui/timer_page.dart';

/// Inicializa o flutter_foreground_task. Chamado em main() antes de runApp.
void initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'boxe_timer',
      channelName: 'Timer de Boxe',
      channelDescription: 'Notificação do timer de boxe em execução.',
      onlyAlertOnce: true,
      playSound: false,
      enableVibration: false,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(1000),
      autoRunOnBoot: false,
      allowWakeLock: true,
    ),
  );
}

/// Widget raiz da aplicação.
class BoxeApp extends StatelessWidget {
  const BoxeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer Boxe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE53935),
          surface: const Color(0xFF1A1A1A),
        ),
      ),
      home: WithForegroundTask(child: const BoxeTimerPage()),
    );
  }
}
