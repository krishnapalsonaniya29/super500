import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

class PendingDocumentsScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const PendingDocumentsScreen({super.key, required this.onNavigate});

  @override
  State<PendingDocumentsScreen> createState() => _PendingDocumentsScreenState();
}

class _PendingDocumentsScreenState extends State<PendingDocumentsScreen> {
  List documents = [];

  List filteredDocuments = [];

  bool loading = true;

  bool actionLoading = false;

  String searchQuery = "";

  String? errorMessage;

  final searchController = TextEditingController();

  /// PAGINATION
  int currentPage = 1;

  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();

    fetchDocuments();
  }

  /// =====================================
  /// FETCH DOCUMENTS
  /// =====================================

  Future<void> fetchDocuments() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final response = await AdminService.getStudents();

      final students = response["data"] ?? [];

      List pendingDocs = [];

      for (final student in students) {
        final studentDocs = student["documents"] ?? [];

        for (final doc in studentDocs) {
          if (doc["verified"] != true) {
            pendingDocs.add({...doc, "student": student});
          }
        }
      }

      documents = pendingDocs;

      applySearch();
    } catch (e) {
      debugPrint(e.toString());

      errorMessage = "Failed to load documents";
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  /// =====================================
  /// SEARCH
  /// =====================================

  void applySearch() {
    filteredDocuments = documents.where((doc) {
      final student = doc["student"];

      final user = student["user"];

      final name = (user["fullName"] ?? "").toString().toLowerCase();

      final type = (doc["documentType"] ?? "").toString().toLowerCase();

      return name.contains(searchQuery.toLowerCase()) ||
          type.contains(searchQuery.toLowerCase());
    }).toList();

    currentPage = 1;

    setState(() {});
  }

  /// =====================================
  /// PAGINATION
  /// =====================================

  int get totalPages => (filteredDocuments.length / itemsPerPage).ceil();

  List get paginatedDocuments {
    final start = (currentPage - 1) * itemsPerPage;

    int end = start + itemsPerPage;

    if (end > filteredDocuments.length) {
      end = filteredDocuments.length;
    }

    return filteredDocuments.sublist(start, end);
  }

  /// =====================================
  /// APPROVE DOCUMENT
  /// =====================================

  Future<void> approveDocument(String id) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService.approveDocument(id);

      await fetchDocuments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,

          content: Text("Document approved successfully"),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,

          content: Text("Failed to approve document"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          actionLoading = false;
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
        actionLoading = true;
      });

      await AdminService.rejectDocument(id: id, remarks: remarks);

      await fetchDocuments();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,

          content: Text("Document rejected"),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,

          content: Text("Failed to reject document"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          actionLoading = false;
        });
      }
    }
  }

  /// =====================================
  /// REJECTION DIALOG
  /// =====================================

  void showRejectDialog(String id) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reject Document"),

        content: TextField(
          controller: controller,

          maxLines: 3,

          decoration: const InputDecoration(
            hintText: "Enter rejection remarks",
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await rejectDocument(id: id, remarks: controller.text);
            },

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            /// ERROR
            : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 70),

                    const SizedBox(height: 16),

                    Text(errorMessage!),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: fetchDocuments,

                      child: const Text("Retry"),
                    ),
                  ],
                ),
              )
            /// SUCCESS
            : RefreshIndicator(
                onRefresh: fetchDocuments,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      const Text(
                        "Pending Documents",

                        style: TextStyle(
                          fontSize: 30,

                          fontWeight: FontWeight.bold,

                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${filteredDocuments.length} pending documents",

                        style: const TextStyle(color: AppColors.textSecondary),
                      ),

                      const SizedBox(height: 24),

                      /// SEARCH
                      TextField(
                        controller: searchController,

                        onChanged: (value) {
                          searchQuery = value;

                          applySearch();
                        },

                        decoration: InputDecoration(
                          hintText: "Search documents",

                          prefixIcon: const Icon(Icons.search),

                          filled: true,

                          fillColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// LIST
                      ListView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: paginatedDocuments.length,

                        itemBuilder: (_, index) {
                          final doc = paginatedDocuments[index];

                          final student = doc["student"];

                          final user = student["user"];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 18),

                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(24),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,

                                      backgroundColor: AppColors.primary,

                                      child: Text(
                                        user["fullName"][0],

                                        style: const TextStyle(
                                          color: Colors.white,

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            user["fullName"],

                                            style: const TextStyle(
                                              fontSize: 18,

                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          Text(doc["documentType"] ?? "-"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                buildInfoRow(
                                  icon: Icons.phone,
                                  title: "Phone",
                                  value: user["phone"] ?? "-",
                                ),

                                const SizedBox(height: 10),

                                buildInfoRow(
                                  icon: Icons.description,
                                  title: "Document",
                                  value: doc["documentType"] ?? "-",
                                ),

                                const SizedBox(height: 10),

                                buildInfoRow(
                                  icon: Icons.link,
                                  title: "URL",
                                  value: doc["fileUrl"] ?? "-",
                                ),

                                const SizedBox(height: 22),

                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: actionLoading
                                            ? null
                                            : () {
                                                approveDocument(doc["id"]);
                                              },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),

                                        child: const Text("Approve"),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: actionLoading
                                            ? null
                                            : () {
                                                showRejectDialog(doc["id"]);
                                              },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),

                                        child: const Text("Reject"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      /// PAGINATION
                      if (totalPages > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            IconButton(
                              onPressed: currentPage > 1
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,

                              icon: const Icon(Icons.chevron_left),
                            ),

                            Text(
                              "$currentPage / $totalPages",

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              onPressed: currentPage < totalPages
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,

                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
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
        Icon(icon, size: 18, color: AppColors.primary),

        const SizedBox(width: 10),

        Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),

        Expanded(child: Text(value)),
      ],
    );
  }
}
