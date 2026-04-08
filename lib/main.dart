import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/dashboard_service.dart';
import 'controllers/recommendation_service.dart';
import 'controllers/theme_controller.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/personal_info_page.dart';
import 'screens/ai_trainer/chat_page.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final authController = Get.put(AuthController());
  await authController.checkLoginStatus();

  runApp(const GymPagluApp());
}

class GymPagluApp extends StatelessWidget {
  const GymPagluApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) {
        return GetBuilder<AuthController>(
          init: AuthController(),
          builder: (authController) {
            return GetMaterialApp(
              title: 'AI Gym Trainer',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode,
              initialRoute: authController.isLoggedIn.value ? '/home' : '/login',
              getPages: [
                GetPage(name: '/login', page: () => const LoginScreen()),
                GetPage(name: '/signup', page: () => const SignupScreen()),
                GetPage(name: '/home', page: () => const HomeScreen()),
                GetPage(name: '/personal-info', page: () => const PersonalInfoPage()),
                GetPage(name: '/chat', page: () => const ChatPage()),
              ],
              initialBinding: BindingsBuilder(() {
                Get.put(AuthController());
                Get.put(ThemeController());
                Get.put(RecommendationService());
                Get.put(DashboardService());
              }),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
