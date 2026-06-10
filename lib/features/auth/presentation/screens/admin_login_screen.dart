import 'package:flutter/material.dart';

import '../../../../routes/app_routes.dart';

import '../../../../services/auth/auth_service.dart';

import '../../../../theme/app_colors.dart';

class AdminLoginScreen
    extends StatefulWidget {
  const AdminLoginScreen({
    super.key,
  });

  @override
  State<AdminLoginScreen>
      createState() =>
          _AdminLoginScreenState();
}

class _AdminLoginScreenState
    extends State<
        AdminLoginScreen> {
  final phoneController =
      TextEditingController();

  bool loading = false;

  /// =====================================
  /// SEND OTP
  /// =====================================

  Future<void> sendOtp() async {
    if (phoneController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.red,
          content: Text(
            "Please enter phone number",
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
          await AuthService.sendOtp(
        phoneController.text.trim(),
      );

      debugPrint(
        response.toString(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "OTP sent successfully",
          ),
        ),
      );

      Navigator.pushNamed(
        context,
        AppRoutes.otpVerification,

        arguments: {
          "phone":
              phoneController.text
                  .trim(),

          "role": "ADMIN",
        },
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.red,
          content: Text(
            e.toString(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            24,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              const SizedBox(
                height: 40,
              ),

              /// BACK BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },

                child: Container(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),

                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              /// HEADER
              const Text(
                "District Admin Login",

                style: TextStyle(
                  fontSize: 34,

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'Poppins',

                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              const Text(
                "Manage students, mentors, documents and district operations.",

                style: TextStyle(
                  fontSize: 16,

                  color: AppColors
                      .textSecondary,

                  height: 1.5,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              /// HERO CARD
              Container(
                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(
                  26,
                ),

                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),

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
                ),

                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withValues(
                          alpha: 0.12,
                        ),

                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons
                            .admin_panel_settings_rounded,

                        color:
                            Colors.white,

                        size: 54,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    const Text(
                      "District Administration Portal",

                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    const Text(
                      "Secure access for district administrators to manage scholarship operations.",

                      textAlign:
                          TextAlign.center,

                      style:
                          TextStyle(
                        color:
                            Colors.white70,

                        height:
                            1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              /// PHONE FIELD
              const Text(
                "Phone Number",

                style: TextStyle(
                  fontSize: 16,

                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              TextField(
                controller:
                    phoneController,

                keyboardType:
                    TextInputType.phone,

                decoration:
                    InputDecoration(
                  hintText:
                      "Enter phone number",

                  prefixIcon:
                      const Icon(
                    Icons.phone,
                  ),

                  filled: true,

                  fillColor:
                      Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    borderSide:
                        BorderSide.none,
                  ),

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                ),
              ),

              const SizedBox(
                height: 36,
              ),

              /// LOGIN BUTTON
              SizedBox(
                width:
                    double.infinity,

                height: 58,

                child:
                    ElevatedButton(
                  onPressed:
                      loading
                          ? null
                          : sendOtp,

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

                  child:
                      loading
                          ? const SizedBox(
                              height:
                                  24,

                              width:
                                  24,

                              child:
                                  CircularProgressIndicator(
                                color:
                                    Colors.white,

                                strokeWidth:
                                    2.5,
                              ),
                            )
                          : const Text(
                              "Send OTP",

                              style:
                                  TextStyle(
                                fontSize:
                                    16,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Colors.white,
                              ),
                            ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              /// INFO CARD
              Container(
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
                    20,
                  ),
                ),

                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,

                      color:
                          AppColors.primary,
                    ),

                    SizedBox(
                      width: 14,
                    ),

                    Expanded(
                      child: Text(
                        "Use your registered district admin phone number to continue.",

                        style:
                            TextStyle(
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}