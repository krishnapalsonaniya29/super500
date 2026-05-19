import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

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
                'Sessions',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: ListView(
                  children: [
                    _buildSessionCard(
                      title: 'Physics Mentorship',
                      mentor: 'Dr. Sharma',
                      time: 'Today • 6:00 PM',
                    ),

                    const SizedBox(height: 18),

                    _buildSessionCard(
                      title: 'Mathematics Strategy',
                      mentor: 'Prof. Verma',
                      time: 'Tomorrow • 4:00 PM',
                    ),

                    const SizedBox(height: 18),

                    _buildSessionCard(
                      title: 'Chemistry Revision',
                      mentor: 'Dr. Singh',
                      time: 'Friday • 5:30 PM',
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

  Widget _buildSessionCard({
    required String title,
    required String mentor,
    required String time,
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

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(
              Icons.video_camera_front_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  mentor,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Text(
              'Join',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}