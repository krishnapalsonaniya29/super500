// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'theme/app_theme.dart';
// import 'features/auth/presentation/screens/splash_screen.dart';
// import 'features/student/presentation/screens/student_dashboard_screen.dart';

// import 'features/mentor/presentation/screens/mentor_dashboard_screen.dart';

// import 'features/admin/presentation/screens/admin_dashboard_screen.dart';

// import 'features/super_admin/presentation/screens/super_admin_dashboard_screen.dart';


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
//   debugShowCheckedModeBanner: false,

//   title: 'Super 500',

//   theme: AppTheme.lightTheme,

//   home: const SplashScreen(),

//   routes: {
//     '/student-dashboard': (_) =>
//         const StudentDashboardScreen(),

//     '/mentor-dashboard': (_) =>
//         const MentorDashboardScreen(),

//     '/admin-dashboard': (_) =>
//         const AdminDashboardScreen(),

//     '/super-admin-dashboard': (_) =>
//         const SuperAdminDashboardScreen(),
//   },
// );
//       },
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Super 500'),
//       ),
//       body: Center(
//         child: Text(
//           'Super 500 Scholarship Platform',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//       ),
//     );
//   }
// }


// // import 'package:dio/dio.dart';
// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: ApiTestScreen(),
// //     );
// //   }
// // }

// // class ApiTestScreen extends StatefulWidget {
// //   const ApiTestScreen({super.key});

// //   @override
// //   State<ApiTestScreen> createState() => _ApiTestScreenState();
// // }

// // class _ApiTestScreenState extends State<ApiTestScreen> {
// //   String result = "Loading...";

// //   @override
// //   void initState() {
// //     super.initState();
// //     testApi();
// //   }

// //   Future<void> testApi() async {
// //     try {
// //       final response = await Dio().get(
// //         "https://unspeedy-nickie-oratorically.ngrok-free.dev/api/v1/health",
// //       );

// //       setState(() {
// //         result = response.data.toString();
// //       });
// //     } catch (e) {
// //       setState(() {
// //         result = e.toString();
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("API Test"),
// //       ),
// //       body: Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20),
// //           child: Text(
// //             result,
// //             style: const TextStyle(fontSize: 18),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

import 'features/student/presentation/screens/student_dashboard_screen.dart';
import 'features/mentor/presentation/screens/mentor_dashboard_screen.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/super_admin/presentation/screens/super_admin_dashboard_screen.dart';
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