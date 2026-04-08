import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/workoutsService.dart';
import '../../controllers/user_workout_service.dart';

class AddWorkoutPage extends StatelessWidget {
  final WorkoutService1 workoutService = Get.put(WorkoutService1());
  final UserWorkoutService userWorkoutService = Get.find();

  AddWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Add Workout',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: Obx(() {
          if (workoutService.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: workoutService.workouts.length,
            itemBuilder: (context, index) {
              final workout = workoutService.workouts[index];

              return Obx(() {
                final isSelected = userWorkoutService.selectedWorkouts
                    .any((w) => w.id == workout.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF6C63FF)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForType(workout.type),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.name,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            workout.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            '${workout.caloriesPerMinute.toInt()} cal/min â€¢ ${workout.type}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isSelected) {
                          await userWorkoutService.removeWorkout(workout.id);
                        } else {
                          await userWorkoutService.addWorkout(workout);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF6C63FF)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Obx(() {
                          final isLoading = userWorkoutService.workoutLoadingStates[workout.id] ?? false;
                          final currentSelected = userWorkoutService.selectedWorkouts.any((w) => w.id == workout.id);
                          
                          return isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  currentSelected ? Icons.check : Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                );
                        }),
                      ),
                    ),
                  ],
                ));
              });
            });
        }),
      )
  );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'CARDIO': return Icons.directions_run;
      case 'STRENGTH': return Icons.fitness_center;
      case 'FLEXIBILITY': return Icons.self_improvement;
      case 'SPORTS': return Icons.sports_basketball;
      default: return Icons.fitness_center;
    }
  }
}
