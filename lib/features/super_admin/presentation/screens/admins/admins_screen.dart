import 'package:flutter/material.dart';

import '../../../../../services/super_admin/super_admin_service.dart';
import '../../../../../theme/app_colors.dart';

import 'create_admin_screen.dart';

class AdminsScreen extends StatefulWidget {
  final Function(int index) onNavigate;

  const AdminsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AdminsScreen> createState() =>
      _AdminsScreenState();
}

class _AdminsScreenState
    extends State<AdminsScreen> {
  List admins = [];

  List filteredAdmins = [];

  bool loading = true;

  bool deleting = false;

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

    fetchAdmins();
  }

  /// =====================================
  /// FETCH ADMINS
  /// =====================================

  Future<void> fetchAdmins() async {
    try {
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final response =
          await SuperAdminService
              .getAdmins();

      final data =
          response["data"] ?? [];

      admins = data;

      applySearch();
    } catch (e) {
      debugPrint(e.toString());

      errorMessage =
          "Failed to load admins";
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
    filteredAdmins =
        admins.where((admin) {
      final user = admin["user"];

      final name =
          (user["fullName"] ?? "")
              .toString()
              .toLowerCase();

      final district =
          (admin["district"] ?? "")
              .toString()
              .toLowerCase();

      final phone =
          (user["phone"] ?? "")
              .toString();

      return name.contains(
            searchQuery.toLowerCase(),
          ) ||
          district.contains(
            searchQuery.toLowerCase(),
          ) ||
          phone.contains(
            searchQuery,
          );
    }).toList();

    currentPage = 1;

    setState(() {});
  }

  /// =====================================
  /// PAGINATION
  /// =====================================

  int get totalPages =>
      (filteredAdmins.length /
              itemsPerPage)
          .ceil();

  List get paginatedAdmins {
    final start =
        (currentPage - 1) *
            itemsPerPage;

    int end =
        start + itemsPerPage;

    if (end >
        filteredAdmins.length) {
      end = filteredAdmins.length;
    }

    return filteredAdmins.sublist(
      start,
      end,
    );
  }

  /// =====================================
  /// DELETE ADMIN
  /// =====================================

  Future<void> deleteAdmin(
    String id,
  ) async {
    try {
      setState(() {
        deleting = true;
      });

      await SuperAdminService
          .deleteAdmin(id);

      await fetchAdmins();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          backgroundColor:
              Colors.green,
          content: Text(
            "Admin deleted successfully",
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
            "Failed to delete admin",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          deleting = false;
        });
      }
    }
  }

  /// =====================================
  /// CONFIRM DELETE
  /// =====================================

  void confirmDelete(
    String id,
    String name,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title:
            const Text(
          "Delete Admin",
        ),
        content: Text(
          "Are you sure you want to delete $name?",
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

              await deleteAdmin(
                id,
              );
            },
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red,
            ),
            child:
                const Text(
              "Delete",
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(
    bool active,
  ) {
    return active
        ? Colors.green
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor:
            AppColors.primary,

        onPressed: () async {
          final created =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      const CreateAdminScreen(),
            ),
          );

          if (created == true) {
            fetchAdmins();
          }
        },

        icon: const Icon(
          Icons.add,
        ),

        label: const Text(
          "Create Admin",
          style : TextStyle(
            color: Colors.white,
          )
        ),
      ),

      body: SafeArea(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            /// ERROR STATE
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
                          size: 60,
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
                              fetchAdmins,
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
                        fetchAdmins,

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
                                        "District Wise Admin Management",
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

                          /// SEARCH
                          TextField(
                            controller:
                                searchController,

                            onChanged:
                                (value) {
                              searchQuery =
                                  value;

                              applySearch();
                            },

                            decoration:
                                InputDecoration(
                              hintText:
                                  "Search admin, district, phone",

                              prefixIcon:
                                  const Icon(
                                Icons.search,
                              ),

                              filled: true,

                              fillColor:
                                  Colors.white,

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          /// EMPTY
                          if (filteredAdmins
                              .isEmpty)
                            Container(
                              width:
                                  double.infinity,

                              padding:
                                  const EdgeInsets.all(
                                40,
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
                                  const Column(
                                children: [
                                  Icon(
                                    Icons
                                        .search_off_rounded,
                                    size: 70,
                                    color:
                                        Colors.grey,
                                  ),
                                  SizedBox(
                                    height:
                                        18,
                                  ),
                                  Text(
                                    "No admins found",
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
                                paginatedAdmins
                                    .length,

                            itemBuilder:
                                (_, index) {
                              final admin =
                                  paginatedAdmins[
                                      index];

                              final user =
                                  admin[
                                      "user"];

                              final active =
                                  user["isActive"] ??
                                      true;

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
                                            user["fullName"][0],
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
                                                user["fullName"],
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
                                                admin["district"] ??
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
                                              active,
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
                                            active
                                                ? "Active"
                                                : "Inactive",
                                            style:
                                                TextStyle(
                                              color:
                                                  getStatusColor(
                                                active,
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
                                          "Students",
                                      value:
                                          admin["studentCount"]
                                              .toString(),
                                    ),

                                    const SizedBox(
                                      height:
                                          10,
                                    ),

                                    buildInfoRow(
                                      icon:
                                          Icons.groups,
                                      title:
                                          "Mentors",
                                      value:
                                          admin["mentorCount"]
                                              .toString(),
                                    ),

                                    const SizedBox(
                                      height:
                                          22,
                                    ),

                                    SizedBox(
                                      width:
                                          double.infinity,
                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            deleting
                                                ? null
                                                : () {
                                                    confirmDelete(
                                                      admin["id"],
                                                      user["fullName"],
                                                    );
                                                  },
                                        style:
                                            ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color.fromARGB(255, 228, 46, 33),
                                        ),
                                        child:
                                            const Text(
                                          "Delete Admin",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )
                                        ),
                                      ),
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