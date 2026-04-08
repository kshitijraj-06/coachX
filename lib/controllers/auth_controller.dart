import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/envVars.dart';
import 'ai_workout_recommendation_service.dart';
import 'chat_storage_service.dart';
import 'user_profile_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  final storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await storage.read(key: 'token');
    isLoggedIn.value = token != null;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.serviceApi}/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final idToken = jsonDecode(response.body)['token'];
        isLoggedIn.value = true;
        await storage.write(key: 'token', value: idToken);
        
        Get.offAllNamed('/home');
        
        // Generate AI workouts in background
        try {
          final userProfile = Get.put(UserProfileService());
          await userProfile.fetchUserProfile();
          final aiService = Get.put(AIWorkoutRecommendationService());
          await aiService.generateWorkoutsForUser(userProfile.fitnessGoal.value);
        } catch (e) {
          print('Error generating workouts: $e');
        }
      } else {
        print('Login failed: ${response.statusCode}');
        isLoggedIn.value = false;
      }
    } catch (e) {
      print('Error during login: $e');
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String name, String email, String password, String goal) async {
    isLoading.value = true;
    
    try{
      final response = await http.post(
        Uri.parse('${ApiConfig.serviceApi}/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fullName": name,
          "email": email,
          "password": password,
          "fitnessGoal": goal,
        }),
      );
      if (response.statusCode == 200) {
        print('Signup successful');
        final idToken = jsonDecode(response.body)['token'];
        isLoggedIn.value = true;
        await storage.write(key: 'token', value: idToken);
        
        // Generate AI workouts for new user after signup
        final aiService = Get.put(AIWorkoutRecommendationService());
        await aiService.generateWorkoutsForUser(goal);
        
        Get.offAllNamed('/home');
      } else {
        print('Signup failed: ${response.statusCode}');
        isLoggedIn.value = false;
      }
    }catch (e) {
      print('Error during signup: $e');
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false;
    }
    
    isLoggedIn.value = true;
    isLoading.value = false;
  }
  
  Future<void> logout() async {
    // Clear all stored data
    await storage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await ChatStorageService.clearChat('gym_user');

    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
  
  Future<void> google_login(String token) async{
    isLoading.value = true;
    final token = await storage.read(key: 'Googletoken');
    
    try{
      final response = await http.post(
        Uri.parse('${ApiConfig.serviceApi}/api/auth/firebase-login'),
        body: {
          "token" : token
        }
      );

      if(response.statusCode == 200){
        print("Hogya");
      }
    }catch(e){
      print("ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR : $e");
    }
  }
}
