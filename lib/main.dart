
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'theme/app_theme.dart';
// import 'features/auth/presentation/screens/splash_screen.dart';

// import 'features/student/presentation/screens/student_dashboard_screen.dart';
// import 'features/mentor/presentation/screens/mentor_dashboard_screen.dart';
// import 'features/admin/presentation/screens/main/admin_main_screen.dart';
// import 'features/super_admin/presentation/screens/main/super_admin_dashboard_screen.dart';
// //import 'features/auth/presentation/screens/auth_test_screen.dart';
// void main() {
//   runApp(const Super500App());
// }

// class Super500App extends StatelessWidget {
//   const Super500App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(390, 844),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,

//           title: 'Super 500',

//           theme: AppTheme.lightTheme,

//           home: const SplashScreen(),
//          // home: const AuthTestScreen(),

//           routes: {
//             '/student-dashboard': (_) =>
//                 const StudentDashboardScreen(),

//             '/mentor-dashboard': (_) =>
//                 const MentorDashboardScreen(),

//             '/admin-dashboard': (_) =>
//                 const AdminMainScreen(),

//             '/super-admin-dashboard': (_) =>
//                 const SuperAdminDashboardScreen(),
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme/app_theme.dart';

/// AUTH
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/role_selection_screen.dart';

import 'features/auth/presentation/screens/student_login_screen.dart';
import 'features/auth/presentation/screens/student_register_screen.dart';

import 'features/auth/presentation/screens/mentor_login_screen.dart';
import 'features/auth/presentation/screens/mentor_register_screen.dart';

import 'features/auth/presentation/screens/admin_login_screen.dart';

import 'features/auth/presentation/screens/super_admin_login_screen.dart';

import 'features/auth/presentation/screens/otp_verification_screen.dart';

/// STUDENT
import 'features/student/presentation/screens/student_dashboard_screen.dart';

/// MENTOR
import 'features/mentor/presentation/screens/main/mentor_main_screen.dart';

/// ADMIN
import 'features/admin/presentation/screens/main/admin_main_screen.dart';

/// SUPER ADMIN
import 'features/super_admin/presentation/screens/main/super_admin_dashboard_screen.dart';

void main() {
  runApp(const Super500App());
}

class Super500App
    extends StatelessWidget {
  const Super500App({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ScreenUtilInit(
      designSize:
          const Size(390, 844),

      minTextAdapt: true,

      splitScreenMode: true,

      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner:
              false,

          title: 'Super 500',

          theme:
              AppTheme.lightTheme,

          initialRoute: '/',

          routes: {
            /// SPLASH
            '/': (_) =>
                const SplashScreen(),

            /// ROLE SELECTION
            '/role-selection': (_) =>
                const RoleSelectionScreen(),

            /// STUDENT
            '/student-login': (_) =>
                const StudentLoginScreen(),

            '/student-register': (_) =>
                const StudentRegisterScreen(),

            '/student-dashboard': (_) =>
                const StudentDashboardScreen(),

            /// MENTOR
            '/mentor-login': (_) =>
                const MentorLoginScreen(),

            '/mentor-register': (_) =>
                const MentorRegisterScreen(),

            '/mentor-dashboard': (_) =>
                const MentorMainScreen(),

            /// ADMIN
            '/admin-login': (_) =>
                const AdminLoginScreen(),

            '/admin-dashboard': (_) =>
                const AdminMainScreen(),

            /// SUPER ADMIN
            '/super-admin-login': (_) =>
                const SuperAdminLoginScreen(),

            '/super-admin-dashboard':
                (_) =>
                    const SuperAdminDashboardScreen(),

            /// OTP SCREEN
            '/otp-verification':
                (context) {
              final args =
                  ModalRoute.of(
                    context,
                  )!
                      .settings
                      .arguments
                  as Map;

              return OtpVerificationScreen(
                phoneNumber:
                    args["phone"],
              );
            },
          },
        );
      },
    );
  }
}