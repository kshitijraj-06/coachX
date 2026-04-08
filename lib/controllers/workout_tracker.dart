import 'package:get/get.dart';
import 'calorie_calculator.dart';
import 'chat_storage_service.dart';

class WorkoutTracker extends GetxController {
  final CalorieCalculator _calorieCalculator = CalorieCalculator();
  
  var totalCalories = 450.obs; // Default value
  var workoutTime = 45.obs;    // Default value
  var isTracking = false.obs;
  
  DateTime? _workoutStartTime;

  // Start workout tracking
  void startWorkout() {
    _workoutStartTime = DateTime.now();
    isTracking.value = true;
  }

  // End workout and calculate calories
  Future<void> endWorkout({
    required String exerciseType,
    List<String>? exercises,
    double intensity = 1.0,
    int? heartRate,
  }) async {
    if (_workoutStartTime == null) return;
    
    int duration = DateTime.now().difference(_workoutStartTime!).inMinutes;
    workoutTime.value = duration;
    
    // Get user profile for accurate calculation
    Map<String, dynamic> userProfile = await _getUserProfile();
    
    double calories = await _calorieCalculator.calculateCalories(
      weight: userProfile['weight'],
      age: userProfile['age'],
      gender: userProfile['gender'],
      exerciseType: exerciseType,
      duration: duration,
      intensity: intensity,
      heartRate: heartRate,
      exercises: exercises,
    );
    
    totalCalories.value = calories.round();
    isTracking.value = false;
    
    // Save workout data
    await _saveWorkoutData(duration, calories, exerciseType);
  }

  // Get user profile from storage or defaults
  Future<Map<String, dynamic>> _getUserProfile() async {
    // Try to get from stored personal info, fallback to defaults
    return {
      'weight': 70.0,  // Can be updated from personal info page
      'age': 25,
      'gender': 'male',
    };
  }

  // Save workout data locally
  Future<void> _saveWorkoutData(int duration, double calories, String type) async {
    Map<String, dynamic> workoutData = {
      'date': DateTime.now().toIso8601String(),
      'duration': duration,
      'calories': calories,
      'type': type,
    };
    
    // Save to local storage (can be expanded)
    await ChatStorageService.saveChat('workout_history', [workoutData]);
  }

  // Update calories for dashboard display
  Future<void> updateDashboardCalories() async {
    double calories = await _calorieCalculator.calculateQuickCalories(
      workoutTime.value, 
      'strength_training'
    );
    totalCalories.value = calories.round();
  }
}
