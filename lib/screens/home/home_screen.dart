import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dashboard/dashboard_page.dart';
import '../workouts/workouts_page.dart';
import '../ai_trainer/ai_trainer_page.dart';
import '../profile/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static  final List<Widget> _pages = <Widget>[
    DashboardPage(),
    WorkoutsPage(),
    Container(),
    AITrainerPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      final url = Uri.parse('https://pose-detection-tu3i.vercel.app');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF6C63FF).withOpacity(0.2),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: _selectedIndex == 0 ? const Color(0xFF6C63FF) : Colors.grey[400],
              ),
              selectedIcon: const Icon(
                Icons.home,
                color: Color(0xFF6C63FF),
              ),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.fitness_center_outlined,
                color: _selectedIndex == 1 ? const Color(0xFF6C63FF) : Colors.grey[400],
              ),
              selectedIcon: const Icon(
                Icons.fitness_center,
                color: Color(0xFF6C63FF),
              ),
              label: 'Workouts',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.accessibility_new_outlined,
                color: _selectedIndex == 2 ? const Color(0xFF6C63FF) : Colors.grey[400],
              ),
              selectedIcon: const Icon(
                Icons.accessibility_new,
                color: Color(0xFF6C63FF),
              ),
              label: 'Pose',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.psychology_outlined,
                color: _selectedIndex == 3 ? const Color(0xFF6C63FF) : Colors.grey[400],
              ),
              selectedIcon: const Icon(
                Icons.psychology,
                color: Color(0xFF6C63FF),
              ),
              label: 'AI Trainer',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: _selectedIndex == 4 ? const Color(0xFF6C63FF) : Colors.grey[400],
              ),
              selectedIcon: const Icon(
                Icons.person,
                color: Color(0xFF6C63FF),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
