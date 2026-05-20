
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

import 'features/student/presentation/screens/student_dashboard_screen.dart';
import 'features/mentor/presentation/screens/mentor_dashboard_screen.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/super_admin/presentation/screens/main/super_admin_dashboard_screen.dart';
//import 'features/auth/presentation/screens/auth_test_screen.dart';
void main() {
  runApp(const Super500App());
}

class Super500App extends StatelessWidget {
  const Super500App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Super 500',

          theme: AppTheme.lightTheme,

          home: const SplashScreen(),
         // home: const AuthTestScreen(),

          routes: {
            '/student-dashboard': (_) =>
                const StudentDashboardScreen(),

            '/mentor-dashboard': (_) =>
                const MentorDashboardScreen(),

            '/admin-dashboard': (_) =>
                const AdminDashboardScreen(),

            '/super-admin-dashboard': (_) =>
                const SuperAdminDashboardScreen(),
          },
        );
      },
    );
  }
}