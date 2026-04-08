import 'dart:convert';
import 'dart:typed_data';
import 'package:ai_gym_trainer/core/envVars.dart';
import 'package:http/http.dart' as http;

class PoseAnalyzer {
  // Multiple server URLs to try
  static const List<String> _serverUrls = [
    'https://pose-detection-tu3i.vercel.app',
    'http://10.5.89.22:5000',
    'http://localhost:5000',
  ];
  
  static int _currentServerIndex = 0;
  
  static String get _currentServerUrl => _serverUrls[_currentServerIndex];
  
  static Future<Map<String, dynamic>> analyzePose(Uint8List imageBytes, String exercise) async {
    for (int i = 0; i < _serverUrls.length; i++) {
      try {
        final serverUrl = _serverUrls[(_currentServerIndex + i) % _serverUrls.length];
        final response = await http.post(
          Uri.parse('$serverUrl/analyze'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'image': base64Encode(imageBytes),
            'exercise': exercise,
          }),
        ).timeout(const Duration(seconds: 5));
        
        if (response.statusCode == 200) {
          // Update current server index to the working one
          _currentServerIndex = (_currentServerIndex + i) % _serverUrls.length;
          return jsonDecode(response.body);
        }
      } catch (e) {
        print('Failed to connect to server ${_serverUrls[(_currentServerIndex + i) % _serverUrls.length]}: $e');
        continue;
      }
    }
    
    return {
      'error': 'Unable to connect to pose detection server',
      'pose_detected': false,
    };
  }

  static Future<Map<String, dynamic>> resetCounters() async {
    for (int i = 0; i < _serverUrls.length; i++) {
      try {
        final serverUrl = _serverUrls[(_currentServerIndex + i) % _serverUrls.length];
        final response = await http.post(
          Uri.parse('$serverUrl/reset'),
        ).timeout(const Duration(seconds: 3));
        
        if (response.statusCode == 200) {
          _currentServerIndex = (_currentServerIndex + i) % _serverUrls.length;
          return jsonDecode(response.body);
        }
      } catch (e) {
        print('Failed to reset counters on server ${_serverUrls[(_currentServerIndex + i) % _serverUrls.length]}: $e');
        continue;
      }
    }
    
    return {'error': 'Connection failed', 'success': false};
  }
  
  // Method to manually set server URL
  static void setServerUrl(String url) {
    final index = _serverUrls.indexOf(url);
    if (index != -1) {
      _currentServerIndex = index;
    }
  }
  
  // Method to get current server status
  static Future<Map<String, dynamic>> getServerStatus() async {
    final results = <String, dynamic>{};
    
    for (final url in _serverUrls) {
      try {
        final response = await http.get(
          Uri.parse('$url/'),
        ).timeout(const Duration(seconds: 2));
        
        results[url] = {
          'status': response.statusCode == 200 ? 'online' : 'error',
          'response_time': DateTime.now().millisecondsSinceEpoch,
        };
      } catch (e) {
        results[url] = {
          'status': 'offline',
          'error': e.toString(),
        };
      }
    }
    
    return {
      'servers': results,
      'current_server': _currentServerUrl,
    };
  }
}
