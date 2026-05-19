import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../widgets/buttons/custom_button.dart';
// import 'package:dio/dio.dart';

// import '../../../../services/auth/auth_service.dart';
// import '../../../../services/storage/storage_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
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

// Future<void> verifyOtp() async {
//   try {
//     setState(() {
//       isLoading = true;
//     });

//     final response =
//         await AuthService.verifyOtp(
//       phone: widget.phoneNumber,
//       otp: otpController.text.trim(),
//     );

//     if (response.statusCode == 200 ||
//         response.statusCode == 201) {

//       final data = response.data;

//       final token = data['token'];

//       final role =
//           data['user']['role'];

//       // SAVE TOKEN
//       await StorageService.saveToken(token);

//       // SAVE ROLE
//       await StorageService.saveRole(role);

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content:
//               Text('OTP Verified Successfully'),
//         ),
//       );

//       // ROLE BASED NAVIGATION

//       if (role == 'STUDENT') {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/student-dashboard',
//           (route) => false,
//         );
//       }

//       else if (role == 'MENTOR') {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/mentor-dashboard',
//           (route) => false,
//         );
//       }

//       else if (role == 'ADMIN') {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/admin-dashboard',
//           (route) => false,
//         );
//       }

//       else if (role == 'SUPER_ADMIN') {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/super-admin-dashboard',
//           (route) => false,
//         );
//       }
//     }
//   } on DioException catch (e) {
//     String errorMessage =
//         'OTP Verification Failed';

//     if (e.response != null &&
//         e.response?.data != null) {

//       errorMessage =
//           e.response?.data['message'] ??
//               errorMessage;
//     }

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(errorMessage),
//       ),
//     );
//   } catch (e) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(e.toString()),
//       ),
//     );
//   } finally {
//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
// }

Future<void> verifyOtp() async {

  try {

    setState(() {
      isLoading = true;
    });

    // Fake API delay
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'OTP Verified Successfully',
        ),
      ),
    );

    // DIRECT NAVIGATION
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/student-dashboard',
      (route) => false,
    );

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
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
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter the OTP sent to ${widget.phoneNumber}',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,

                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),

                decoration: InputDecoration(
                  hintText: '------',
                  counterText: '',

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: 'Verify OTP',
                isLoading: isLoading,
                onPressed: verifyOtp,
              ),

              const SizedBox(height: 30),

              Center(
                child: secondsRemaining > 0
                    ? Text(
                        'Resend OTP in ${secondsRemaining}s',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            secondsRemaining = 30;
                          });

                          startTimer();

                         
                        },
                        child: const Text(
                          'Resend OTP',
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