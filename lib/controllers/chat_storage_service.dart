import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorageService {
  static const String _chatKey = 'user_chats';
  
  static Future<void> saveChat(String username, List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final allChats = await getAllChats();
    allChats[username] = messages;
    await prefs.setString(_chatKey, jsonEncode(allChats));
  }
  
  static Future<List<Map<String, dynamic>>> loadChat(String username) async {
    final allChats = await getAllChats();
    final userChat = allChats[username];
    if (userChat != null) {
      return List<Map<String, dynamic>>.from(userChat);
    }
    return [];
  }
  
  static Future<Map<String, dynamic>> getAllChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatData = prefs.getString(_chatKey);
    if (chatData != null) {
      return Map<String, dynamic>.from(jsonDecode(chatData));
    }
    return {};
  }

  static Future<void> clearChat(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final allChats = await getAllChats();
    if (allChats.containsKey(username)) {
      allChats.remove(username);
      await prefs.setString(_chatKey, jsonEncode(allChats));
    }
  }
}
