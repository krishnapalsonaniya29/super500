import 'package:flutter/material.dart';

import '../../../../widgets/buttons/custom_button.dart';
import '../../../../widgets/inputs/custom_textfield.dart';
import '../widgets/auth_switch_text.dart';
import 'student_register_screen.dart';

class StudentLoginScreen extends StatelessWidget {
  const StudentLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            const Text(
              'Welcome Student',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Login to continue your scholarship journey',
            ),

            const SizedBox(height: 40),

            CustomTextField(
              hintText: 'Enter Mobile Number',
              controller: phoneController,
                     keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Send OTP',
              onPressed: () {},
            ),

            const SizedBox(height: 30),

            AuthSwitchText(
              normalText: "Don't have an account? ",
              actionText: 'Register',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentRegisterScreen(),
                   ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}