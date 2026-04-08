import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseDbService extends GetxController {
  final RxList<Map<String, dynamic>> exercises = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final String baseUrl = 'https://exercis-db-gym-buddy.vercel.app/api/v1';

  Future<void> fetchExercises({String? search, int offset = 0, int limit = 20}) async {
    try {
      isLoading.value = true;
      String endpoint = '$baseUrl/exercises?offset=$offset&limit=$limit';
      
      if (search != null && search.isNotEmpty) {
        endpoint += '&search=$search';
      }
      
      final response = await http.get(Uri.parse(endpoint));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        exercises.value = data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error fetching exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchExercises(String query) async {
    await fetchExercises(search: query);
  }

  Future<List<String>> getEquipments() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/equipments'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((item) => item.toString()).toList();
      }
    } catch (e) {
      print('Error fetching equipments: $e');
    }
    return [];
  }

  Future<List<String>> getMuscles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/muscles'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((item) => item.toString()).toList();
      }
    } catch (e) {
      print('Error fetching muscles: $e');
    }
    return [];
  }

  Future<List<String>> getBodyParts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bodyparts'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        return data.map((item) => item.toString()).toList();
      }
    } catch (e) {
      print('Error fetching body parts: $e');
    }
    return [];
  }
}
