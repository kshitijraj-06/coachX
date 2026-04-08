import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/exercise_db_service.dart';
import 'exercise_detail_page.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final ExerciseDbService exerciseService = Get.put(ExerciseDbService());
  final TextEditingController searchController = TextEditingController();
  List<String> equipments = [];
  List<String> muscles = [];
  List<String> bodyParts = [];

  String capitalize(String text) {
    return text.split(' ').map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : ''
    ).join(' ');
  }

  @override
  void initState() {
    super.initState();
    exerciseService.fetchExercises();
    loadFilters();
  }

  void loadFilters() async {
    equipments = await exerciseService.getEquipments();
    muscles = await exerciseService.getMuscles();
    bodyParts = await exerciseService.getBodyParts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F0F23), Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Exercises',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  style: GoogleFonts.inter(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search exercises...',
                    hintStyle: GoogleFonts.inter(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onSubmitted: (value) {
                    if (value.isEmpty) {
                      exerciseService.fetchExercises();
                    } else {
                      exerciseService.searchExercises(value);
                    }
                  },
                ),
              ),
            ),
            // Exercises List
            Expanded(
              child: Obx(() {
                if (exerciseService.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: exerciseService.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exerciseService.exercises[index];
                    return GestureDetector(
                      onTap: () => Get.to(() => ExerciseDetailPage(exercise: exercise)),
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Row(
                        children: [
                          // Exercise Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              exercise['gifUrl'] ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: const Color(0xFF6C63FF).withOpacity(0.3),
                                child: const Icon(Icons.fitness_center, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Exercise Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise['name'] ?? 'Unknown Exercise',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Target: ${capitalize(exercise['targetMuscles']?.join(', ') ?? 'N/A')}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                Text(
                                  'Equipment: ${capitalize(exercise['equipments']?.join(', ') ?? 'N/A')}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                            );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
