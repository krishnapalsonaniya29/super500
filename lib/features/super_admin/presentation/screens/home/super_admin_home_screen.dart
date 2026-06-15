import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../services/super_admin/super_admin_service.dart';

class SuperAdminHomeScreen
    extends StatefulWidget {
  const SuperAdminHomeScreen({
    super.key,
  });

  @override
  State<SuperAdminHomeScreen>
      createState() =>
          _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState
    extends State<
        SuperAdminHomeScreen> {
  Map<String, dynamic>? stats;

  bool loading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    fetchStats();
  }

  /// =====================================
  /// FETCH DASHBOARD STATS
  /// =====================================

  Future<void> fetchStats() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
          errorMessage = null;
        });
      }

      final response =
          await SuperAdminService
              .getDashboardStats();
print(
  "DASHBOARD DATA => ${response["data"]}",
);
      if (response["success"] !=
          true) {
        throw Exception(
          "Failed to fetch dashboard stats",
        );
      }

      if (!mounted) return;

      setState(() {
        stats = response["data"];
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        errorMessage =
            e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            /// ERROR STATE
            : errorMessage != null
                ? Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          const Icon(
                            Icons
                                .error_outline_rounded,

                            size: 70,

                            color: Colors.red,
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          const Text(
                            "Failed to load dashboard",

                            style: TextStyle(
                              fontSize: 22,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            errorMessage!,

                            textAlign:
                                TextAlign
                                    .center,

                            style:
                                const TextStyle(
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          ElevatedButton(
                            onPressed:
                                fetchStats,

                            child:
                                const Text(
                              "Retry",
                            ),
                          ),
                        ],
                      ),
                    ),
                  )

                /// SUCCESS STATE
                : RefreshIndicator(
                    onRefresh:
                        fetchStats,

                    child:
                        SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          /// HEADER
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                                  BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary
                                      .withOpacity(0.25),
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
                                  padding:
                                      const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(
                                      16,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(
                                      12,
                                    ),
                                    child: Image.asset(
                                      "assets/images/app_logo2.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Super Admin",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight:
                                              FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        "Scholarship Control Center",
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

                          const SizedBox(
                            height: 28,
                          ),

                          /// HERO CARD
                          Container(
                            width:
                                double.infinity,

                            padding:
                                const EdgeInsets.all(
                              28,
                            ),

                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),

                              gradient:
                                  const LinearGradient(
                                colors: [
                                  Color(
                                    0xFF0A1931,
                                  ),
                                  Color(
                                    0xFF132D46,
                                  ),
                                ],
                              ),
                            ),

                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                const Text(
                                  "Total Scholarship Allotted",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      12,
                                ),

                                Text(
                                  "₹ ${stats?["totalAllottedAmount"] ?? 0}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      26,
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          buildMiniStat(
                                        title:
                                            "Students",

                                        value:
                                            "${stats?["totalStudents"] ?? 0}",
                                      ),
                                    ),

                                    Expanded(
                                      child:
                                          buildMiniStat(
                                        title:
                                            "Mentors",

                                        value:
                                            "${stats?["totalMentors"] ?? 0}",
                                      ),
                                    ),

                                    Expanded(
                                      child:
                                          buildMiniStat(
                                        title:
                                            "Admins",

                                        value:
                                            "${stats?["totalAdmins"] ?? 0}",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 28,
                          ),

                          /// GRID
                          GridView.count(
                            shrinkWrap:
                                true,

                            physics:
                                const NeverScrollableScrollPhysics(),

                            crossAxisCount:
                                2,

                            crossAxisSpacing:
                                18,

                            mainAxisSpacing:
                                18,

                            childAspectRatio:
                                1.05,

                            children: [
                              DashboardStatCard(
                                title:
                                    "Approved Students",

                                value:
                                    "${stats?["approvedStudents"] ?? 0}",

                                icon:
                                    Icons.verified_rounded,
                              ),

                              DashboardStatCard(
                                title:
                                    "Pending Verification",

                                value:
                                    "${stats?["pendingStudents"] ?? 0}",

                                icon:
                                    Icons.pending_actions_rounded,
                              ),

                              DashboardStatCard(
                                title:
                                    "Rejected Students",

                                value:
                                    "${stats?["rejectedStudents"] ?? 0}",

                                icon:
                                    Icons.cancel_rounded,
                              ),

                              DashboardStatCard(
                                title:
                                    "Platform Users",

                                value:
                                    "${(stats?["totalStudents"] ?? 0) + (stats?["totalMentors"] ?? 0) + (stats?["totalAdmins"] ?? 0)}",

                                icon:
                                    Icons.people_alt_rounded,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget buildMiniStat({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,

          style: const TextStyle(
            color: Colors.white,

            fontSize: 22,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  final Color iconColor;
  final Color backgroundColor;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            padding:
                const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.12,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 26,
            ),
          ),

          const Spacer(),

          Text(
            value,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,

            style: const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 14,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}