import 'package:flutter/material.dart';

import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/cards/dashboard_card.dart';
import '../../../widgets/inputs/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super 500'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Login to continue',
            ),

            const SizedBox(height: 30),

            CustomTextField(
              hintText: 'Enter Phone Number',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Send OTP',
              onPressed: () {},
            ),

            const SizedBox(height: 40),

            const DashboardCard(
              title: 'Scholarship Status',
              value: 'Approved',
              icon: Icons.school,
            ),
          ],
        ),
      ),
    );
  }
}