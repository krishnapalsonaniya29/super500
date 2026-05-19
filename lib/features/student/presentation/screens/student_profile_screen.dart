import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../theme/app_colors.dart';

//import '../../../../auth/presentation/screens/role_selection_screen.dart';

class ProfileScreen extends StatelessWidget {
  final Function(int)? onNavigate;

  const ProfileScreen({
    super.key,
    this.onNavigate,
  });

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("accessToken");

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const RoleSelectionScreen(),
      ),
      (route) => false,
    );
  }

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
                      color: Colors.black.withOpacity(0.08),
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

              GestureDetector(
                onTap: () => logout(context),

                child: _buildProfileTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  isLogout: true,
                ),
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
            color: Colors.black.withOpacity(0.05),
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
                  ? Colors.red.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),

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