import 'package:get/get.dart';
import 'ai_chatbot_service.dart';

class CalorieCalculator extends GetxController {
  final ChatbotService _chatbotService = ChatbotService();

  // MET values for different exercises
  static const Map<String, double> _metValues = {
    'walking': 3.5,
    'running': 8.0,
    'cycling': 6.0,
    'strength_training': 6.0,
    'weightlifting': 6.0,
    'yoga': 3.0,
    'swimming': 8.0,
    'cardio': 7.0,
    'hiit': 8.5,
    'pilates': 3.5,
  };

  // Basic MET calculation
  double _calculateBasicCalories({
    required double weight,
    required int duration,
    required String exerciseType,
    double intensity = 1.0,
  }) {
    double met = _metValues[exerciseType.toLowerCase()] ?? 5.0;
    met *= intensity; // Adjust for intensity
    return (met * weight * duration) / 60;
  }

  // Heart rate based calculation
  double _calculateHRCalories({
    required int avgHeartRate,
    required int age,
    required double weight,
    required int duration,
    required String gender,
  }) {
    double calories;
    if (gender.toLowerCase() == 'male') {
      calories = ((age * 0.2017) + (weight * 0.09036) + 
                 (avgHeartRate * 0.6309) - 55.0969) * duration / 4.184;
    } else {
      calories = ((age * 0.074) + (weight * 0.05741) + 
                 (avgHeartRate * 0.4472) - 20.4022) * duration / 4.184;
    }
    return calories > 0 ? calories : 0;
  }

  // AI-enhanced calculation
  Future<double> _calculateAICalories({
    required Map<String, dynamic> userProfile,
    required Map<String, dynamic> workoutData,
  }) async {
    try {
      String prompt = """Calculate calories burned:
Weight: ${userProfile['weight']}kg, Age: ${userProfile['age']}, Gender: ${userProfile['gender']}
Workout: ${workoutData['exercises']}, Duration: ${workoutData['duration']}min, Intensity: ${workoutData['intensity']}
Return only the number.""";

      final response = await _chatbotService.chatBotService(prompt);
      return double.tryParse(response.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Hybrid calculation method
  Future<double> calculateCalories({
    required double weight,
    required int age,
    required String gender,
    required String exerciseType,
    required int duration,
    double intensity = 1.0,
    int? heartRate,
    List<String>? exercises,
  }) async {
    // Method 1: Basic MET calculation
    double basicCalories = _calculateBasicCalories(
      weight: weight,
      duration: duration,
      exerciseType: exerciseType,
      intensity: intensity,
    );

    // Method 2: Heart rate calculation (if available)
    double hrCalories = 0;
    if (heartRate != null && heartRate > 0) {
      hrCalories = _calculateHRCalories(
        avgHeartRate: heartRate,
        age: age,
        weight: weight,
        duration: duration,
        gender: gender,
      );
    }

    // Method 3: AI calculation for complex workouts
    double aiCalories = 0;
    if (exercises != null && exercises.isNotEmpty) {
      aiCalories = await _calculateAICalories(
        userProfile: {
          'weight': weight,
          'age': age,
          'gender': gender,
        },
        workoutData: {
          'exercises': exercises.join(', '),
          'duration': duration,
          'intensity': intensity > 1.2 ? 'high' : intensity > 0.8 ? 'medium' : 'low',
        },
      );
    }

    // Hybrid logic: Use best available method
    if (aiCalories > 0 && exercises != null) {
      // AI + Basic average for complex workouts
      return (aiCalories + basicCalories) / 2;
    } else if (hrCalories > 0) {
      // Heart rate + Basic average
      return (hrCalories + basicCalories) / 2;
    } else {
      // Fallback to basic calculation
      return basicCalories;
    }
  }

  // Quick calculation for dashboard
  Future<double> calculateQuickCalories(int duration, String exerciseType) async {
    // Use default user profile (can be updated from stored data)
    return calculateCalories(
      weight: 70, // Default weight
      age: 25,    // Default age
      gender: 'male',
      exerciseType: exerciseType,
      duration: duration,
      intensity: 1.0,
    );
  }
}
