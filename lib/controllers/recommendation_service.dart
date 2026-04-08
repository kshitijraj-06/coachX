import 'package:get/get.dart';
import 'ai_chatbot_service.dart';
import 'chat_storage_service.dart';

class RecommendationService extends GetxController {
  final ChatbotService _chatbotService = ChatbotService();
  
  var recommendation = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    generateRecommendation();
  }

  Future<void> generateRecommendation() async {
    isLoading.value = true;
    
    try {
      // Get user's chat history for context
      final chatHistory = await ChatStorageService.loadChat('gym_user');
      
      String contextPrompt = _buildContextPrompt(chatHistory);
      
      final response = await _chatbotService.chatBotService(contextPrompt);
      recommendation.value = _processRecommendationText(response);
      
    } catch (e) {
      recommendation.value = 'Focus on consistency today. A simple 30-minute workout will keep you on track!';
    }
    
    isLoading.value = false;
  }

  String _processRecommendationText(String text) {
    return text
        .replaceAll('&#39;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('**', '')
        .replaceAll('*', 'â€¢')
        .trim();
  }

  String _buildContextPrompt(List<Map<String, dynamic>> chatHistory) {
    String basePrompt = "Based on our previous conversations and typical fitness patterns, give me a brief personalized workout recommendation for today. Keep it under 50 words and motivational.";
    
    if (chatHistory.length > 2) {
      // Get last few user messages for context
      List<String> recentUserMessages = chatHistory
          .where((msg) => msg['isUser'] == true)
          .take(3)
          .map((msg) => msg['text'].toString())
          .toList();
      
      if (recentUserMessages.isNotEmpty) {
        basePrompt = "Based on our recent conversations where you mentioned: ${recentUserMessages.join(', ')}, give me a brief personalized workout recommendation for today. Keep it under 50 words and motivational.";
      }
    }
    
    return basePrompt;
  }
}
