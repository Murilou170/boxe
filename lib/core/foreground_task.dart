import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Entry-point do isolate do foreground service.
/// Deve estar no nível superior (top-level) e anotado com vm:entry-point.
@pragma('vm:entry-point')
void foregroundTaskEntryPoint() {
  FlutterForegroundTask.setTaskHandler(_BoxeTaskHandler());
}

class _BoxeTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}
