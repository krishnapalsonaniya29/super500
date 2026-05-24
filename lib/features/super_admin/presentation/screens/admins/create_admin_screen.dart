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

  /// =====================================
  /// CREATE ADMIN
  /// =====================================

  Future<void> createAdmin() async {
    FocusScope.of(context).unfocus();

    /// VALIDATION
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

    /// PHONE VALIDATION
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

      final response =
          await SuperAdminService
              .createAdmin(
        fullName:
            nameController.text.trim(),

        phone:
            phoneController.text.trim(),

        district:
            districtController.text
                .trim()
                .toUpperCase(),
      );

      /// SUCCESS CHECK
      if (response.data["success"] !=
          true) {
        throw Exception(
          response.data["message"] ??
              "Failed to create admin",
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.green,

          content: Text(
            response.data["message"] ??
                "Admin created successfully",
          ),
        ),
      );

      /// CLEAR FORM
      nameController.clear();

      phoneController.clear();

      districtController.clear();

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      String message =
          "Failed to create admin";

      /// DIO ERROR PARSING
      try {
        final error =
            e.toString();

        if (error.contains(
          "District already has admin",
        )) {
          message =
              "This district already has an admin";
        } else if (error.contains(
          "Phone already exists",
        )) {
          message =
              "Phone number already registered";
        } else if (error.contains(
          "Unauthorized",
        )) {
          message =
              "Session expired. Login again.";
        } else {
          message = error;
        }
      } catch (_) {}

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.red,

          content: Text(
            message,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();

    phoneController.dispose();

    districtController.dispose();

    super.dispose();
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

              buildTextField(
                controller:
                    nameController,

                hint:
                    "Full Name",

                icon:
                    Icons.person_rounded,
              ),

              const SizedBox(height: 20),

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
                      offset:
                          value.length,
                    ),
                  );
                },

                decoration:
                    InputDecoration(
                  hintText:
                      "District (UPPERCASE)",

                  helperText:
                      "Example: BHOPAL",

                  prefixIcon:
                      const Icon(
                    Icons
                        .location_city_rounded,
                  ),

                  filled: true,

                  fillColor:
                      Colors.white,

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 40),

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
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2.5,

                            color:
                                Colors.white,
                          ),
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