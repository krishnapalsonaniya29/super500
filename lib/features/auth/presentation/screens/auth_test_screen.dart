import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final phoneController = TextEditingController();

  final otpController = TextEditingController();

  String result = "";

  bool otpSent = false;

  bool loading = false;

  Future<void> sendOtp() async {
    try {
      setState(() {
        loading = true;
      });

      final data = await AuthService.sendOtp(
        phone: phoneController.text.trim(),
        role: "ADMIN",
      );

      setState(() {
        otpSent = true;
        result = data["message"];
      });
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    try {
      setState(() {
        loading = true;
      });

      final data = await AuthService.verifyOtp(
        phone: phoneController.text.trim(),
        otp: otpController.text.trim(),
        role: "STUDENT",
      );

      setState(() {
        result = "Login Success\n\n${data.toString()}";
      });
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              if (otpSent)
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    labelText: "Enter OTP",
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,

                height: 55,

                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : otpSent
                      ? verifyOtp
                      : sendOtp,

                  child: loading
                      ? const CircularProgressIndicator()
                      : Text(otpSent ? "Verify OTP" : "Send OTP"),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final data = await AuthService.getMe();

                    setState(() {
                      result = data.toString();
                    });
                  } catch (e) {
                    setState(() {
                      result = e.toString();
                    });
                  }
                },
                child: const Text("Get Me"),
              ),
              const SizedBox(height: 30),

              Text(result, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
