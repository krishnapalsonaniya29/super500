import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../services/auth/auth_service.dart';

class AchievementsScreen
    extends StatefulWidget {
  final Function(int index) onNavigate;

  const AchievementsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AchievementsScreen>
      createState() =>
          _AchievementsScreenState();
}

class _AchievementsScreenState
    extends State<
        AchievementsScreen> {
  Map<String, dynamic>? userData;

  List achievements = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await AuthService.getMe();

      final data = response["data"];

      setState(() {
        userData = data;

        achievements =
            data["studentProfile"]
                    ?["achievements"] ??
                [];
      }); 
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void showAddAchievementDialog() {
    final titleController =
        TextEditingController();

    final descriptionController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),

      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,

            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    24,
          ),

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  "Add Achievement",

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                TextField(
                  controller:
                      titleController,

                  decoration:
                      InputDecoration(
                    labelText:
                        "Achievement Title",

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                TextField(
                  controller:
                      descriptionController,

                  maxLines: 4,

                  decoration:
                      InputDecoration(
                    labelText:
                        "Description: Give full details along with date and institute/organization name if applicable.",

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  decoration:
                      BoxDecoration(
                    color: AppColors
                        .primary
                        .withValues(
                          alpha: 0.05,
                        ),

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color:
                            AppColors
                                .primary,
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          "Proof upload will be added later.",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController
                          .text
                          .trim()
                          .isEmpty) {
                        return;
                      }

                      setState(() {
                        achievements.add({
                          "title":
                              titleController
                                  .text
                                  .trim(),

                          "description":
                              descriptionController
                                  .text
                                  .trim(),

                          "verified":
                              false,
                        });
                      });

                      Navigator.pop(
                        context,
                      );
                    },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors
                              .primary,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    child: const Text(
                      "Add Achievement",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAchievementCard({
    required String title,
    required String subtitle,
    required IconData icon,
    bool verified = false,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      padding:
          const EdgeInsets.all(20),

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
                  alpha: 0.05,
                ),

            blurRadius: 10,

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
              16,
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
                18,
              ),
            ),

            child: Icon(
              icon,
              size: 32,
              color:
                  const Color(
                0xFFD4AF37,
              ),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,

                    fontFamily:
                        'Poppins',

                    color: AppColors
                        .textPrimary,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  subtitle,

                  style:
                      const TextStyle(
                    fontSize: 14,
                    fontFamily:
                        'Poppins',

                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration:
                BoxDecoration(
              color: verified
                  ? Colors.green
                      .withValues(
                        alpha: 0.1,
                      )
                  : Colors.orange
                      .withValues(
                        alpha: 0.1,
                      ),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: Text(
              verified
                  ? "Verified"
                  : "Pending",

              style: TextStyle(
                color: verified
                    ? Colors.green
                    : Colors.orange,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        userData?["studentProfile"];

    final marks10th =
        profile?["marks10th"];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            showAddAchievementDialog,

        backgroundColor:
            AppColors.primary,

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Add Achievement",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SafeArea(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                  20,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    const Text(
                      'Achievements',

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight
                                .bold,

                        fontFamily:
                            'Poppins',

                        color: AppColors
                            .textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    /// 10TH MARKS
                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        24,
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
                          28,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            "10th Board Marks",

                            style: TextStyle(
                              color:
                                  Colors
                                      .white70,

                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            "${marks10th ?? 0}%",

                            style:
                                const TextStyle(
                              color:
                                  Colors
                                      .white,

                              fontSize: 42,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 32,
                    ),

                    const Text(
                      "Other Achievements",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    if (achievements
                        .isEmpty)
                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets.all(
                          24,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                    alpha:
                                        0.05,
                                  ),

                              blurRadius:
                                  10,

                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons
                                  .emoji_events_outlined,

                              size: 60,

                              color:
                                  Colors.grey
                                      .shade400,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            const Text(
                              "You have not uploaded any achievement yet.",

                              textAlign:
                                  TextAlign
                                      .center,

                              style: TextStyle(
                                fontSize: 16,

                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...achievements.map(
                        (achievement) {
                          return buildAchievementCard(
                            title:
                                achievement[
                                        "title"] ??
                                    "Achievement",

                            subtitle:
                                achievement[
                                        "description"] ??
                                    "No description",

                            icon: Icons
                                .emoji_events_rounded,

                            verified:
                                achievement[
                                        "verified"] ??
                                    false,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}