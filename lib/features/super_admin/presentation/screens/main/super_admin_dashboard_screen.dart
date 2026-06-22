import 'package:flutter/material.dart';

import '../../../../../services/auth/auth_service.dart';

import '../home/super_admin_home_screen.dart';
import '../students/students_screen.dart';
import '../mentors/mentors_screen.dart';
import '../admins/admins_screen.dart';
import '../profile/super_admin_profile_screen.dart';

import '../../../../../theme/app_colors.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  int currentIndex = 0;

  bool loading = true;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      const SuperAdminHomeScreen(),

      StudentsScreen(onNavigate: changeTab),

      MentorsScreen(onNavigate: changeTab),

      AdminsScreen(onNavigate: changeTab),

      SuperAdminProfileScreen(onNavigate: changeTab),
    ];

    validateSuperAdmin();
  }

  /// =====================================
  /// VALIDATE SUPER ADMIN
  /// =====================================

  Future<void> validateSuperAdmin() async {
    try {
      final role = await AuthService.getCurrentUserRole();

      if (role != "SUPER_ADMIN") {
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

        return;
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  /// =====================================
  /// CHANGE TAB
  /// =====================================

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: changeTab,

        backgroundColor: Colors.white,

        indicatorColor: AppColors.primary.withValues(alpha: 0.12),

        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: "Home"),

          NavigationDestination(
            icon: Icon(Icons.school_rounded),

            label: "Students",
          ),

          NavigationDestination(
            icon: Icon(Icons.groups_rounded),

            label: "Mentors",
          ),

          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_rounded),

            label: "Admins",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_rounded),

            label: "Profile",
          ),
        ],
      ),
    );
  }
}
