import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/workout.dart';

class WorkoutService1 extends GetxController {
  final storage = FlutterSecureStorage();
  final RxList<Workout> workouts = <Workout>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      isLoading.value = true;
      final token = await storage.read(key: 'token');
      
      final response = await http.get(
        Uri.parse('http://68.233.96.179:8080/api/workouts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        workouts.value = data.map((json) => Workout.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Workout> getWorkoutsByType(String type) {
    return workouts.where((workout) => workout.type == type).toList();
  }

  List<Workout> getCardioWorkouts() => getWorkoutsByType('CARDIO');
  List<Workout> getStrengthWorkouts() => getWorkoutsByType('STRENGTH');
  List<Workout> getFlexibilityWorkouts() => getWorkoutsByType('FLEXIBILITY');
  List<Workout> getSportsWorkouts() => getWorkoutsByType('SPORTS');
}
