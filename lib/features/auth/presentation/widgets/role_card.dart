import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

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
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.15),

              child: Icon(icon, size: 30, color: AppColors.secondary),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
