import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/envVars.dart';
import '../models/workout.dart';

class UserWorkoutService extends GetxController {
  final storage = FlutterSecureStorage();
  final RxList<Workout> selectedWorkouts = <Workout>[].obs;
  final RxBool isLoading = false.obs;
  final RxMap<int, bool> workoutLoadingStates = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserWorkouts();
  }

  Future<void> fetchUserWorkouts() async {
    try {
      isLoading.value = true;
      final token = await storage.read(key: 'token');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.serviceApi}/api/workouts/my-workouts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          selectedWorkouts.value = [];
          return;
        }
        
        final dynamic decodedData = json.decode(responseBody);
        
        if (decodedData is List) {
          final List<dynamic> data = decodedData;
          selectedWorkouts.value = data.where((json) => json != null)
              .map((json) {
            Map<String, dynamic> workoutData = Map<String, dynamic>.from(json);
            return Workout.fromJson(workoutData);
          }).toList();
        } else {
          selectedWorkouts.value = [];
        }
      } else {
        selectedWorkouts.value = [];
      }
    } catch (e) {
      print('Error fetching user workouts: $e');
      selectedWorkouts.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      workoutLoadingStates[workout.id] = true;
      final token = await storage.read(key: 'token');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.serviceApi}/api/workouts/my-workouts/${workout.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        selectedWorkouts.add(workout);
      }
    } catch (e) {
      print('Error adding workout: $e');
    } finally {
      workoutLoadingStates.remove(workout.id);
    }
  }

  Future<void> removeWorkout(int workoutId) async {
    try {
      workoutLoadingStates[workoutId] = true;
      final token = await storage.read(key: 'token');
      
      final response = await http.delete(
        Uri.parse('${ApiConfig.serviceApi}/api/workouts/my-workouts/$workoutId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        selectedWorkouts.removeWhere((w) => w.id == workoutId);
      }
    } catch (e) {
      print('Error removing workout: $e');
    } finally {
      workoutLoadingStates.remove(workoutId);
    }
  }

  Future<void> clearAndRefetchWorkouts() async {
    selectedWorkouts.clear();
    await fetchUserWorkouts();
  }

  Future<void> clearAllWorkouts() async {
    try {
      final token = await storage.read(key: 'token');
      
      final response = await http.delete(
        Uri.parse('${ApiConfig.serviceApi}/api/workouts/my-workouts/clear'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        selectedWorkouts.clear();
      }
    } catch (e) {
      print('Error clearing workouts: $e');
    }
  }
}
