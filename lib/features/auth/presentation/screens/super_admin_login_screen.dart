import 'package:flutter/material.dart';

import '../../../../services/auth/auth_service.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';

import '../../../super_admin/presentation/screens/main/super_admin_dashboard_screen.dart';

class SuperAdminLoginScreen
    extends StatefulWidget {
  const SuperAdminLoginScreen({
    super.key,
  });

  @override
  State<SuperAdminLoginScreen>
      createState() =>
          _SuperAdminLoginScreenState();
}

class _SuperAdminLoginScreenState
    extends State<
        SuperAdminLoginScreen> {
  final phoneController =
      TextEditingController();

  final otpController =
      TextEditingController();

  bool otpSent = false;

  bool loading = false;

  /// ======================================
  /// SEND OTP
  /// ======================================

  Future<void> sendOtp() async {
    try {
      if (phoneController.text
          .trim()
          .isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Enter phone number",
            ),
          ),
        );

        return;
      }

      setState(() {
        loading = true;
      });

      final response =
          await AuthService.sendOtp(
        phoneController.text.trim(),
      );

      if (response["success"] ==
          true) {
        setState(() {
          otpSent = true;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "OTP sent successfully",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  /// ======================================
  /// LOGIN
  /// ======================================

  Future<void> login() async {
    try {
      if (otpController.text
          .trim()
          .isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Enter OTP",
            ),
          ),
        );

        return;
      }

      setState(() {
        loading = true;
      });

      /// VERIFY OTP
      final response =
          await AuthService.verifyOtp(
        phone:
            phoneController.text.trim(),

        otp:
            otpController.text.trim(),
      );

      if (response["success"] !=
          true) {
        throw Exception(
          "Login failed",
        );
      }

      /// GET USER
      final me =
          await AuthService.getMe();

      final user = me["data"];

      final role = user["role"];

      /// BLOCK NON SUPER ADMINS
      if (role !=
          "SUPER_ADMIN") {
        throw Exception(
          "You are not authorized as Super Admin",
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Super Admin Login Successful",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const SuperAdminDashboardScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              const SizedBox(height: 20),

              /// TOP ICON
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    shape: BoxShape.circle,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                              alpha: 0.06,
                            ),

                        blurRadius: 12,

                        offset:
                            const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons
                        .admin_panel_settings_rounded,

                    size: 60,

                    color:
                        AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// TITLE
              const Text(
                'Super Admin Access',

                style: TextStyle(
                  fontSize: 34,

                  fontWeight:
                      FontWeight.bold,

                  fontFamily:
                      'Poppins',

                  color: AppColors
                      .textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Secure access to the Super 500 platform control center',

                style: TextStyle(
                  fontSize: 16,

                  height: 1.5,

                  color: AppColors
                      .textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              /// PHONE
              CustomTextField(
                hintText:
                    'Super Admin Phone Number',

                controller:
                    phoneController,

                keyboardType:
                    TextInputType.phone,
              ),

              const SizedBox(height: 20),

              /// OTP
              if (otpSent)
                CustomTextField(
                  hintText:
                      'Enter OTP',

                  controller:
                      otpController,

                  keyboardType:
                      TextInputType.number,
                ),

              const SizedBox(height: 30),

              /// BUTTON
              CustomButton(
                text: loading
                    ? "Please wait..."
                    : otpSent
                        ? "Login"
                        : "Send OTP",

                onPressed: () {
                  if (loading) return;

                  if (otpSent) {
                    login();
                  } else {
                    sendOtp();
                  }
                },
              ),

              const SizedBox(height: 35),

              /// SECURITY NOTICE
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
                        10,
                      ),

                      decoration:
                          BoxDecoration(
                        color: Colors.red
                            .withValues(
                              alpha: 0.1,
                            ),

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),

                      child: const Icon(
                        Icons.security,

                        color: Colors.red,
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
                            "Restricted Access",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,

                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "Only authorized Labour Department officials and system owners can access this panel.",

                            style: TextStyle(
                              fontSize: 14,

                              height: 1.5,

                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// SYSTEM INFO
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  20,
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
                    24,
                  ),
                ),

                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      "SYSTEM STATUS",

                      style: TextStyle(
                        color:
                            Colors.white70,

                        letterSpacing:
                            1.2,
                      ),
                    ),

                    SizedBox(height: 14),

                    Row(
                      children: [
                        Icon(
                          Icons
                              .verified_rounded,

                          color:
                              Colors.green,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "Platform Secure & Operational",

                          style: TextStyle(
                            color:
                                Colors.white,

                            fontSize: 18,

                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14),

                    Text(
                      "Super 500 Scholarship Management System",

                      style: TextStyle(
                        color:
                            Colors.white70,

                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}