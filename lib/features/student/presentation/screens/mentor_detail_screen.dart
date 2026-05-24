// lib/features/student/presentation/screens/mentor_detail_screen.dart

import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';

class MentorDetailScreen
    extends StatelessWidget {
  final Map<String, dynamic> mentor;

  const MentorDetailScreen({
    super.key,
    required this.mentor,
  });

  @override
  Widget build(BuildContext context) {
    final user =
        mentor["user"] ?? {};

    final fullName =
        user["fullName"] ??
            "Mentor";

    final phone =
        user["phone"] ?? "N/A";

    final email =
        user["email"] ?? "N/A";

    final avatar =
        user["avatar"];

    final specialization =
        mentor["specialization"] ??
            "N/A";

    final experience =
        mentor["experience"] ??
            "N/A";

    final qualification =
        mentor["qualification"] ??
            "N/A";

    final bio =
        mentor["bio"] ??
            "No bio available";

    final district =
        mentor["district"] ??
            "N/A";

    final state =
        mentor["state"] ??
            "N/A";

    final studentsCount =
        mentor["studentsCount"]
                ?.toString() ??
            "0";

    final sessionsCount =
        mentor["sessionsCount"]
                ?.toString() ??
            "0";

    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF5F7FB,
      ),

      body: CustomScrollView(
        slivers: [
          /// =====================================
          /// APP BAR
          /// =====================================

          SliverAppBar(
            expandedHeight: 320,

            pinned: true,

            backgroundColor:
                AppColors.primary,

            flexibleSpace:
                FlexibleSpaceBar(
              background: Container(
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment
                            .topLeft,

                    end:
                        Alignment
                            .bottomRight,

                    colors: [
                      AppColors
                          .primary,

                      AppColors
                          .primary
                          .withOpacity(
                        0.75,
                      ),
                    ],
                  ),
                ),

                child: SafeArea(
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
                        CircleAvatar(
                          radius: 52,

                          backgroundColor:
                              Colors.white,

                          backgroundImage:
                              avatar != null
                                  ? NetworkImage(
                                      avatar,
                                    )
                                  : null,

                          child: avatar ==
                                  null
                              ? Text(
                                  fullName[0]
                                      .toUpperCase(),

                                  style:
                                      TextStyle(
                                    color:
                                        AppColors
                                            .primary,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize:
                                        34,
                                  ),
                                )
                              : null,
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        Text(
                          fullName,

                          style:
                              const TextStyle(
                            color:
                                Colors
                                    .white,

                            fontSize: 26,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                14,

                            vertical:
                                8,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withOpacity(
                              0.15,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: Text(
                            specialization,

                            style:
                                const TextStyle(
                              color:
                                  Colors
                                      .white,

                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,

                          children: [
                            _buildStatCard(
                              "Students",
                              studentsCount,
                            ),

                            _buildStatCard(
                              "Sessions",
                              sessionsCount,
                            ),

                            _buildStatCard(
                              "Experience",
                              experience
                                  .toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// =====================================
          /// BODY
          /// =====================================

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  /// ABOUT
                  _buildSectionTitle(
                    "About Mentor",
                  ),

                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      18,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        22,
                      ),
                    ),

                    child: Text(
                      bio,

                      style:
                          TextStyle(
                        color: Colors
                            .grey[800],

                        height: 1.7,

                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 26,
                  ),

                  /// CONTACT INFO
                  _buildSectionTitle(
                    "Contact Information",
                  ),

                  _buildInfoCard(
                    icon: Icons.phone,
                    title:
                        "Phone Number",
                    value: phone,
                  ),

                  _buildInfoCard(
                    icon: Icons.email,
                    title: "Email",
                    value: email,
                  ),

                  _buildInfoCard(
                    icon:
                        Icons.location_on,
                    title: "Location",
                    value:
                        "$district, $state",
                  ),

                  const SizedBox(
                    height: 26,
                  ),

                  /// PROFESSIONAL DETAILS
                  _buildSectionTitle(
                    "Professional Details",
                  ),

                  _buildInfoCard(
                    icon:
                        Icons.school,
                    title:
                        "Qualification",
                    value:
                        qualification,
                  ),

                  _buildInfoCard(
                    icon:
                        Icons.work,
                    title:
                        "Experience",
                    value:
                        "$experience Years",
                  ),

                  _buildInfoCard(
                    icon:
                        Icons.psychology,
                    title:
                        "Specialization",
                    value:
                        specialization,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// ACTIONS
                  SizedBox(
                    width:
                        double.infinity,

                    height: 56,

                    child:
                        ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      icon: const Icon(
                        Icons.message,
                      ),

                      label: const Text(
                        "Continue Mentorship",
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors
                                .primary,

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================
  /// SECTION TITLE
  /// =====================================

  Widget _buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 20,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  /// =====================================
  /// INFO CARD
  /// =====================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,

            decoration:
                BoxDecoration(
              color:
                  AppColors.primary
                      .withOpacity(
                0.1,
              ),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),

            child: Icon(
              icon,

              color:
                  AppColors.primary,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    color:
                        Colors.grey[
                            600],

                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,

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

  /// =====================================
  /// STAT CARD
  /// =====================================

  Widget _buildStatCard(
    String title,
    String value,
  ) {
    return Container(
      width: 90,

      padding:
          const EdgeInsets.symmetric(
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(
          0.15,
        ),

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Column(
        children: [
          Text(
            value,

            style:
                const TextStyle(
              color:
                  Colors.white,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            title,

            style:
                const TextStyle(
              color:
                  Colors.white70,

              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}