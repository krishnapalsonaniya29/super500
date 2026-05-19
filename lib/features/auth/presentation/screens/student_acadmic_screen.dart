import 'package:flutter/material.dart';

class StudentAcademicScreen extends StatelessWidget {
  const StudentAcademicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Academic Details"),
      ),

      body: const Center(
        child: Text(
          "Academic Screen",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}