import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                height: 120,
                width: 120,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.person,
                  size: 70,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Kunal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Super 500 Student',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 40),

              _buildProfileTile(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
              ),

              _buildProfileTile(
                icon: Icons.description_outlined,
                title: 'Documents',
              ),

              _buildProfileTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
              ),

              _buildProfileTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
              ),

              _buildProfileTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

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
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: isLogout
                  ? Colors.red.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: isLogout
                  ? Colors.red
                  : AppColors.primary,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: isLogout
                    ? Colors.red
                    : AppColors.textPrimary,
              ),
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}