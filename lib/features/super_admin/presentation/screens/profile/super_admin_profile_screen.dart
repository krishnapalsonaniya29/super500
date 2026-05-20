import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class SuperAdminProfileScreen
    extends StatelessWidget {
  final Function(int index)
      onNavigate;

  const SuperAdminProfileScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
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
              const Text(
                "Profile",

                style: TextStyle(
                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'Poppins',

                  color: AppColors
                      .textPrimary,
                ),
              ),

              const SizedBox(height: 28),

              /// PROFILE CARD
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  28,
                ),

                decoration:
                    BoxDecoration(
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

                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),

                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                        4,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        shape:
                            BoxShape.circle,
                      ),

                      child: const CircleAvatar(
                        radius: 48,

                        backgroundColor:
                            AppColors
                                .primary,

                        child: Icon(
                          Icons
                              .admin_panel_settings_rounded,

                          size: 50,

                          color:
                              Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Text(
                      "Super Admin",

                      style: TextStyle(
                        color:
                            Colors.white,

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,

                        fontFamily:
                            'Poppins',
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      "Labour Department Control Authority",

                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color:
                            Colors.white70,

                        height: 1.5,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child:
                              buildProfileStat(
                            title:
                                "Admins",

                            value:
                                "12",
                          ),
                        ),

                        Expanded(
                          child:
                              buildProfileStat(
                            title:
                                "Mentors",

                            value:
                                "86",
                          ),
                        ),

                        Expanded(
                          child:
                              buildProfileStat(
                            title:
                                "Students",

                            value:
                                "1248",
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

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'Poppins',
                ),
              ),

              const SizedBox(height: 18),

              buildInfoTile(
                icon:
                    Icons.phone_rounded,

                title:
                    "Phone Number",

                value:
                    "+91 9999999999",
              ),

              buildInfoTile(
                icon:
                    Icons.security_rounded,

                title:
                    "Role",

                value:
                    "SUPER ADMIN",
              ),

              buildInfoTile(
                icon:
                    Icons.verified_user_rounded,

                title:
                    "Verification Status",

                value:
                    "Verified",
              ),

              buildInfoTile(
                icon:
                    Icons.calendar_month_rounded,

                title:
                    "Access Since",

                value:
                    "20 May 2026",
              ),

              const SizedBox(height: 32),

              /// PLATFORM CONTROL
              const Text(
                "Platform Control",

                style: TextStyle(
                  fontSize: 22,

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'Poppins',
                ),
              ),

              const SizedBox(height: 18),

              buildActionTile(
                icon:
                    Icons.admin_panel_settings_rounded,

                title:
                    "Manage District Admins",

                subtitle:
                    "Create and monitor district admins",
              ),

              buildActionTile(
                icon:
                    Icons.school_rounded,

                title:
                    "Student Verification Control",

                subtitle:
                    "Approve and review student profiles",
              ),

              buildActionTile(
                icon:
                    Icons.payments_rounded,

                title:
                    "Scholarship Disbursement",

                subtitle:
                    "Monitor and control fund distribution",
              ),

              buildActionTile(
                icon:
                    Icons.analytics_rounded,

                title:
                    "Platform Analytics",

                subtitle:
                    "View reports and system statistics",
              ),

              buildActionTile(
                icon:
                    Icons.gpp_good_rounded,

                title:
                    "Security & Permissions",

                subtitle:
                    "Manage system access and security",
              ),

              const SizedBox(height: 32),

              /// SYSTEM STATUS
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  24,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                            alpha: 0.05,
                          ),

                      blurRadius: 10,

                      offset:
                          const Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    const Text(
                      "System Status",

                      style: TextStyle(
                        fontSize: 20,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    buildStatusRow(
                      title:
                          "Server Status",

                      status:
                          "Operational",

                      color:
                          Colors.green,
                    ),

                    buildStatusRow(
                      title:
                          "Database",

                      status:
                          "Connected",

                      color:
                          Colors.green,
                    ),

                    buildStatusRow(
                      title:
                          "Scholarship Engine",

                      status:
                          "Active",

                      color:
                          Colors.green,
                    ),

                    buildStatusRow(
                      title:
                          "Security Monitoring",

                      status:
                          "Protected",

                      color:
                          Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// LOGOUT
              SizedBox(
                width: double.infinity,

                height: 58,

                child: ElevatedButton.icon(
                  onPressed: () {},

                  icon: const Icon(
                    Icons.logout_rounded,
                  ),

                  label: const Text(
                    "Logout",
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileStat({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,

          style: const TextStyle(
            color: Colors.white,

            fontSize: 24,

            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,

          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
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
                    color: AppColors
                        .textSecondary,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  value,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,

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

  Widget buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
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
                    fontWeight:
                        FontWeight
                            .bold,

                    fontSize: 16,
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

                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons
                .arrow_forward_ios_rounded,

            size: 18,
          ),
        ],
      ),
    );
  }

  Widget buildStatusRow({
    required String title,
    required String status,
    required Color color,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),

            decoration:
                BoxDecoration(
              color:
                  color.withValues(
                alpha: 0.1,
              ),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: color,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}