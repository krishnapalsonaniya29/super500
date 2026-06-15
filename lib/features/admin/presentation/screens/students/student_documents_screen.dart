import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';
import '../../../../../theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentDocumentsScreen
    extends StatefulWidget {
  final Map<String, dynamic>
      student;

  const StudentDocumentsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDocumentsScreen>
      createState() =>
          _StudentDocumentsScreenState();
}

class _StudentDocumentsScreenState
    extends State<
        StudentDocumentsScreen> {
  bool loading = false;

  List documents = [];

  @override
  void initState() {
    super.initState();

    documents =
        widget.student["documents"] ??
            [];
  }

  /// =====================================
  /// APPROVE DOCUMENT
  /// =====================================

  Future<void> approveDocument(
    String id,
  ) async {
    try {
      setState(() {
        loading = true;
      });

      await AdminService
          .approveDocument(id);

      updateDocumentStatus(
        id,
        true,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,

          content: Text(
            "Document approved",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.red,

          content: Text(
            "Failed to approve document",
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

  /// =====================================
  /// REJECT DOCUMENT
  /// =====================================

  Future<void> rejectDocument({
    required String id,
    required String remarks,
  }) async {
    try {
      setState(() {
        loading = true;
      });

      await AdminService
          .rejectDocument(
        id: id,
        remarks: remarks,
      );

      updateDocumentStatus(
        id,
        false,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.orange,

          content: Text(
            "Document rejected",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.red,

          content: Text(
            "Failed to reject document",
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

  /// =====================================
  /// UPDATE LOCAL STATUS
  /// =====================================

  void updateDocumentStatus(
    String id,
    bool verified,
  ) {
    final index =
        documents.indexWhere(
      (doc) => doc["id"] == id,
    );

    if (index != -1) {
      documents[index]["verified"] =
          verified;

      setState(() {});
    }
  }

  /// =====================================
  /// REJECTION DIALOG
  /// =====================================

  void showRejectDialog(
    String id,
  ) {
    final controller =
        TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title:
            const Text(
          "Reject Document",
        ),

        content: TextField(
          controller: controller,

          maxLines: 3,

          decoration:
              const InputDecoration(
            hintText:
                "Enter rejection remarks",
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },

            child:
                const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              Navigator.pop(
                context,
              );

              await rejectDocument(
                id: id,
                remarks:
                    controller.text,
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red,
            ),

            child:
                const Text(
              "Reject",
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(
    bool verified,
  ) {
    return verified
        ? Colors.green
        : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final user =
        widget.student["user"];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        title: Text(
          "${user["fullName"]} Documents",
        ),

        backgroundColor:
            AppColors.primary,

        foregroundColor:
            Colors.white,
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : documents.isEmpty
              ? const Center(
                  child: Text(
                    "No documents uploaded",
                  ),
                )

              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  itemCount:
                      documents.length,

                  itemBuilder:
                      (_, index) {
                    final doc =
                        documents[index];

                    final verified =
                        doc["verified"] ==
                            true;

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 18,
                      ),

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          /// TOP
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.all(
                                  14,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: AppColors
                                      .primary
                                      .withValues(
                                        alpha:
                                            0.1,
                                      ),

                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .description_rounded,

                                  color:
                                      AppColors.primary,
                                ),
                              ),

                              const SizedBox(
                                width: 14,
                              ),

                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Text(
                                      doc["documentType"] ??
                                          "-",

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            18,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height:
                                          6,
                                    ),

                                    Text(
                                      verified
                                          ? "Verified"
                                          : "Pending Verification",

                                      style:
                                          TextStyle(
                                        color:
                                            getStatusColor(
                                          verified,
                                        ),

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// URL
                          GestureDetector(
                            onTap: () async {
                              final url =
                                  doc["documentUrl"];

                              if (url == null ||
                                  url.isEmpty) {
                                return;
                              }

                              final uri =
                                  Uri.parse(url);

                              await launchUrl(
                                uri,
                                mode:
                                    LaunchMode.externalApplication,
                              );
                            },

                            child: Row(
                              children: [
                                const Icon(
                                  Icons.link,
                                  size: 18,
                                  color:
                                      Color.fromARGB(255, 30, 95, 50),
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                const Text(
                                  "Open Document",

                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,

                                    color:
                                        Colors.blue,

                                    decoration:
                                        TextDecoration
                                            .underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),

                          /// ACTIONS
                          /// ACTIONS
Column(
  children: [
    /// VIEW DOCUMENT
    SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed: () {
          final url =
              doc["documentUrl"];

          showDialog(
            context: context,

            builder:
                (_) => AlertDialog(
              title:
                  const Text(
                "Document URL",
              ),

              content: SelectableText(
                url ?? "-",
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  child:
                      const Text(
                    "Close",
                  ),
                ),
              ],
            ),
          );
        },

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.primary,
        ),

        icon: const Icon(
          Icons.remove_red_eye,
        ),

        label: const Text(
          "View Document",
        ),
      ),
    ),

    const SizedBox(
      height: 14,
    ),

    /// APPROVE / REJECT
    Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              approveDocument(
                doc["id"],
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.green,
            ),

            child:
                const Text(
              "Approve",
            ),
          ),
        ),

        const SizedBox(
          width: 14,
        ),

        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showRejectDialog(
                doc["id"],
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red,
            ),

            child:
                const Text(
              "Reject",
            ),
          ),
        ),
      ],
    ),
  ],
),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color:
              AppColors.primary,
        ),

        const SizedBox(
          width: 10,
        ),

        Text(
          "$title: ",

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        Expanded(
          child: Text(
            value,
          ),
        ),
      ],
    );
  }
}