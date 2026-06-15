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
            phone:
                phoneController.text.trim(),
            role: "ADMIN",
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
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
                            children: [
                              Text(
                                "Admin Portal",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                "Super 500 Administration",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Image.asset(
                      "assets/images/admin_role.png",
                      height: 120,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Welcome Admin",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Manage students, mentors, documents and district operations.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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