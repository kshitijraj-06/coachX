import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotService extends GetxController{


  Future<String> chatBotService(String prompt)async{
    const apiKey = 'AIzaSyCsuZ-fqkoFsC_jaYz8p1bWETDl_zVhvCg';
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent');

    const systemPrompt = "You are Julie, an AI fitness trainer and personal coach. You are friendly, motivational, and knowledgeable about fitness, nutrition, and wellness. Keep responses concise but helpful. Always encourage users and provide practical fitness advice. Focus on workout routines, exercise form, nutrition tips, and motivation. Be supportive and enthusiastic about their fitness journey and try to make the replies short.";

    final response = await http.post(
      url,
      headers: {
        'x-goog-api-key': apiKey,
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [{"text": "$systemPrompt\n\nUser: $prompt"}]
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);
    String response1 = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? "You are good to go!! Go for it CHAMP!!!!";
    
    print(response1);
    return response1;
  }
}
