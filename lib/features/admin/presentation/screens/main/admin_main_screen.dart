import 'package:flutter/material.dart';

import '../../../../../services/auth/auth_service.dart';

import '../../../../../theme/app_colors.dart';

import '../home/admin_home_screen.dart';
import '../students/students_screen.dart';
import '../mentors/mentors_screen.dart';
import '../profile/admin_profile_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int currentIndex = 0;

  bool loading = true;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      const AdminHomeScreen(),

      StudentsScreen(onNavigate: changeTab),

      MentorsScreen(onNavigate: changeTab),

      AdminProfileScreen(onNavigate: changeTab),
    ];

    validateAdmin();
  }

  /// =====================================
  /// VALIDATE ADMIN
  /// =====================================

  Future<void> validateAdmin() async {
    try {
      final role = await AuthService.getCurrentUserRole();

      if (role != "ADMIN") {
        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

        return;
      }

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

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

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),

              blurRadius: 20,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: NavigationBar(
          height: 72,

          selectedIndex: currentIndex,

          onDestinationSelected: changeTab,

          backgroundColor: Colors.transparent,

          indicatorColor: AppColors.primary.withValues(alpha: 0.12),

          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),

              selectedIcon: Icon(Icons.home_filled),

              label: "Home",
            ),

            NavigationDestination(
              icon: Icon(Icons.school_outlined),

              selectedIcon: Icon(Icons.school),

              label: "Students",
            ),

            NavigationDestination(
              icon: Icon(Icons.groups_outlined),

              selectedIcon: Icon(Icons.groups),

              label: "Mentors",
            ),

            NavigationDestination(
              icon: Icon(Icons.person_outline),

              selectedIcon: Icon(Icons.person),

              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
