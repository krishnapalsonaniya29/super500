  import 'package:flutter/material.dart';

  import '../../../../../theme/app_colors.dart';
  import '../../../../../services/auth/auth_service.dart';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../services/student/student_service.dart';
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
      XFile? selectedImage;

      Uint8List? imageBytes;
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
                      color: Color.fromARGB(255, 2, 82, 161),
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

                  StatefulBuilder(
                    builder: (
                      context,
                      modalSetState,
                    ) {
                      return Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withValues(
                            alpha: 0.05,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: Column(
                          children: [
                            if (imageBytes != null)
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                  14,
                                ),
                                child: Image.memory(
                                  imageBytes!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                            if (imageBytes != null)
                              const SizedBox(
                                height: 14,
                              ),

                            OutlinedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final image =
                                    await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 80,
                                );

                                if (image == null) return;

                                final bytes =
                                    await image.readAsBytes();

                                modalSetState(() {
                                  selectedImage = image;
                                  imageBytes = bytes;
                                });
                              },

                              icon: const Icon(
                                Icons.upload,
                              ),

                              label: Text(
                                selectedImage == null
                                    ? "Upload Proof Image"
                                    : "Change Proof Image",
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              "Upload certificate, medal photo, result screenshot or any supporting proof.",
                              textAlign:
                                  TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                    onPressed: () async {
                    if (titleController.text
                    .trim()
                    .isEmpty) {
                    return;
                    }

                    
                      try {
                       MultipartFile? proof;

                        if (selectedImage != null) {
                          proof = MultipartFile.fromBytes(
                            imageBytes!,
                            filename: selectedImage!.name,
                          );
                        }

                        await StudentService
                            .createAchievement(
                          title: titleController.text
                              .trim(),
                          description:
                              descriptionController.text
                                  .trim(),
                          proof: proof,
                        );

                        if (!mounted) return;

                        Navigator.pop(context);

                        await fetchData();

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Achievement submitted successfully",
                            ),
                          ),
                        );
                      } catch (e) {
                        debugPrint(
                          "Achievement Error: $e",
                        );

                        if (!mounted) return;

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Failed to submit achievement: $e",
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,
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
                        color: Colors.white,
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
      String? proofImageUrl,
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
       
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            

            Row(
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

                const SizedBox(
                  width: 18,
                ),

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
            const SizedBox(height: 12),

              if (proofImageUrl != null &&
                  proofImageUrl.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("View Proof"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(16),
                            child: InteractiveViewer(
                              child: Image.network(
                                proofImageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
          foregroundColor:
              Colors.white,
          icon: const Icon(
            Icons.add,
          ),

          label: const Text(
            "Add Achievement",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
                      

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.25),
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
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Achievements",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    "Showcase your achievements and accomplishments.",
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
                              LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary,
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
                               "No achievements uploaded yet.\nTap 'Add Achievement' to showcase your accomplishments.",
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
                                  achievement["title"] ??
                                  "Achievement",

                              subtitle:
                                  achievement["description"] ??
                                  "No description",
                                  

                              proofImageUrl:
                                  achievement[
                                      "proofImageUrl"],

                              

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