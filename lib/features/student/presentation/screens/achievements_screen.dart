import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, required void Function(int index) onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.95,

                  children: [
                    _buildAchievementCard(
                      title: 'Top Rank',
                      subtitle: 'AIR 12',
                      icon: Icons.emoji_events_rounded,
                    ),

                    _buildAchievementCard(
                      title: 'Attendance',
                      subtitle: '92%',
                      icon: Icons.check_circle_rounded,
                    ),

                    _buildAchievementCard(
                      title: 'Tests Cleared',
                      subtitle: '28',
                      icon: Icons.assignment_turned_in_rounded,
                    ),

                    _buildAchievementCard(
                      title: 'Certificates',
                      subtitle: '14',
                      icon: Icons.workspace_premium_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              size: 34,
              color: const Color(0xFFD4AF37),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Poppins',
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}