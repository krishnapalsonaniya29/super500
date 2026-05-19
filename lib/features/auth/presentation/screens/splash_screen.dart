// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../../../theme/app_colors.dart';
// import 'role_selection_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Timer(const Duration(seconds: 3), () {
//       if (!mounted) return;
    
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const RoleSelectionScreen(),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primary,

//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               height: 140,
//               width: 140,
//               padding: const EdgeInsets.all(16),

//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(32),
//               ),

//               child: Image.asset(
//                 'assets/images/app_logo.png',
//                 fit: BoxFit.contain,
//               ),
//             ),

//             const SizedBox(height: 28),

//             const Text(
//               'Super 500',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 34,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1,
//               ),
//             ),

//             const SizedBox(height: 10),

//             const Text(
//               'Scholarship & Mentorship Platform',
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

import '../../../../theme/app_colors.dart';


import '../../../student/presentation/screens/student_dashboard_screen.dart';

import 'role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    try {
      final token =
          await AuthService.getToken();

      if (token == null) {
        navigateToRoleSelection();
        return;
      }

      final response =
          await AuthService.getMe();

      final user = response["data"];

      final role = user["role"];

      if (!mounted) return;

      if (role == "STUDENT") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const StudentDashboardScreen(),
          ),
        );

        return;
      }

      navigateToRoleSelection();
    } catch (e) {
      navigateToRoleSelection();
    }
  }

  void navigateToRoleSelection() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const RoleSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              height: 140,
              width: 140,
              padding:
                  const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(32),
              ),

              child: Image.asset(
                'assets/images/app_logo.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Super 500',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Scholarship & Mentorship Platform',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}