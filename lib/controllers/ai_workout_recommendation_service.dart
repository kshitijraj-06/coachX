import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/envVars.dart';
import '../models/workout.dart';
import 'workoutsService.dart';
import 'user_workout_service.dart';

class AIWorkoutRecommendationService extends GetxController {
  final storage = FlutterSecureStorage();
  final RxBool isGenerating = false.obs;

  Future<void> generateWorkoutsForUser(String fitnessGoal) async {
    try {
      isGenerating.value = true;
      
      // Check if AI workouts already exist for this goal
      final storedGoal = await storage.read(key: 'ai_workouts_goal');
      if (storedGoal == fitnessGoal) {
        print('AI workouts already generated for $fitnessGoal');
        return;
      }
      
      // Get available workouts
      final workoutService = Get.put(WorkoutService1());
      final userWorkoutService = Get.put(UserWorkoutService());
      
      if (workoutService.workouts.isEmpty) {
        await workoutService.fetchWorkouts();
      }
      
      // Create prompt for Gemini
      final workoutList = workoutService.workouts.map((w) => 
        '${w.id}: ${w.name} (${w.type}, ${w.caloriesPerMinute} cal/min) - ${w.description}'
      ).join('\n');
      
      const apiKey = 'AIzaSyDuYQPbD0Nx4jIsEra91KOvEhnYeFt5wW8';
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent');
      
      final prompt = '''Based on the fitness goal "$fitnessGoal", select 3-5 workout IDs from this list that would be most effective:

$workoutList

Respond with only the workout IDs separated by commas (e.g., 1,3,7,9).''';
      
      final response = await http.post(
        url,
        headers: {
          'x-goog-api-key': apiKey,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "contents": [
            {"parts": [{"text": prompt}]}
          ]
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        
        // Parse workout IDs and add them
        final workoutIds = aiResponse.split(',').map((id) => int.tryParse(id.trim())).where((id) => id != null).cast<int>().toList();
        
        for (final id in workoutIds) {
          final workout = workoutService.workouts.firstWhereOrNull((w) => w.id == id);
          if (workout != null && !userWorkoutService.selectedWorkouts.any((w) => w.id == id)) {
            await userWorkoutService.addWorkout(workout);
          }
        }
        
        // Store the goal to prevent redundant calls
        await storage.write(key: 'ai_workouts_goal', value: fitnessGoal);
        
        // Refresh the user workouts to update UI
        await userWorkoutService.fetchUserWorkouts();
        
        print('AI workouts generated: $workoutIds');
        
        // Show success notification
        Get.snackbar(
          'AI Recommendations Ready!',
          '${workoutIds.length} personalized workouts added to your collection',
          backgroundColor: const Color(0xFF6C63FF).withOpacity(0.8),
          colorText: Colors.white,
          icon: const Icon(Icons.smart_toy, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Error generating AI workouts: $e');
    } finally {
      isGenerating.value = false;
    }
  }
}
