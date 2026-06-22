import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../services/auth/auth_service.dart';
import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

class AdminProfileScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const AdminProfileScreen({super.key, required this.onNavigate});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool loading = true;

  String? errorMessage;

  Map<String, dynamic>? user;

  Map<String, dynamic>? stats;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  /// =====================================
  /// LOAD DATA
  /// =====================================

  Future<void> loadData() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final me = await AuthService.getMe();

      final dashboard = await AdminService.getDashboardStats();

      user = me["data"];

      stats = dashboard["data"];
    } catch (e) {
      errorMessage = "Failed to load profile";

      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =====================================
  /// LOGOUT
  /// =====================================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            /// ERROR
            : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 70),

                    const SizedBox(height: 16),

                    Text(errorMessage!),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: loadData,

                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
            /// SUCCESS
            : RefreshIndicator(
                onRefresh: loadData,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    "District Admin Control Center",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// PROFILE HERO
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(28),

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0A1931), Color(0xFF132D46)],
                          ),

                          borderRadius: BorderRadius.circular(30),
                        ),

                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),

                              decoration: const BoxDecoration(
                                color: Colors.white,

                                shape: BoxShape.circle,
                              ),

                              child: CircleAvatar(
                                radius: 48,

                                backgroundColor: AppColors.primary,

                                child: Text(
                                  (user?["fullName"] ?? "A")[0].toUpperCase(),

                                  style: const TextStyle(
                                    color: Colors.white,

                                    fontSize: 36,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              user?["fullName"] ?? "District Admin",

                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 30,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              user?["adminProfile"]?["district"] ??
                                  "District Administration",

                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                color: Colors.white70,

                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 26),

                            Row(
                              children: [
                                Expanded(
                                  child: buildProfileStat(
                                    title: "Students",

                                    value: "${stats?["totalStudents"] ?? 0}",
                                  ),
                                ),

                                Expanded(
                                  child: buildProfileStat(
                                    title: "Mentors",

                                    value: "${stats?["totalMentors"] ?? 0}",
                                  ),
                                ),

                                Expanded(
                                  child: buildProfileStat(
                                    title: "Pending",

                                    value: "${stats?["pendingStudents"] ?? 0}",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// ACCOUNT DETAILS
                      const Text(
                        "Account Details",

                        style: TextStyle(
                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 18),

                      buildInfoTile(
                        icon: Icons.phone_rounded,

                        title: "Phone Number",

                        value: user?["phone"] ?? "-",
                      ),

                      buildInfoTile(
                        icon: Icons.location_city,

                        title: "District",

                        value: user?["adminProfile"]?["district"] ?? "-",
                      ),

                      buildInfoTile(
                        icon: Icons.security_rounded,

                        title: "Role",

                        value: user?["role"] ?? "-",
                      ),

                      buildInfoTile(
                        icon: Icons.verified_user_rounded,

                        title: "Verification Status",

                        value: user?["isVerified"] == true
                            ? "Verified"
                            : "Pending",
                      ),

                      buildInfoTile(
                        icon: Icons.circle,

                        title: "Account Status",

                        value: user?["isActive"] == true
                            ? "Active"
                            : "Suspended",
                      ),

                      const SizedBox(height: 32),

                      /// DISTRICT ANALYTICS
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(24),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "District Analytics",

                              style: TextStyle(
                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            buildAnalyticsRow(
                              title: "Approved Students",

                              value: "${stats?["approvedStudents"] ?? 0}",
                            ),

                            buildAnalyticsRow(
                              title: "Pending Students",

                              value: "${stats?["pendingStudents"] ?? 0}",
                            ),

                            buildAnalyticsRow(
                              title: "Total Students",

                              value: "${stats?["totalStudents"] ?? 0}",
                            ),

                            buildAnalyticsRow(
                              title: "Total Mentors",

                              value: "${stats?["totalMentors"] ?? 0}",
                            ),

                            buildAnalyticsRow(
                              title: "Scholarship Distribution",

                              value: "₹ ${stats?["totalExpenses"] ?? 0}",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      /// LOGOUT
                      SizedBox(
                        width: double.infinity,

                        height: 58,

                        child: ElevatedButton.icon(
                          onPressed: logout,

                          icon: const Icon(Icons.logout_rounded),

                          label: const Text("Logout"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              250,
                              158,
                              151,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildProfileStat({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            color: Colors.white,

            fontSize: 24,

            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 6),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnalyticsRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          Text(
            value,

            style: const TextStyle(
              fontWeight: FontWeight.bold,

              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
