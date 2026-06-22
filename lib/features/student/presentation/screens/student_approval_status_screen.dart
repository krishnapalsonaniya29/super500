import 'package:flutter/material.dart';

import '../../../../services/auth/auth_service.dart';
import 'package:file_picker/file_picker.dart';

import 'package:dio/dio.dart';
import '../../../../services/student/student_service.dart';
class StudentApprovalStatusScreen extends StatefulWidget {
  final Map<String, dynamic> studentProfile;
  
  const StudentApprovalStatusScreen({
    super.key,
    required this.studentProfile,
  });

  @override
  State<StudentApprovalStatusScreen> createState() =>
      _StudentApprovalStatusScreenState();
}

class _StudentApprovalStatusScreenState
    extends State<StudentApprovalStatusScreen> {
  bool loading = false;

  Future<void> replaceDocument(
  String documentType,
) async {
  try {
    final result =
        await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
      ],
    );

    if (result == null) return;

    final file =
        result.files.single;

    String fieldName = "";

    switch (documentType) {
      case "MARKSHEET":
        fieldName = "marksheet";
        break;

      case "AADHAR":
        fieldName = "aadhar";
        break;

      case "PHOTO":
        fieldName = "photo";
        break;

      case "CASTE_CERTIFICATE":
        fieldName =
            "casteCertificate";
        break;

      case "INCOME_CERTIFICATE":
        fieldName =
            "incomeCertificate";
        break;
    }

  MultipartFile multipartFile;

if (file.bytes != null) {
  multipartFile =
      MultipartFile.fromBytes(
    file.bytes!,
    filename: file.name,
  );
} else {
  multipartFile =
      await MultipartFile.fromFile(
    file.path!,
    filename: file.name,
  );
}
    await StudentService.uploadDocuments(
      files: {
        fieldName: multipartFile,
      },
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Document replaced successfully",
        ),
      ),
    );

    final user =
          await AuthService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        widget.studentProfile.clear();

        widget.studentProfile.addAll(
          Map<String, dynamic>.from(
            user["studentProfile"],
          ),
        );
      });
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
}
  
  Future<void> refreshStatus() async {
    try {
      setState(() {
        loading = true;
      });

      final user =
            await AuthService.getCurrentUser();

        setState(() {
          widget.studentProfile.clear();
          widget.studentProfile.addAll(
            Map<String, dynamic>.from(
              user["studentProfile"],
            ),
          );
        });

      if (!mounted) return;

      final student =
          user["studentProfile"];

      final status =
          student?["verificationStatus"];

      if (status == "APPROVED") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/student-dashboard',
          (route) => false,
        );
      } else {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }
@override
void initState() {
  super.initState();

debugPrint(widget.studentProfile.toString());
}
  @override
  Widget build(BuildContext context) {
    final status =
        widget.studentProfile[
                "verificationStatus"] ??
            "PENDING";

    final rejectionReason =
        widget.studentProfile[
            "rejectionReason"];

    final documents =
         (widget.studentProfile["documents"]
                  as List?)
              ?.cast<dynamic>() ??
          [];
    
    final rejectedDocuments =
        documents.where((doc) {
          return doc["verified"] == false &&
              doc["remarks"] != null;
        }).toList();

    IconData icon;
    Color color;
    String title;
    String subtitle;

    switch (status) {
      case "APPROVED":
        icon = Icons.check_circle;
        color = Colors.green;
        title = "Application Approved";
        subtitle =
            "Your application has been approved.";
        break;

      case "REJECTED":
        icon = Icons.cancel;
        color = Colors.red;
        title = "Application Rejected";
        subtitle =
            "Your application requires correction.";
        break;

      default:
        icon = Icons.hourglass_top;
        color = Colors.orange;
        title = "Application Under Review";
        subtitle =
            "Our team is reviewing your documents.";
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              
              Center(
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 120,
                      color: color,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          icon,
                          color: color,
                        ),
                        title: const Text(
                          "Approval Status",
                        ),
                        subtitle:
                            Text(status),
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.folder,
                        ),
                        title: const Text(
                          "Documents Uploaded",
                        ),
                        subtitle: Text(
                          "${documents.length} Documents",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (status == "REJECTED" &&
                  rejectionReason != null)
                Card(
                  color:
                      Colors.red.shade50,
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Rejection Reason",
                          style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const SizedBox(
                            height: 10),
                        Text(
                          rejectionReason,
                        ),
                      ],
                    ),
                  ),
                ),
                if (rejectedDocuments.isNotEmpty) ...[
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rejected Documents",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...rejectedDocuments.map(
                    (document) {
                      return Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    document["documentType"],
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius:
                                    BorderRadius.circular(
                                  8,
                                ),
                              ),
                              child: Text(
                                document["remarks"] ?? "",
                              ),
                            ),

                            const SizedBox(height: 12),

                            Align(
                              alignment:
                                  Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  replaceDocument(
                                    document["documentType"],
                                  );
                                },
                                icon: const Icon(
                                  Icons.upload_file,
                                ),
                                label: const Text(
                                  "Replace Document",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    },
                  ),
                ],

              

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : refreshStatus,
                  child: Text(
                    loading
                        ? "Checking..."
                        : "Refresh Status",
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  onPressed: () async {
                    await AuthService.logout();

                    if (!context.mounted) return;

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}