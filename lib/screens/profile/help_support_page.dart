import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqItems = [
      {'question': 'How do I track my workouts?', 'answer': 'Go to the Workouts tab and select a workout to start tracking your exercises and progress.'},
      {'question': 'How does the AI trainer work?', 'answer': 'Julie, our AI trainer, analyzes your workout history and provides personalized recommendations based on your fitness goals.'},
      {'question': 'Can I change my fitness goal?', 'answer': 'Yes, you can update your fitness goal anytime in Profile > Fitness Goals.'},
      {'question': 'How are calories calculated?', 'answer': 'We use a hybrid system combining MET values, heart rate data, and AI analysis for accurate calorie calculations.'},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Help & Support',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    // Contact Options
                    _buildContactOption(
                      'Chat with Support',
                      'Get instant help from our support team',
                      Icons.chat_bubble_outline,
                      () => Get.snackbar('Support', 'Opening chat support...'),
                    ),
                    _buildContactOption(
                      'Email Support',
                      'Send us an email for detailed assistance',
                      Icons.email_outlined,
                      () => Get.snackbar('Email', 'Opening email client...'),
                    ),
                    _buildContactOption(
                      'Call Support',
                      'Speak directly with our support team',
                      Icons.phone_outlined,
                      () => Get.snackbar('Call', 'Calling support: +1-800-GYM-HELP'),
                    ),
                    const SizedBox(height: 30),
                    // FAQ Section
                    Text(
                      'Frequently Asked Questions',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...faqItems.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 24),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400])),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: Text(question, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        iconColor: const Color(0xFF6C63FF),
        collapsedIconColor: Colors.grey[400],
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[300])),
          ),
        ],
      ),
    );
  }
}
