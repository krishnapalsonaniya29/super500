import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

class AdminHomeScreen
    extends StatefulWidget {
  const AdminHomeScreen({
    super.key,
  });

  @override
  State<AdminHomeScreen>
      createState() =>
          _AdminHomeScreenState();
}

class _AdminHomeScreenState
    extends State<
        AdminHomeScreen> {
  Map<String, dynamic>? stats;

  bool loading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    fetchDashboard();
  }

  /// =====================================
  /// FETCH DASHBOARD
  /// =====================================

  Future<void>
      fetchDashboard() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
          errorMessage = null;
        });
      }

      final response =
          await AdminService
              .getDashboardStats();

      if (response["success"] !=
          true) {
        throw Exception(
          "Failed to load dashboard",
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
            "Failed to load dashboard";
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

            /// ERROR
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        const Icon(
                          Icons.error,
                          color:
                              Colors.red,
                          size: 70,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Text(
                          errorMessage!,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        ElevatedButton(
                          onPressed:
                              fetchDashboard,

                          child:
                              const Text(
                            "Retry",
                          ),
                        ),
                      ],
                    ),
                  )

                /// SUCCESS
                : RefreshIndicator(
                    onRefresh:
                        fetchDashboard,

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
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children:
                                    const [
                                  Text(
                                    "District Admin",

                                    style:
                                        TextStyle(
                                      fontSize:
                                          30,

                                      fontWeight:
                                          FontWeight.bold,

                                      fontFamily:
                                          'Poppins',
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                        6,
                                  ),

                                  Text(
                                    "District Management Dashboard",

                                    style:
                                        TextStyle(
                                      color:
                                          AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.all(
                                  14,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .admin_panel_settings_rounded,

                                  color:
                                      AppColors.primary,
                                ),
                              ),
                            ],
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
                                  "District Scholarship Distribution",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white70,

                                    fontSize:
                                        15,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      12,
                                ),

                                Text(
                                  "₹ ${stats?["totalExpenses"] ?? 0}",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,

                                    fontSize:
                                        38,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      24,
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
                                            "Pending",

                                        value:
                                            "${stats?["pendingStudents"] ?? 0}",
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
                              DashboardCard(
                                title:
                                    "Approved Students",

                                value:
                                    "${stats?["approvedStudents"] ?? 0}",

                                icon:
                                    Icons.verified_rounded,
                              ),

                              DashboardCard(
                                title:
                                    "Pending Verification",

                                value:
                                    "${stats?["pendingStudents"] ?? 0}",

                                icon:
                                    Icons.pending_actions_rounded,
                              ),

                              DashboardCard(
                                title:
                                    "District Mentors",

                                value:
                                    "${stats?["totalMentors"] ?? 0}",

                                icon:
                                    Icons.groups_rounded,
                              ),

                              DashboardCard(
                                title:
                                    "District Students",

                                value:
                                    "${stats?["totalStudents"] ?? 0}",

                                icon:
                                    Icons.school_rounded,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          /// QUICK ACTIONS
                          const Text(
                            "Quick Actions",

                            style:
                                TextStyle(
                              fontSize:
                                  22,

                              fontWeight:
                                  FontWeight.bold,

                              fontFamily:
                                  'Poppins',
                            ),
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          buildQuickAction(
                            icon:
                                Icons
                                    .verified_user_rounded,

                            title:
                                "Verify Students",

                            subtitle:
                                "Approve or reject district students",
                          ),

                          buildQuickAction(
                            icon:
                                Icons
                                    .description_rounded,

                            title:
                                "Verify Documents",

                            subtitle:
                                "Approve pending student documents",
                          ),

                          buildQuickAction(
                            icon:
                                Icons
                                    .currency_rupee_rounded,

                            title:
                                "Approve Expenses",

                            subtitle:
                                "Review student financial requests",
                          ),

                          buildQuickAction(
                            icon:
                                Icons
                                    .groups_rounded,

                            title:
                                "Manage Mentors",

                            subtitle:
                                "Assign and verify district mentors",
                          ),

                          const SizedBox(
                            height: 100,
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

  Widget buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(
              color: AppColors
                  .primary
                  .withValues(
                    alpha: 0.1,
                  ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,

              color:
                  AppColors.primary,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 17,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  subtitle,

                  style:
                      const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class DashboardCard
    extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
                  alpha: 0.04,
                ),

            blurRadius: 8,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Container(
            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(
              color: AppColors
                  .primary
                  .withValues(
                    alpha: 0.1,
                  ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,

              color:
                  AppColors.primary,
            ),
          ),

          const Spacer(),

          Text(
            value,

            style: const TextStyle(
              fontSize: 30,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,

            style: const TextStyle(
              color: AppColors
                  .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}