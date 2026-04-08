import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/envVars.dart';

class WorkoutTrackerService extends GetxController {
  final storage = FlutterSecureStorage();
  final RxInt totalCalories = 0.obs;
  final RxInt workoutTime = 0.obs;
  final RxInt weeklyGoal = 0.obs;
  final RxInt streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
    fetchBackendStats();
  }

  Future<void> loadStats() async {
    try {
      totalCalories.value = int.parse(await storage.read(key: 'total_calories') ?? '0');
      workoutTime.value = int.parse(await storage.read(key: 'workout_time') ?? '0');
      weeklyGoal.value = int.parse(await storage.read(key: 'weekly_goal') ?? '0');
      streak.value = int.parse(await storage.read(key: 'streak') ?? '0');
    } catch (e) {
      print('Error loading stats: $e');
    }
  }

  Future<void> addWorkoutSession(int calories, int minutes) async {
    totalCalories.value += calories;
    workoutTime.value += minutes;
    weeklyGoal.value += 1;
    
    await storage.write(key: 'total_calories', value: totalCalories.value.toString());
    await storage.write(key: 'workout_time', value: workoutTime.value.toString());
    await storage.write(key: 'weekly_goal', value: weeklyGoal.value.toString());
  }

  Future<void> updateStreak(int newStreak) async {
    streak.value = newStreak;
    await storage.write(key: 'streak', value: streak.value.toString());
  }

  Future<void> resetWeeklyGoal() async {
    weeklyGoal.value = 0;
    await storage.write(key: 'weekly_goal', value: '0');
  }

  Future<void> fetchBackendStats() async {
    try {
      final token = await storage.read(key: 'token');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.serviceApi}/api/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        totalCalories.value = data['totalCalories'] ?? totalCalories.value;
        workoutTime.value = data['workoutTime'] ?? workoutTime.value;
        weeklyGoal.value = data['weeklyGoal'] ?? weeklyGoal.value;
        streak.value = data['streak'] ?? streak.value;
        
        // Update local storage with backend data
        await storage.write(key: 'total_calories', value: totalCalories.value.toString());
        await storage.write(key: 'workout_time', value: workoutTime.value.toString());
        await storage.write(key: 'weekly_goal', value: weeklyGoal.value.toString());
        await storage.write(key: 'streak', value: streak.value.toString());
      }
    } catch (e) {
      print('Error fetching backend stats: $e');
    }
  }
}
