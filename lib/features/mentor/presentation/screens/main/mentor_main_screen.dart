import 'package:flutter/material.dart';

import '../../../../../../theme/app_colors.dart';

import '../home/mentor_home_screen.dart';
import '../students/mentor_students_screen.dart';
import '../sessions/mentor_sessions_screen.dart';
import '../reports/mentor_reports_screen.dart';
import '../profile/mentor_profile_screen.dart';

class MentorMainScreen
    extends StatefulWidget {
  const MentorMainScreen({
    super.key,
  });

  @override
  State<MentorMainScreen>
      createState() =>
          _MentorMainScreenState();
}

class _MentorMainScreenState
    extends State<MentorMainScreen> {
  int currentIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = const [
      MentorHomeScreen(),

      MentorStudentsScreen(),

      MentorSessionsScreen(),

      MentorReportsScreen(),

      MentorProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        backgroundColor:
            AppColors.primary,

        selectedItemColor:
            AppColors.gold,

        unselectedItemColor:
            Colors.white70,

        selectedLabelStyle:
            const TextStyle(
          fontWeight:
              FontWeight.w600,
        ),

        type:
            BottomNavigationBarType.fixed,

        elevation: 10,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Students",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Sessions",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Reports",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}