import 'package:get/get.dart';
import 'workout_tracker_service.dart';

class DashboardService extends GetxController {
  late WorkoutTrackerService workoutTracker;
  
  RxInt get totalCalories => workoutTracker.totalCalories;
  RxInt get workoutTime => workoutTracker.workoutTime;
  RxInt get weeklyGoal => workoutTracker.weeklyGoal;
  RxInt get streak => workoutTracker.streak;

  @override
  void onInit() {
    super.onInit();
    workoutTracker = Get.put(WorkoutTrackerService());
  }

  Future<void> fetchDashboardData() async {
    await workoutTracker.loadStats();
  }
}
