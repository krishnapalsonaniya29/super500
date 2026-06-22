import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../services/auth/auth_service.dart';
import '../../../../../services/student/student_service.dart';
import '../../../../../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int)? onNavigate;

  const ProfileScreen({super.key, this.onNavigate});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  /// =========================
  /// FETCH PROFILE
  /// =========================
  Future<void> fetchProfile() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final response = await StudentService.getProfile();

      debugPrint("PROFILE RESPONSE => $response");

      final rawData = response["data"];
      final data = rawData is Map<String, dynamic>
          ? rawData
          : rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : response;

      debugPrint("EXTRACTED DATA => $data");

      if (!mounted) return;

      setState(() {
        userData = Map<String, dynamic>.from(data);
      });

      debugPrint("USER DATA => $userData");
    } catch (e) {
      debugPrint("fetchProfile error: $e");

      if (!mounted) return;

      setState(() {
        errorMessage = "Unable to load profile details. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> logout(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  /// =========================
  /// GET STUDENT PROFILE
  /// SUPPORTS BOTH:
  /// student
  /// studentProfile
  /// =========================
  Map<String, dynamic>? get studentProfile {
    final profile = userData?["student"] ?? userData?["studentProfile"];

    if (profile is Map<String, dynamic>) {
      return profile;
    }

    if (profile is Map) {
      return Map<String, dynamic>.from(profile);
    }

    return null;
  }

  /// =========================
  /// GET PROFILE PHOTO
  /// =========================
  String? getProfilePhoto() {
    final documents = studentProfile?["documents"];

    if (documents == null || documents is! List) {
      return null;
    }

    for (var doc in documents) {
      if (doc["documentType"] == "PHOTO") {
        return doc["documentUrl"];
      }
    }

    return null;
  }

  /// =========================
  /// SHOW PERSONAL DETAILS
  /// =========================
  void showPersonalDetails() {
    final profile = studentProfile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Personal Details",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                buildDetailTile(
                  "Full Name",
                  userData?["fullName"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "Father Name",
                  profile?["fatherName"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "School",
                  profile?["schoolName"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "Class",
                  profile?["currentClass"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "District",
                  profile?["district"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "Gender",
                  profile?["gender"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "Category",
                  profile?["category"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "Address",
                  profile?["address"]?.toString() ?? "-",
                ),

                buildDetailTile(
                  "Bank",
                  profile?["bankName"]?.toString() ?? "-",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// =========================
  /// SHOW DOCUMENTS
  /// =========================
  void showDocuments() {
    final documents = studentProfile?["documents"] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Uploaded Documents",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: documents.isEmpty
                        ? const Center(child: Text("No documents found"))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final doc = documents[index];

                              return ListTile(
                                contentPadding: EdgeInsets.zero,

                                leading: const Icon(
                                  Icons.description,
                                  color: AppColors.primary,
                                ),

                                title: Text(
                                  doc["documentType"]?.toString() ?? "Document",
                                ),

                                subtitle: Text(
                                  doc["verified"] == true
                                      ? "Verified"
                                      : "Pending Verification",
                                ),

                                trailing: IconButton(
                                  icon: const Icon(Icons.open_in_new),
                                  onPressed: () async {
                                    final url = doc["documentUrl"]?.toString();

                                    if (url == null || url.isEmpty) {
                                      return;
                                    }

                                    final uri = Uri.parse(url);

                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
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

  /// =========================
  /// DETAIL TILE
  /// =========================
  Widget buildDetailTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilePhoto = getProfilePhoto();
    final student = studentProfile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 56,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchProfile,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    /// PROFILE IMAGE
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,

                        image: profilePhoto != null
                            ? DecorationImage(
                                image: NetworkImage(profilePhoto),
                                fit: BoxFit.cover,
                              )
                            : null,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      child: profilePhoto == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: AppColors.primary,
                            )
                          : null,
                    ),

                    const SizedBox(height: 20),

                    /// USER NAME
                    Text(
                      userData?["fullName"]?.toString() ?? "Student",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      student?["schoolName"]?.toString().trim().isNotEmpty ==
                              true
                          ? student!["schoolName"].toString()
                          : 'Super 500 Student',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// PERSONAL INFO
                    GestureDetector(
                      onTap: showPersonalDetails,
                      child: _buildProfileTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Personal Information',
                      ),
                    ),

                    /// DOCUMENTS
                    GestureDetector(
                      onTap: showDocuments,
                      child: _buildProfileTile(
                        icon: Icons.description_outlined,
                        title: 'Documents',
                      ),
                    ),

                    /// SETTINGS
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        ignoring: true,
                        child: _buildProfileTile(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                        ),
                      ),
                    ),

                    /// HELP
                    Opacity(
                      opacity: 0.5,
                      child: IgnorePointer(
                        ignoring: true,
                        child: _buildProfileTile(
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                        ),
                      ),
                    ),

                    /// LOGOUT
                    GestureDetector(
                      onTap: () => logout(context),
                      child: _buildProfileTile(
                        icon: Icons.logout_rounded,
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

  /// =========================
  /// PROFILE TILE
  /// =========================
  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isLogout
                  ? Colors.red.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: isLogout ? Colors.red : AppColors.textPrimary,
              ),
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
