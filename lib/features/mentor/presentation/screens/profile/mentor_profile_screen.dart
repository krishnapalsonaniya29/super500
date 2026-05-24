import 'package:flutter/material.dart';

import '../../../../../services/storage/storage_service.dart';

import '../../../../../theme/app_colors.dart';

import '../../../../../widgets/loaders/app_loader.dart';

class MentorProfileScreen
    extends StatefulWidget {
  const MentorProfileScreen({
    super.key,
  });

  @override
  State<MentorProfileScreen>
      createState() =>
          _MentorProfileScreenState();
}

class _MentorProfileScreenState
    extends State<
        MentorProfileScreen> {
  String name = "";

  String phone = "";

  String role = "";

  bool isLoading = true;

  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  Future<void>
      loadUserData() async {
    try {
      final user =
          await StorageService
              .getUser();

      if (!mounted) return;

      setState(() {
        name =
            user?["name"] ?? "";

        phone =
            user?["phone"] ?? "";

        role =
            user?["role"] ?? "";

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> logout() async {
    setState(() {
      isLoggingOut = true;
    });

    try {
      await StorageService
          .logout();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/role-selection",
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isLoggingOut = false;
      });
    }
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),

      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),

        title: Text(title),

        subtitle: Text(
          value.isEmpty
              ? "Not Available"
              : value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: AppLoader(),
      );
    }

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.primary,

        elevation: 0,

        title: const Text(
          "Mentor Profile",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: [
            /// =========================
            /// PROFILE HEADER
            /// =========================

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                24,
              ),

              decoration:
                  BoxDecoration(
                color:
                    AppColors.primary,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,

                    backgroundColor:
                        AppColors.gold,

                    child: Text(
                      name.isNotEmpty
                          ? name[0]
                              .toUpperCase()
                          : "M",

                      style:
                          const TextStyle(
                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  Text(
                    name.isEmpty
                        ? "Mentor"
                        : name,

                    style:
                        const TextStyle(
                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,

                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    role
                        .toUpperCase(),

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,

                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            /// =========================
            /// DETAILS
            /// =========================

            buildTile(
              icon: Icons.phone,

              title:
                  "Phone Number",

              value: phone,
            ),

            buildTile(
              icon: Icons.badge,

              title: "Role",

              value: role,
            ),

            const SizedBox(
              height: 30,
            ),

            /// =========================
            /// LOGOUT BUTTON
            /// =========================

            SizedBox(
              width: double.infinity,

              child:
                  ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),

                onPressed:
                    isLoggingOut
                        ? null
                        : logout,

                icon: const Icon(
                  Icons.logout,

                  color:
                      Colors.white,
                ),

                label: Text(
                  isLoggingOut
                      ? "Logging out..."
                      : "Logout",

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}