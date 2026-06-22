import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/buttons/custom_button.dart';
import '../../../../../services/auth/auth_service.dart';
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String role;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.role,
  });
 
  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
      bool isLoading = false;
  final otpController = TextEditingController();

  int secondsRemaining = 30;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining == 0) {
          timer.cancel();
        } else {
          setState(() {
            secondsRemaining--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

Future<void> verifyOtp() async {
  try {
    setState(() {
      isLoading = true;
    });

    final response =
        await AuthService.verifyOtp(
      phone: widget.phoneNumber,
      otp: otpController.text.trim(),
      role: widget.role,
    );
    

    if (response["success"] == true) {
      final user =
          await AuthService
              .getCurrentUser();

      final role = user["role"];

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'OTP Verified Successfully',
          ),
        ),
      );

      /// STUDENT FLOW
      if (role == "STUDENT") {
        final studentProfile =
            user["studentProfile"];

        /// NEW USER
        if (studentProfile == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/student-register',
            (route) => false,
          );

          return;
        }

        /// PROFILE NOT COMPLETED
        if (studentProfile[
                "profileCompleted"] !=
            true) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/student-academic',
            (route) => false,
          );

          return;
        }

        /// DOCUMENTS NOT UPLOADED
        final documents =
            studentProfile["documents"];

        if (documents == null ||
            documents.isEmpty ||
            documents.length < 5) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/student-document-upload',
            (route) => false,
          );

          return;
        }

        /// EVERYTHING COMPLETED
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-dashboard',
          (route) => false,
        );
      }

      /// MENTOR
      else if (role == "MENTOR") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/mentor-dashboard',
          (route) => false,
        );
      }

      /// ADMIN
      else if (role == "ADMIN") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/admin-dashboard',
          (route) => false,
        );
      }

      /// SUPER ADMIN
      else if (role ==
          "SUPER_ADMIN") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/super-admin-dashboard',
          (route) => false,
        );
      }
    }
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
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        /// HEADER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius:
                BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: 0.25),
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
                    padding:
                        const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
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
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Secure Login Authentication",
                          style: TextStyle(
                            color:
                                Colors.white70,
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
                "assets/images/app_logo2.png",
                height: 120,
              ),

              const SizedBox(height: 12),

              const Text(
                "Verify Your OTP",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter the verification code sent to your mobile number",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      Colors.white.withValues(alpha: 
                    0.85,
                  ),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        Text(
          "OTP sent to",
          style: TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          widget.phoneNumber,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 30),

        TextField(
          controller: otpController,
          keyboardType:
              TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 28,
            letterSpacing: 12,
            fontWeight:
                FontWeight.bold,
          ),

          decoration: InputDecoration(
            hintText: "------",
            counterText: "",

            filled: true,
            fillColor: Colors.white,

            border:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
              borderSide:
                  const BorderSide(
                color:
                    AppColors.border,
              ),
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
              borderSide:
                  const BorderSide(
                color:
                    AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        CustomButton(
          text: "Verify OTP",
          isLoading: isLoading,
          onPressed: verifyOtp,
        ),

        const SizedBox(height: 24),

        Center(
          child: secondsRemaining > 0
              ? Text(
                  "Resend OTP in ${secondsRemaining}s",
                  style: const TextStyle(
                    color: AppColors
                        .textSecondary,
                  ),
                )
              : TextButton(
                  onPressed: () {
                    setState(() {
                      secondsRemaining =
                          30;
                    });

                    startTimer();
                  },
                  child: const Text(
                    "Resend OTP",
                  ),
                ),
        ),
      ],
    ),
  ),
),
    );
  }
}
