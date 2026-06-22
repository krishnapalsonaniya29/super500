import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './student_dashboard_screen.dart';
import '../../../../../services/auth/auth_service.dart';

class StudentDocumentUploadScreen extends StatefulWidget {
  const StudentDocumentUploadScreen({super.key});

  @override
  State<StudentDocumentUploadScreen> createState() =>
      _StudentDocumentUploadScreenState();
}

class _StudentDocumentUploadScreenState
    extends State<StudentDocumentUploadScreen> {
  Uint8List? marksheetBytes;
  Uint8List? aadharBytes;
  Uint8List? photoBytes;
  Uint8List? casteBytes;
  Uint8List? incomeBytes;

  String? marksheetName;
  String? aadharName;
  String? photoName;
  String? casteName;
  String? incomeName;

  bool loading = false;

  Future<Map<String, dynamic>?> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      return {
        "bytes": result.files.single.bytes,

        "name": result.files.single.name,
      };
    }

    return null;
  }

  Future<Map<String, dynamic>?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      return {
        "bytes": result.files.single.bytes,

        "name": result.files.single.name,
      };
    }

    return null;
  }

  Widget buildUploadCard({
    required String title,
    required VoidCallback onTap,
    required String? fileName,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          const Icon(Icons.upload_file, size: 30, color: Color(0xFF0A1931)),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  fileName ?? "No file selected",

                  style: TextStyle(
                    color: fileName == null ? Colors.grey : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: onTap,

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A1931),
            ),

            child: const Text("Choose"),
          ),
        ],
      ),
    );
  }

  Future<void> uploadDocuments() async {
    if (marksheetBytes == null ||
        aadharBytes == null ||
        photoBytes == null ||
        casteBytes == null ||
        incomeBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all documents")),
      );

      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("accessToken");

      FormData formData = FormData.fromMap({
        "marksheet": MultipartFile.fromBytes(
          marksheetBytes!,
          filename: marksheetName,
        ),

        "aadhar": MultipartFile.fromBytes(aadharBytes!, filename: aadharName),

        "photo": MultipartFile.fromBytes(photoBytes!, filename: photoName),

        "casteCertificate": MultipartFile.fromBytes(
          casteBytes!,
          filename: casteName,
        ),

        "incomeCertificate": MultipartFile.fromBytes(
          incomeBytes!,
          filename: incomeName,
        ),
      });

      await Dio().post(
        "${AuthService.baseUrl.replaceAll('/auth', '')}/documents/upload",

        data: formData,

        options: Options(
          headers: {
            "Authorization": "Bearer $token",

            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Documents uploaded successfully")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StudentDashboardScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          "Upload Documents",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Document Verification",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Upload all required documents",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            buildUploadCard(
              title: "10th Marksheet (PDF)",

              fileName: marksheetName,

              onTap: () async {
                final file = await pickPdf();

                if (file != null) {
                  marksheetBytes = file["bytes"];

                  marksheetName = file["name"];
                }

                setState(() {});
              },
            ),

            buildUploadCard(
              title: "Aadhar Card (PDF)",

              fileName: aadharName,

              onTap: () async {
                final file = await pickPdf();

                if (file != null) {
                  aadharBytes = file["bytes"];

                  aadharName = file["name"];
                }

                setState(() {});
              },
            ),

            buildUploadCard(
              title: "Student Photo (JPG)",

              fileName: photoName,

              onTap: () async {
                final file = await pickImage();

                if (file != null) {
                  photoBytes = file["bytes"];

                  photoName = file["name"];
                }

                setState(() {});
              },
            ),

            buildUploadCard(
              title: "Caste Certificate (PDF)",

              fileName: casteName,

              onTap: () async {
                final file = await pickPdf();

                if (file != null) {
                  casteBytes = file["bytes"];

                  casteName = file["name"];
                }

                setState(() {});
              },
            ),

            buildUploadCard(
              title: "Income Certificate (PDF)",

              fileName: incomeName,

              onTap: () async {
                final file = await pickPdf();

                if (file != null) {
                  incomeBytes = file["bytes"];

                  incomeName = file["name"];
                }

                setState(() {});
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                onPressed: loading ? null : uploadDocuments,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A1931),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Upload Documents",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
