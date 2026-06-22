import 'package:flutter/material.dart';

import '../../../../../services/mentor/mentor_service.dart';

import '../../../../../services/storage/storage_service.dart';
import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class MentorProfileScreen extends StatefulWidget {
  const MentorProfileScreen({super.key});

  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  String name = "";
  String phone = "";
  String role = "";
  String email = "";
  String district = "";
  String specialization = "";
  String verificationStatus = "";

  int totalStudents = 0;
  int totalSessions = 0;
  int totalReports = 0;

  bool isLoading = true;

  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final response = await MentorService.getProfile();

      final profile = response["data"] ?? {};

      if (!mounted) return;

      setState(() {
        name = profile["fullName"] ?? "";

        phone = profile["phone"] ?? "";

        email = profile["email"] ?? "";

        role = profile["role"] ?? "";

        district = profile["district"] ?? "";

        specialization = profile["specialization"] ?? "";

        verificationStatus = profile["verificationStatus"] ?? "";

        totalStudents = profile["totalStudents"] ?? 0;

        totalSessions = profile["totalSessions"] ?? 0;

        totalReports = profile["totalReports"] ?? 0;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> logout() async {
    setState(() {
      isLoggingOut = true;
    });

    try {
      await StorageService.logout();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/role-selection",
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoggingOut = false;
        });
      }
    }
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(value.isEmpty ? "Not Available" : value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/app_logo2.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mentor Profile",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Manage your profile and mentoring information.",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : "M",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    name.isEmpty ? "Mentor" : name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "$totalStudents",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Students"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$totalSessions",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Sessions"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "$totalReports",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Reports"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            buildTile(icon: Icons.phone, title: "Phone Number", value: phone),

            buildTile(icon: Icons.email, title: "Email", value: email),

            buildTile(icon: Icons.badge, title: "Role", value: role),

            buildTile(
              icon: Icons.location_city,
              title: "District",
              value: district,
            ),

            buildTile(
              icon: Icons.school,
              title: "Specialization",
              value: specialization,
            ),

            buildTile(
              icon: Icons.verified,
              title: "Verification Status",
              value: verificationStatus,
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isLoggingOut ? null : logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  isLoggingOut ? "Logging out..." : "Logout",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
