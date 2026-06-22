import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

// import './student_home_screen.dart';
import './sessions_screen.dart';
import './achievements_screen.dart';
import './expenses_screen.dart';
import './student_profile_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      // HomeScreen(onNavigate: changeTab),
      SessionsScreen(onNavigate: changeTab),

      AchievementsScreen(onNavigate: changeTab),

      ExpensesScreen(onNavigate: changeTab),

      ProfileScreen(onNavigate: changeTab),
    ];
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(index: currentIndex, children: screens),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),

          gradient: const LinearGradient(
            colors: [Color(0xFF319699), Color(0xFF319699)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),

          child: BottomNavigationBar(
            currentIndex: currentIndex,

            onTap: changeTab,

            type: BottomNavigationBarType.fixed,

            backgroundColor: Colors.transparent,
            elevation: 0,

            selectedItemColor: const Color.fromARGB(255, 255, 196, 0),
            unselectedItemColor: Colors.white70,

            selectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),

            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
            ),

            items: [
              _buildNavItem(
                icon: Icons.calendar_month_rounded,
                label: 'Sessions',
              ),

              _buildNavItem(
                icon: Icons.emoji_events_rounded,
                label: 'Achievements',
              ),

              _buildNavItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Expenses',
              ),

              _buildNavItem(icon: Icons.person_rounded, label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(icon, size: 26),
      ),
      label: label,
    );
  }
}
