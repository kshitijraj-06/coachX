import 'package:get/get.dart';

class WorkoutService extends GetxController {
  
  static Map<String, List<Map<String, dynamic>>> workoutsByGoal = {
    'Weight Loss': [
      {'name': 'HIIT Cardio', 'exercises': 8, 'duration': '30 min', 'icon': 'cardio'},
      {'name': 'Fat Burn Circuit', 'exercises': 6, 'duration': '25 min', 'icon': 'circuit'},
      {'name': 'Cardio Dance', 'exercises': 5, 'duration': '35 min', 'icon': 'dance'},
      {'name': 'Running Intervals', 'exercises': 4, 'duration': '40 min', 'icon': 'running'},
    ],
    'Muscle Gain': [
      {'name': 'Chest & Triceps', 'exercises': 6, 'duration': '45 min', 'icon': 'strength'},
      {'name': 'Back & Biceps', 'exercises': 5, 'duration': '50 min', 'icon': 'strength'},
      {'name': 'Legs & Glutes', 'exercises': 7, 'duration': '60 min', 'icon': 'legs'},
      {'name': 'Shoulders & Core', 'exercises': 6, 'duration': '40 min', 'icon': 'strength'},
    ],
    'Strength Training': [
      {'name': 'Powerlifting Basics', 'exercises': 4, 'duration': '60 min', 'icon': 'powerlifting'},
      {'name': 'Compound Movements', 'exercises': 5, 'duration': '55 min', 'icon': 'strength'},
      {'name': 'Heavy Lifting', 'exercises': 6, 'duration': '70 min', 'icon': 'powerlifting'},
      {'name': 'Functional Strength', 'exercises': 7, 'duration': '45 min', 'icon': 'functional'},
    ],
    'Endurance': [
      {'name': 'Long Distance Run', 'exercises': 3, 'duration': '60 min', 'icon': 'running'},
      {'name': 'Cycling Endurance', 'exercises': 4, 'duration': '75 min', 'icon': 'cycling'},
      {'name': 'Swimming Laps', 'exercises': 5, 'duration': '45 min', 'icon': 'swimming'},
      {'name': 'Cross Training', 'exercises': 6, 'duration': '50 min', 'icon': 'cross'},
    ],
    'General Fitness': [
      {'name': 'Full Body Workout', 'exercises': 8, 'duration': '40 min', 'icon': 'fullbody'},
      {'name': 'Yoga Flow', 'exercises': 6, 'duration': '35 min', 'icon': 'yoga'},
      {'name': 'Pilates Core', 'exercises': 7, 'duration': '30 min', 'icon': 'pilates'},
      {'name': 'Flexibility & Mobility', 'exercises': 5, 'duration': '25 min', 'icon': 'flexibility'},
    ],
  };

  List<Map<String, dynamic>> getWorkoutsForGoal(String goal) {
    return workoutsByGoal[goal] ?? workoutsByGoal['General Fitness']!;
  }
}
