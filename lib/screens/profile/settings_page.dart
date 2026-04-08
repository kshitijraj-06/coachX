import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../controllers/theme_controller.dart';
import '../../controllers/user_workout_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String units = 'Metric';
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: theme.colorScheme.background,
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
                      icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    Obx(() => _buildSwitchTile(
                          'Dark Mode',
                          'Use dark theme throughout the app',
                          Icons.dark_mode,
                          themeController.themeMode == ThemeMode.dark,
                          (value) => themeController.toggleTheme(value),
                        )),
                    _buildDropdownTile(
                      'Units',
                      'Choose measurement units',
                      Icons.straighten,
                      units,
                      ['Metric', 'Imperial'],
                      (value) => setState(() => units = value!),
                    ),
                    _buildDropdownTile(
                      'Language',
                      'Select app language',
                      Icons.language,
                      language,
                      ['English', 'Spanish', 'French'],
                      (value) => setState(() => language = value!),
                    ),
                    _buildActionTile(
                      'Clear Cache',
                      'Free up storage space',
                      Icons.cleaning_services,
                      () => _showClearCacheDialog(),
                    ),
                    _buildActionTile(
                      'Export Data',
                      'Download your fitness data',
                      Icons.download,
                      () => _showExportDataDialog(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: theme.colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, IconData icon, String value,
      List<String> items, ValueChanged<String?> onChanged) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: theme.colorScheme.surface,
            style: GoogleFonts.inter(color: theme.colorScheme.onSurface),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        title: Text(title,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7))),
        trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.onSurface, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showClearCacheDialog() {
    final theme = Theme.of(context);
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Clear Cache', style: GoogleFonts.poppins(color: theme.colorScheme.onSurface)),
        content: Text('This will clear all cached data. Continue?',
            style: GoogleFonts.inter(color: theme.colorScheme.onSurface.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final tempDir = await getTemporaryDirectory();
              if (tempDir.existsSync()) {
                tempDir.deleteSync(recursive: true);
              }
              Get.find<UserWorkoutService>().clearAndRefetchWorkouts();
              Get.snackbar('Cache Cleared', 'All cached data has been removed');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog() {
    final theme = Theme.of(context);
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Export Data', style: GoogleFonts.poppins(color: theme.colorScheme.onSurface)),
        content: Text('This will export your fitness data as a CSV file. Continue?',
            style: GoogleFonts.inter(color: theme.colorScheme.onSurface.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportData();
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _exportData() async {
    final UserWorkoutService userWorkoutService = Get.find();
    final workouts = userWorkoutService.selectedWorkouts;

    if (workouts.isEmpty) {
      Get.snackbar('No Data', 'There is no workout data to export.');
      return;
    }

    List<List<dynamic>> rows = [];
    rows.add(['ID', 'Name', 'Calories Per Minute', 'Type', 'Duration (minutes)']);
    for (var workout in workouts) {
      rows.add([workout.id, workout.name, workout.caloriesPerMinute, workout.type]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/workout_data.csv';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'My Workout Data');
  }
}
