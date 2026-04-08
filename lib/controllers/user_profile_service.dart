import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../core/envVars.dart';
import 'chat_storage_service.dart';
import 'package:http/http.dart' as http;
import 'ai_workout_recommendation_service.dart';
import 'user_workout_service.dart';

class UserProfileService extends GetxController {
  var fitnessGoal = 'General Fitness'.obs;
  var name = 'Gym Enthusiast'.obs;
  var email = 'user@gympaglu.com'.obs;
  var phone = '1234567890'.obs;
  var gender = 'Male'.obs;
  var age = '25'.obs;
  var height = '180'.obs;
  var weight = '75'.obs;
  var isLoading = false.obs;
  final storage = const FlutterSecureStorage();
  
  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> fetchUserProfile() async{
    final idtoken = await storage.read(key: 'token');
    isLoading.value = true;
    try{
      final response = await http.get(
          Uri.parse('${ApiConfig.serviceApi}/api/profile'),
        headers: {
          'Authorization': 'Bearer $idtoken'
        }
      );
      if(response.statusCode == 200){
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        
        name.value = data['fullName'] ?? 'Gym Enthusiast';
        email.value = data['email'] ?? 'user@gympaglu.com';
        phone.value = data['phone'] ?? '1234567890';
        gender.value = data['gender'] ?? 'Male';
        age.value = data['age']?.toString() ?? '25';
        height.value = data['height']?.toString() ?? '175';
        weight.value = data['weight']?.toString() ?? '70';
        fitnessGoal.value = data['fitnessGoal'] ?? 'General Fitness';
        isLoading.value = false;
      }else{
        print("error: ${response.statusCode}");
        isLoading.value = false;
      }
    }catch(e){}
  }
  
  Future<void> loadUserProfile() async {
    try {
      final profile = await ChatStorageService.loadChat('user_profile');
      if (profile.isNotEmpty) {
        fitnessGoal.value = profile.first['fitnessGoal'] ?? 'General Fitness';
      }
    } catch (e) {
      fitnessGoal.value = 'General Fitness';
    }
  }
  
  Future<void> updateFitnessGoal(String goal) async {
    try {
      final token = await storage.read(key: 'token');
      
      final response = await http.put(
        Uri.parse('${ApiConfig.serviceApi}/api/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'fitnessGoal': goal}),
      );

      if (response.statusCode == 200) {
        fitnessGoal.value = goal;
        await ChatStorageService.saveChat('user_profile', [{'fitnessGoal': goal}]);
        
        // Clear existing workouts and generate new ones
        final userWorkoutService = Get.find<UserWorkoutService>();
        await userWorkoutService.clearAllWorkouts();
        
        final aiService = Get.put(AIWorkoutRecommendationService());
        await storage.delete(key: 'ai_workouts_goal'); // Reset AI generation flag
        await aiService.generateWorkoutsForUser(goal);
      }
    } catch (e) {
      print('Error updating fitness goal: $e');
    }
  }
}
