import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../services/auth/auth_service.dart';
import '../../../../../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const ProfileScreen({
    super.key,
    this.onNavigate,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  Map<String, dynamic>? userData;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response =
          await AuthService.getMe();

      setState(() {
        userData = response["data"];
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> logout(
      BuildContext context) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove("accessToken");

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const RoleSelectionScreen(),
      ),
      (route) => false,
    );
  }

  String? getProfilePhoto() {
    final documents =
        userData?["studentProfile"]
            ?["documents"];

    if (documents == null) return null;

    for (var doc in documents) {
      if (doc["documentType"] ==
          "PHOTO") {
        return doc["documentUrl"];
      }
    }

    return null;
  }

  void showPersonalDetails() {
    final profile =
        userData?["studentProfile"];

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
          padding: const EdgeInsets.all(24),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisSize:
                  MainAxisSize.min,

              children: [
                const Text(
                  "Personal Details",

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                buildDetailTile(
                  "Full Name",
                  userData?["fullName"] ??
                      "-",
                ),

                buildDetailTile(
                  "Father Name",
                  profile?["fatherName"] ??
                      "-",
                ),

                buildDetailTile(
                  "School",
                  profile?["schoolName"] ??
                      "-",
                ),

                buildDetailTile(
                  "Class",
                  profile?["currentClass"] ??
                      "-",
                ),

                buildDetailTile(
                  "District",
                  profile?["district"] ??
                      "-",
                ),

                buildDetailTile(
                  "Gender",
                  profile?["gender"] ??
                      "-",
                ),

                buildDetailTile(
                  "Category",
                  profile?["category"] ??
                      "-",
                ),

                buildDetailTile(
                  "Address",
                  profile?["address"] ??
                      "-",
                ),

                buildDetailTile(
                  "Bank",
                  profile?["bankName"] ??
                      "-",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDocuments() {
    final documents =
        userData?["studentProfile"]
            ?["documents"] ??
            [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,

          expand: false,

          builder: (
            context,
            scrollController,
          ) {
            return Container(
              padding:
                  const EdgeInsets.all(24),

              decoration:
                  const BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    "Uploaded Documents",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      controller:
                          scrollController,

                      children:
                          documents.map<Widget>(
                        (doc) {
                          return ListTile(
                            contentPadding:
                                EdgeInsets.zero,

                            leading:
                                const Icon(
                              Icons.description,
                              color:
                                  AppColors
                                      .primary,
                            ),

                            title: Text(
                              doc[
                                  "documentType"],
                            ),

                            subtitle: Text(
                              doc["verified"] ==
                                      true
                                  ? "Verified"
                                  : "Pending Verification",
                            ),

                            trailing:
                                IconButton(
                              icon:
                                  const Icon(
                                Icons
                                    .open_in_new,
                              ),

                              onPressed:
                                  () async {
                                final url =
                                    doc[
                                        "documentUrl"];

                                final uri =
                                    Uri.parse(
                                  url,
                                );

                                if (await canLaunchUrl(
                                  uri,
                                )) {
                                  await launchUrl(
                                    uri,

                                    mode:
                                        LaunchMode
                                            .externalApplication,
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildDetailTile(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Expanded(
            flex: 2,

            child: Text(
              title,

              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            flex: 3,

            child: Text(
              value,

              style: const TextStyle(
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilePhoto =
        getProfilePhoto();

    return Scaffold(
      backgroundColor:
          AppColors.background,

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
                  children: [
                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      height: 120,
                      width: 120,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color:
                            Colors.white,

                        image:
                            profilePhoto !=
                                    null
                                ? DecorationImage(
                                    image:
                                        NetworkImage(
                                      profilePhoto,
                                    ),

                                    fit: BoxFit
                                        .cover,
                                  )
                                : null,

                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withValues(alpha: 0.08),

                            blurRadius: 12,

                            offset:
                                const Offset(
                              0,
                              4,
                            ),
                          ),
                        ],
                      ),

                      child:
                          profilePhoto ==
                                  null
                              ? const Icon(
                                  Icons.person,
                                  size: 70,
                                  color:
                                      AppColors
                                          .primary,
                                )
                              : null,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      userData?[
                              "fullName"] ??
                          "Student",

                      style:
                          const TextStyle(
                        fontSize: 28,
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

                    const Text(
                      'Super 500 Student',

                      style: TextStyle(
                        color: AppColors
                            .textSecondary,

                        fontFamily:
                            'Poppins',
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    GestureDetector(
                      onTap:
                          showPersonalDetails,

                      child:
                          _buildProfileTile(
                        icon: Icons
                            .person_outline_rounded,

                        title:
                            'Personal Information',
                      ),
                    ),

                    GestureDetector(
                      onTap: showDocuments,

                      child:
                          _buildProfileTile(
                        icon: Icons
                            .description_outlined,

                        title:
                            'Documents',
                      ),
                    ),

                    Opacity(
                      opacity: 0.5,

                      child:
                          IgnorePointer(
                        ignoring: true,

                        child:
                            _buildProfileTile(
                          icon: Icons
                              .settings_outlined,

                          title:
                              'Settings',
                        ),
                      ),
                    ),

                    Opacity(
                      opacity: 0.5,

                      child:
                          IgnorePointer(
                        ignoring: true,

                        child:
                            _buildProfileTile(
                          icon: Icons
                              .help_outline_rounded,

                          title:
                              'Help & Support',
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () =>
                          logout(context),

                      child:
                          _buildProfileTile(
                        icon: Icons
                            .logout_rounded,

                        title: 'Logout',

                        isLogout: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),

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
              14,
            ),

            decoration:
                BoxDecoration(
              color: isLogout
                  ? Colors.red
                      .withValues(alpha: 0.1)
                  : AppColors.primary
                      .withValues(alpha: 0.1),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,

              color: isLogout
                  ? Colors.red
                  : AppColors.primary,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              title,

              style: TextStyle(
                fontSize: 17,

                fontWeight:
                    FontWeight.w600,

                fontFamily:
                    'Poppins',

                color: isLogout
                    ? Colors.red
                    : AppColors
                        .textPrimary,
              ),
            ),
          ),

          Icon(
            Icons
                .arrow_forward_ios_rounded,

            size: 18,

            color:
                Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}