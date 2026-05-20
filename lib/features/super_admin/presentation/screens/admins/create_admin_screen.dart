import 'package:flutter/material.dart';

import '../../../../../theme/app_colors.dart';
import '../../../../../services/super_admin/super_admin_service.dart';

class CreateAdminScreen
    extends StatefulWidget {
  const CreateAdminScreen({
    super.key,
  });

  @override
  State<CreateAdminScreen>
      createState() =>
          _CreateAdminScreenState();
}

class _CreateAdminScreenState
    extends State<
        CreateAdminScreen> {
  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final districtController =
      TextEditingController();

  bool loading = false;

 Future<void> createAdmin() async {
  if (nameController.text
          .trim()
          .isEmpty ||
      phoneController.text
          .trim()
          .isEmpty ||
      districtController.text
          .trim()
          .isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Please fill all fields",
        ),
      ),
    );

    return;
  }

  if (phoneController.text
          .trim()
          .length !=
      10) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Enter valid 10 digit phone number",
        ),
      ),
    );

    return;
  }

  try {
    setState(() {
      loading = true;
    });

    await SuperAdminService.createAdmin(
      fullName:
          nameController.text
              .trim(),

      phone:
          phoneController.text
              .trim(),

      district:
          districtController.text
              .trim()
              .toUpperCase(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Admin created successfully",
        ),
      ),
    );

    Navigator.pop(context);
  } catch (e) {
    String message =
        "Failed to create admin";

    try {
      message = e
              .toString()
              .split("message:")
              .last
              .replaceAll("}", "")
              .trim();
    } catch (_) {}

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  } finally {
    setState(() {
      loading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            AppColors.background,

        title: const Text(
          "Create Admin",
        ),
      ),

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
              /// HERO CARD
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
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: const [
                    Icon(
                      Icons
                          .admin_panel_settings_rounded,

                      color:
                          Colors.white,

                      size: 50,
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Create District Admin",

                      style: TextStyle(
                        color:
                            Colors.white,

                        fontSize: 30,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Each district can have only one admin responsible for student verification and management.",

                      style: TextStyle(
                        color:
                            Colors.white70,

                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// FORM TITLE
              const Text(
                "Admin Details",

                style: TextStyle(
                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'Poppins',
                ),
              ),

              const SizedBox(height: 22),

              /// FULL NAME
              buildTextField(
                controller:
                    nameController,

                hint:
                    "Full Name",

                icon:
                    Icons.person_rounded,
              ),

              const SizedBox(height: 20),

              /// PHONE
              buildTextField(
                controller:
                    phoneController,

                hint:
                    "Phone Number",

                keyboard:
                    TextInputType.phone,

                icon:
                    Icons.phone_rounded,
              ),

              const SizedBox(height: 20),

              /// DISTRICT
              TextField(
                controller:
                    districtController,

                textCapitalization:
                    TextCapitalization.characters,

                onChanged: (value) {
                  districtController.value =
                      districtController.value.copyWith(
                    text: value.toUpperCase(),

                    selection:
                        TextSelection.collapsed(
                      offset: value.length,
                    ),
                  );
                },

                decoration: InputDecoration(
                  hintText:
                      "District (UPPERCASE)",

                  helperText:
                      "Example: BHOPAL",

                  prefixIcon: const Icon(
                    Icons.location_city_rounded,
                  ),

                  filled: true,

                  fillColor: Colors.white,

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// INFO CARD
              Container(
                padding:
                    const EdgeInsets.all(
                  18,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    22,
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

                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                        12,
                      ),

                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .primary
                            .withValues(
                              alpha:
                                  0.1,
                            ),

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.info_rounded,

                        color:
                            AppColors
                                .primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            "Admin Responsibilities",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            "• Verify students\n• Review documents\n• Manage district mentors\n• Monitor scholarship disbursement\n• Track student performance",

                            style: TextStyle(
                              color: AppColors
                                  .textSecondary,

                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// CREATE BUTTON
              SizedBox(
                width: double.infinity,

                height: 58,

                child: ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : createAdmin,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  child: loading
                      ? const CircularProgressIndicator(
                          color:
                              Colors
                                  .white,
                        )
                      : const Text(
                          "Create Admin",

                          style: TextStyle(
                            fontSize: 17,

                            fontWeight:
                                FontWeight
                                    .bold,
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

  Widget buildTextField({
    required TextEditingController
        controller,
    required String hint,
    required IconData icon,
    TextInputType keyboard =
        TextInputType.text,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboard,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,

        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          vertical: 20,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            22,
          ),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}