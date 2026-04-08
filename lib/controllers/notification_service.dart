import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService extends GetxController {
  final storage = FlutterSecureStorage();
  final RxBool workoutReminders = true.obs;
  final RxBool progressUpdates = true.obs;
  final RxBool aiRecommendations = true.obs;
  final RxBool weeklyReports = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkNotificationPermission();
    loadNotificationSettings();
  }

  Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> loadNotificationSettings() async {
    try {
      final workoutRem = await storage.read(key: 'workout_reminders');
      final progressUpd = await storage.read(key: 'progress_updates');
      final aiRec = await storage.read(key: 'ai_recommendations');
      final weeklyRep = await storage.read(key: 'weekly_reports');
      
      workoutReminders.value = workoutRem == null ? true : workoutRem == 'true';
      progressUpdates.value = progressUpd == null ? true : progressUpd == 'true';
      aiRecommendations.value = aiRec == null ? true : aiRec == 'true';
      weeklyReports.value = weeklyRep == null ? true : weeklyRep == 'true';
      
      // Save defaults if first time
      if (workoutRem == null) await storage.write(key: 'workout_reminders', value: 'true');
      if (progressUpd == null) await storage.write(key: 'progress_updates', value: 'true');
      if (aiRec == null) await storage.write(key: 'ai_recommendations', value: 'true');
      if (weeklyRep == null) await storage.write(key: 'weekly_reports', value: 'true');
    } catch (e) {
      print('Error loading notification settings: $e');
    }
  }

  Future<void> updateNotificationSetting(String type, bool value) async {
    try {
      switch (type) {
        case 'workoutReminders':
          workoutReminders.value = value;
          await storage.write(key: 'workout_reminders', value: value.toString());
          break;
        case 'progressUpdates':
          progressUpdates.value = value;
          await storage.write(key: 'progress_updates', value: value.toString());
          break;
        case 'aiRecommendations':
          aiRecommendations.value = value;
          await storage.write(key: 'ai_recommendations', value: value.toString());
          break;
        case 'weeklyReports':
          weeklyReports.value = value;
          await storage.write(key: 'weekly_reports', value: value.toString());
          break;
      }
    } catch (e) {
      print('Error updating notification setting: $e');
    }
  }
}
