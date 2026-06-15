import 'package:flutter/material.dart';

import '../../../../../services/admin/admin_service.dart';

import '../../../../../theme/app_colors.dart';
import 'pending_mentors_screen.dart';
import 'mentor_detail_screen.dart';
class MentorsScreen
    extends StatefulWidget {
  final Function(int index)
      onNavigate;

  const MentorsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<MentorsScreen>
      createState() =>
          _MentorsScreenState();
}

class _MentorsScreenState
    extends State<
        MentorsScreen> {
  List mentors = [];

  List filteredMentors = [];

  bool loading = true;

  bool actionLoading = false;

  String searchQuery = "";

  String? errorMessage;

  final searchController =
      TextEditingController();

  /// PAGINATION
  int currentPage = 1;

  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();

    fetchMentors();
  }


  /// =====================================
  /// FETCH MENTORS
  /// =====================================

  Future<void> fetchMentors() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final response =
          await AdminService
              .getMentors();

      mentors =
          response["data"] ?? [];

      applySearch();
    } catch (e) {
  debugPrint(
    "GET MENTORS ERROR => $e",
  );

  if (mounted) {
    setState(() {
      errorMessage = e.toString();
    });
  }
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
    filteredMentors =
        mentors.where((mentor) {
      // final user = mentor["user"];
      final user =
        mentor["user"] ??
        <String, dynamic>{};

      final name =
    (user["fullName"] ?? "")
        .toString()
        .toLowerCase();

      final phone =
          (user["phone"] ?? "")
              .toString();

      final district =
          (mentor["district"] ?? "")
              .toString()
              .toLowerCase();

      return name.contains(
            searchQuery.toLowerCase(),
          ) ||
          phone.contains(
            searchQuery,
          ) ||
          district.contains(
            searchQuery.toLowerCase(),
          );
    }).toList();

    currentPage = 1;

    setState(() {});
  }

  /// =====================================
  /// PAGINATION
  /// =====================================

  int get totalPages =>
      (filteredMentors.length /
              itemsPerPage)
          .ceil();

  List get paginatedMentors {
    final start =
        (currentPage - 1) *
            itemsPerPage;

    int end =
        start + itemsPerPage;

    if (end >
        filteredMentors.length) {
      end =
          filteredMentors.length;
    }

    return filteredMentors.sublist(
      start,
      end,
    );
  }

  /// =====================================
  /// VERIFY MENTOR
  /// =====================================

  Future<void> verifyMentor(
    String id,
  ) async {
    try {
      setState(() {
        actionLoading = true;
      });

      await AdminService
          .verifyMentor(id);

      await fetchMentors();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "Mentor verified successfully",
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
            "Failed to verify mentor",
          ),
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

  Color getStatusColor(
    String status,
  ) {
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
      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            /// ERROR
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                      children: [
                        const Icon(
                          Icons.error,
                          color:
                              Colors.red,
                          size: 70,
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        Text(
                          errorMessage!,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        ElevatedButton(
                          onPressed:
                              fetchMentors,

                          child:
                              const Text(
                            "Retry",
                          ),
                        ),
                      ],
                    ),
                  )

                /// SUCCESS
                : RefreshIndicator(
                    onRefresh:
                        fetchMentors,

                    child:
                        SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          /// HEADER
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.only(bottom: 20),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.25),
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "assets/images/app_logo2.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "District Mentors",
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "${filteredMentors.length} mentors available",
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

const SizedBox(height: 20),

Row(
  children: [
    Expanded(
      child: buildStatCard(
        "Total",
        "${mentors.length}",
        Icons.groups,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: buildStatCard(
        "Approved",
        "${mentors.where(
          (e) =>
              e["verificationStatus"] ==
              "APPROVED",
        ).length}",
        Icons.verified,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: buildStatCard(
        "Pending",
        "${mentors.where(
          (e) =>
              e["verificationStatus"] ==
              "PENDING",
        ).length}",
        Icons.pending_actions,
      ),
    ),
  ],
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
                              hintText:
                                  "Search by name, phone or district",
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.primary,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          Container(
                            margin:
                                const EdgeInsets.only(
                              top: 16,
                              bottom: 20,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 54,
                          

                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            const PendingMentorsScreen(),
                                  ),
                                );

                                fetchMentors();
                              },

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:AppColors.primary,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                ),
                              ),

                              icon: const Icon(
                                Icons.pending_actions,
                              ),

                              label: const Text(
                                "Pending Approval Mentors",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                             ),


                         

                          /// EMPTY
                          if (filteredMentors
                              .isEmpty)
                            Container(
                              width:
                                  double.infinity,

                              padding:
                                  const EdgeInsets.all(
                                40,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withOpacity(
                                      0.04,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child:
                                  const Column(
                                children: [
                                  Icon(
                                    Icons
                                        .groups_outlined,
                                    size: 70,
                                    color:
                                        Colors.grey,
                                  ),

                                  SizedBox(
                                    height:
                                        18,
                                  ),

                                  Text(
                                    "No mentors found",

                                    style:
                                        TextStyle(
                                      fontSize:
                                          18,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          /// LIST
                          ListView.builder(
                            shrinkWrap:
                                true,

                            physics:
                                const NeverScrollableScrollPhysics(),

                            itemCount:
                                paginatedMentors
                                    .length,

                            itemBuilder:
                                (_, index) {
                              final mentor =
                                  paginatedMentors[
                                      index];

                              final user =
                                  mentor[
                                      "user"];

                              final status =
                                  mentor["verificationStatus"] ??
                                      "PENDING";

                              final fullName =
                                  (user?["fullName"] as String?)?.trim() ??
                                      "";

                              final avatarLabel =
                                  fullName.isNotEmpty
                                      ? fullName[0].toUpperCase()
                                      : "?";

                              return Container(
                                margin:
                                    const EdgeInsets.only(
                                  bottom:
                                      18,
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

                                child:
                                    Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius:
                                              28,

                                          backgroundColor:
                                              AppColors.primary,

                                          child:
                                              Text(
                                            avatarLabel,

                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white,

                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          width:
                                              14,
                                        ),

                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                fullName.isNotEmpty
                                                    ? fullName
                                                    : "Unknown Mentor",

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
                                                mentor["district"] ??
                                                    "-",
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal:
                                                12,

                                            vertical:
                                                6,
                                          ),

                                          decoration:
                                              BoxDecoration(
                                            color:
                                                getStatusColor(
                                              status,
                                            ).withValues(
                                              alpha:
                                                  0.1,
                                            ),

                                            borderRadius:
                                                BorderRadius.circular(
                                              16,
                                            ),
                                          ),

                                          child:
                                              Text(
                                            status,

                                            style:
                                                TextStyle(
                                              color:
                                                  getStatusColor(
                                                status,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height:
                                          20,
                                    ),

                                    buildInfoRow(
                                      icon:
                                          Icons.phone,
                                      title:
                                          "Phone",
                                      value:
                                          user["phone"] ??
                                              "-",
                                    ),

                                    const SizedBox(
                                      height:
                                          10,
                                    ),

                                    buildInfoRow(
                                      icon:
                                          Icons.school,
                                      title:
                                          "Students Assigned",
                                      value:
                                          (mentor["students"] as List?)
                                                  ?.length
                                                  .toString() ??
                                              "0",
                                    ),

                                    const SizedBox(
                                      height:
                                          10,
                                    ),

                                    buildInfoRow(
                                      icon:
                                          Icons.location_city,
                                      title:
                                          "District",
                                      value:
                                          mentor["district"] ??
                                              "-",
                                    ),

                                    const SizedBox(
                                      height:
                                          22,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () {
                                              print(mentor);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      MentorDetailScreen(
                                                    mentor: mentor,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.visibility,
                                            ),
                                            label: const Text(
                                              "View Details",
                                            ),
                                          ),
                                        ),

                                        if (status != "APPROVED")
                                          const SizedBox(width: 12),

                                        if (status != "APPROVED")
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: actionLoading
                                                  ? null
                                                  : () {
                                                      verifyMentor(
                                                        mentor["id"],
                                                      );
                                                    },
                                              style:
                                                  ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green,
                                              ),
                                              child: const Text(
                                                "Verify",
                                                style:  TextStyle(
                                                  color: Colors.white,
                                                )
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          /// PAGINATION
                          if (totalPages > 1)
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,

                              children: [
                                IconButton(
                                  onPressed:
                                      currentPage >
                                              1
                                          ? () {
                                              setState(() {
                                                currentPage--;
                                              });
                                            }
                                          : null,

                                  icon:
                                      const Icon(
                                    Icons
                                        .chevron_left,
                                  ),
                                ),

                                Text(
                                  "$currentPage / $totalPages",

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                IconButton(
                                  onPressed:
                                      currentPage <
                                              totalPages
                                          ? () {
                                              setState(() {
                                                currentPage++;
                                              });
                                            }
                                          : null,

                                  icon:
                                      const Icon(
                                    Icons
                                        .chevron_right,
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

Widget buildStatCard(
  String title,
  String value,
  IconData icon,
) {
  return Container(
    padding:
        const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
        ),

        const SizedBox(height: 8),

        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        Text(
          title,
          style: const TextStyle(
            color:
                AppColors.textSecondary,
          ),
        ),
      ],
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