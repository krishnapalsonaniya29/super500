import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';

import 'mentor_detail_screen.dart';

class PendingMentorsScreen extends StatefulWidget {
  const PendingMentorsScreen({super.key});

  @override
  State<PendingMentorsScreen> createState() => _PendingMentorsScreenState();
}

class _PendingMentorsScreenState extends State<PendingMentorsScreen> {
  List mentors = [];

  bool loading = true;

  bool actionLoading = false;

  @override
  void initState() {
    super.initState();

    fetchPendingMentors();
  }

  /// =====================================
  /// FETCH PENDING
  /// =====================================

  Future<void> fetchPendingMentors() async {
    try {
      setState(() {
        loading = true;
      });

      final response = await AdminService.getMentors();

      final allMentors = response["data"] ?? [];

      mentors = allMentors
          .where((mentor) => mentor["verificationStatus"] != "APPROVED")
          .toList();
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

  /// =====================================
  /// VERIFY
  /// =====================================

  Future<void> verifyMentor(String id) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService.verifyMentor(id);

      await fetchPendingMentors();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,

          content: Text("Mentor verified successfully"),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          actionLoading = false;
        });
      }
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "REJECTED":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Pending Mentors"),

        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : mentors.isEmpty
          ? const Center(child: Text("No pending mentors"))
          : ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: mentors.length,

              itemBuilder: (_, index) {
                final mentor = mentors[index];

                final user = mentor["user"];

                final status = mentor["verificationStatus"] ?? "PENDING";

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,

                            backgroundColor: AppColors.primary,

                            child: Text(
                              user["fullName"][0].toUpperCase(),

                              style: const TextStyle(
                                color: Colors.white,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  user["fullName"],

                                  style: const TextStyle(
                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(mentor["district"] ?? "-"),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,

                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: getStatusColor(
                                status,
                              ).withValues(alpha: 0.1),

                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: Text(
                              status,

                              style: TextStyle(
                                color: getStatusColor(status),

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: actionLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MentorDetailScreen(
                                            mentor: mentor,
                                          ),
                                        ),
                                      );
                                    },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),

                              child: const Text("View Details"),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: ElevatedButton(
                              onPressed: actionLoading
                                  ? null
                                  : () {
                                      verifyMentor(mentor["id"]);
                                    },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),

                              child: const Text("Approve"),
                            ),
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
}
