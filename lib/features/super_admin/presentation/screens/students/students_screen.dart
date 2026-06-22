import 'package:flutter/material.dart';

import '../../../../../services/super_admin/super_admin_service.dart';
import '../../../../../theme/app_colors.dart';
import 'student_ranking_screen.dart'; 
import 'student_detail_screen.dart';

class StudentsScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const StudentsScreen({super.key, required this.onNavigate});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List students = [];

  List filteredStudents = [];

  bool loading = true;

  final searchController = TextEditingController();

  String selectedDistrict = "All";

  List<String> districts = ["All"];

  @override
  void initState() {
    super.initState();

    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await SuperAdminService.getStudents();

      final data = response["data"] ?? [];

      final districtList = <String>[];

for (final student in data) {
  final district = student["district"]?.toString();

  if (district != null && district.isNotEmpty) {
    districtList.add(district);
  }
}

districts = ["All", ...districtList.toSet()];

      setState(() {
        students = data;

        filteredStudents = data;

        districts = ["All", ...districtList];
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching students: $e"),

          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void filterStudents() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredStudents = students.where((student) {
        final name = student["user"]?["fullName"] ?? "";

        final district = student["district"] ?? "";

        final matchesSearch = name.toLowerCase().contains(query);

        final matchesDistrict =
            selectedDistrict == "All" || district == selectedDistrict;

        return matchesSearch && matchesDistrict;
      }).toList();
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;

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

      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchStudents,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// HEADER
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary
                                  .withValues(alpha:0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              padding:
                                  const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                                child: Image.asset(
                                  "assets/images/app_logo2.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Super Admin",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Text(
                                    "Manage Students",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${filteredStudents.length} students found",

                        style: const TextStyle(color: AppColors.textSecondary),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.leaderboard,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Super 500 Rankings",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const StudentRankingScreen(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// SEARCH
                      TextField(
                        controller: searchController,

                        onChanged: (_) => filterStudents(),

                        decoration: InputDecoration(
                          hintText: "Search student",

                          prefixIcon: const Icon(Icons.search),

                          filled: true,

                          fillColor: Colors.white,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// DISTRICT FILTER
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedDistrict,

                            isExpanded: true,

                            items: districts.map((district) {
                              return DropdownMenuItem(
                                value: district,

                                child: Text(district),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedDistrict = value!;
                              });

                              filterStudents();
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// EMPTY
                      if (filteredStudents.isEmpty)
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(40),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: const Column(
                            children: [
                              Icon(
                                Icons.school_rounded,

                                size: 70,

                                color: Colors.grey,
                              ),

                              SizedBox(height: 18),

                              Text(
                                "No students found",

                                style: TextStyle(
                                  fontSize: 18,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      /// STUDENT LIST
                      ListView.builder(
                        shrinkWrap: true,

                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: filteredStudents.length,

                        itemBuilder: (_, index) {
                          final student = filteredStudents[index];

                          final user = student["user"];

                          final status =
                              student["verificationStatus"] ?? "PENDING";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 18),

                            padding: const EdgeInsets.all(18),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),

                                  blurRadius: 10,

                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),

                            child: Column(
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

                                          fontSize: 22,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Text(
                                            user["fullName"],

                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,

                                              fontSize: 18,
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          Text(
                                            student["district"] ??
                                                "No District",

                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,

                                        vertical: 8,
                                      ),

                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          status,
                                        ).withValues(alpha: 0.1),

                                        borderRadius: BorderRadius.circular(20),
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

                                const SizedBox(height: 18),

                                Container(
                                  width: double.infinity,

                                  padding: const EdgeInsets.all(16),

                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.04,
                                    ),

                                    borderRadius: BorderRadius.circular(18),
                                  ),

                                  child: Column(
                                    children: [
                                      buildInfoRow(
                                        icon: Icons.phone,

                                        title: "Phone",

                                        value: user["phone"] ?? "-",
                                      ),

                                      const SizedBox(height: 12),

                                      buildInfoRow(
                                        icon: Icons.school,

                                        title: "School",

                                        value: student["schoolName"] ?? "-",
                                      ),

                                      const SizedBox(height: 12),

                                      buildInfoRow(
                                        icon: Icons.grade,

                                        title: "10th Marks",

                                        value: "${student["marks10th"] ?? 0}%",
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,

                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,

                                        MaterialPageRoute(
                                          builder: (_) => StudentDetailScreen(
                                            student: student,
                                          ),
                                        ),
                                      );
                                    },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,

                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),

                                    child: const Text(
                                      "View Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
