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
        debugPrint(stats.toString());
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

    final totalAllotted =
      ((stats?["totalAllottedAmount"] ?? 0)
              as num)
          .toDouble();

    final totalUsed =
        ((stats?["totalUsedAmount"] ?? 0)
            as num)
        .toDouble();

    final remaining =
        ((stats?["remainingAmount"] ?? 0)
            as num)
        .toDouble();

    final utilization =
        totalAllotted > 0
            ? totalUsed / totalAllotted
            : 0.0;
    final approvalRate =
      (stats?["totalStudents"] ?? 0) > 0
            ? ((stats?["approvedStudents"] ?? 0) /
                   (stats?["totalStudents"] ?? 1)) *
                100
            : 0;

    final studentsPerMentor =
      (stats?["totalMentors"] ?? 0) > 0
              ? ((stats?["totalStudents"] ?? 0) /
                      (stats?["totalMentors"] ?? 1))
            : 0;
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
                          /// HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(
                            bottom: 24,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.25),
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
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(12),
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
                                      "District Admin",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Text(
                                      "Manage students, mentors, approvals and district funds.",
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
                            width: double.infinity,
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF0A1931),
                                  Color(0xFF132D46),
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "District Scholarship Fund",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "₹ ${totalAllotted.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "${(utilization * 100).toStringAsFixed(1)}% Utilized",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: utilization,
                                    minHeight: 10,
                                    backgroundColor:
                                        Colors.white24,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(14),
                                        decoration:
                                            BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            const Text(
                                              "Used Amount",
                                              style: TextStyle(
                                                color:
                                                    Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "₹${totalUsed.toStringAsFixed(0)}",
                                              style:
                                                  const TextStyle(
                                                color:
                                                    Colors.white,
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.all(14),
                            decoration:
                                BoxDecoration(
                              color: Colors.white12,
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  "Remaining",
                                  style: TextStyle(
                                    color:
                                        Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "₹${remaining.toStringAsFixed(0)}",
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: buildMiniStat(
                            title: "Students",
                            value:
                                "${stats?["totalStudents"] ?? 0}",
                          ),
                        ),

                        Expanded(
                          child: buildMiniStat(
                            title: "Mentors",
                            value:
                                "${stats?["totalMentors"] ?? 0}",
                          ),
                        ),

                        Expanded(
                          child: buildMiniStat(
                            title: "Pending",
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
                                title: "Students",
                                value:
                                    "${stats?["totalStudents"] ?? 0}",
                                icon: Icons.school,
                              ),

                              DashboardCard(
                                title: "Mentors",
                                value:
                                    "${stats?["totalMentors"] ?? 0}",
                                icon: Icons.groups,
                              ),

                              DashboardCard(
                                title: "Approved Students",
                                value:
                                    "${stats?["approvedStudents"] ?? 0}",
                                icon: Icons.verified,
                              ),

                              DashboardCard(
                                title: "Pending Students",
                                value:
                                    "${stats?["pendingStudents"] ?? 0}",
                                icon: Icons.pending,
                              ),

                              DashboardCard(
                                title: "Approved Expenses",
                                value:
                                    "${stats?["approvedExpenses"] ?? 0}",
                                icon: Icons.check_circle,
                              ),

                              DashboardCard(
                                title: "Pending Expenses",
                                value:
                                    "${stats?["pendingExpenses"] ?? 0}",
                                icon: Icons.currency_rupee,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          const Text(
                            "Analytics",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),

                          const SizedBox(height: 16),

                         
                          

                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                buildInfoRow(
                                  "Approval Rate",
                                  "${approvalRate.toStringAsFixed(1)}%",
                                ),

                                buildInfoRow(
                                  "Students / Mentor",
                                  studentsPerMentor
                                      .toStringAsFixed(1),
                                ),

                                buildInfoRow(
                                  "Active Students",
                                  "${stats?["activeStudents"] ?? 0}",
                                ),

                                buildInfoRow(
                                  "Inactive Students",
                                  "${stats?["inactiveStudents"] ?? 0}",
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding:
                                const EdgeInsets.all(24),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius:
                                  BorderRadius.circular(24),
                            ),

                            child: Column(
                              children: [
                                buildInfoRow(
                                  "Total Allotted",
                                  "₹${totalAllotted.toStringAsFixed(0)}",
                                ),

                                buildInfoRow(
                                  "Used Amount",
                                  "₹${totalUsed.toStringAsFixed(0)}",
                                ),

                                buildInfoRow(
                                  "Remaining",
                                  "₹${remaining.toStringAsFixed(0)}",
                                ),
                              ],
                            ),
                          ),                         
                          const SizedBox(
                            height: 30,
                          ),           
                                      
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

Widget buildInfoRow(
  String title,
  String value,
) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 8,
    ),

    child: Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

      children: [
        Text(title),

        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
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