import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/user_profile_service.dart';

class FitnessGoalsPage extends StatelessWidget {
  const FitnessGoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileService userProfile = Get.find();
    
    final goals = [
      {'name': 'Weight Loss', 'icon': Icons.trending_down, 'description': 'Burn calories and lose weight'},
      {'name': 'Muscle Gain', 'icon': Icons.fitness_center, 'description': 'Build muscle mass and strength'},
      {'name': 'Strength Training', 'icon': Icons.sports_gymnastics, 'description': 'Increase overall strength'},
      {'name': 'Endurance', 'icon': Icons.directions_run, 'description': 'Improve cardiovascular fitness'},
      {'name': 'General Fitness', 'icon': Icons.favorite, 'description': 'Overall health and wellness'},
    ];

    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: theme.colorScheme.surface,
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
                      'Fitness Goals',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Goals List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return Obx(() => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: userProfile.fitnessGoal.value == goal['name']
                              ? const Color(0xFF6C63FF)
                              : Colors.white.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            goal['icon'] as IconData,
                            color: const Color(0xFF6C63FF),
                            size: 24,
                          ),
                        ),
                        title: Text(
                          goal['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          goal['description'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        trailing: userProfile.fitnessGoal.value == goal['name']
                            ? const Icon(Icons.check_circle, color: Color(0xFF6C63FF))
                            : null,
                        onTap: () async {
                          await userProfile.updateFitnessGoal(goal['name'] as String);
                          Get.snackbar(
                            'Goal Updated',
                            'Your fitness goal has been updated to ${goal['name']}',
                            backgroundColor: const Color(0xFF6C63FF).withOpacity(0.8),
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
