import 'package:flutter/material.dart';

import '../../../../../services/super_admin/super_admin_service.dart';
import '../../../../../theme/app_colors.dart';

import 'create_admin_screen.dart';

class AdminsScreen
    extends StatefulWidget {
  final Function(int index)
      onNavigate;

  const AdminsScreen({
    super.key,
    required this.onNavigate,
  });

  @override
  State<AdminsScreen>
      createState() =>
          _AdminsScreenState();
}

class _AdminsScreenState
    extends State<
        AdminsScreen> {
  List admins = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    fetchAdmins();
  }

  Future<void> fetchAdmins()
  async {
    try {
      final response =
          await SuperAdminService
              .getAdmins();

      setState(() {
        admins = response["data"];
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> deleteAdmin(
    String id,
  ) async {
    try {
      await SuperAdminService
          .deleteAdmin(id);

      fetchAdmins();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Admin deleted successfully",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
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
        onPressed: () async {
          await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  const CreateAdminScreen(),
            ),
          );

          fetchAdmins();
        },

        backgroundColor:
            AppColors.primary,

        icon: const Icon(
          Icons.add,
        ),

        label:
            const Text(
          "Create Admin",
        ),
      ),

      body: SafeArea(
        child: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
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
                      const Text(
                        "District Admins",

                        style:
                            TextStyle(
                          fontSize: 30,

                          fontWeight:
                              FontWeight
                                  .bold,

                          fontFamily:
                              'Poppins',
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        "${admins.length} admins managing districts",

                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      /// STATS
                      Row(
                        children: [
                          Expanded(
                            child:
                                buildStatCard(
                              title:
                                  "Total Admins",

                              value:
                                  admins
                                      .length
                                      .toString(),

                              icon: Icons
                                  .admin_panel_settings_rounded,
                            ),
                          ),

                          const SizedBox(
                            width: 16,
                          ),

                          Expanded(
                            child:
                                buildStatCard(
                              title:
                                  "Districts",

                              value:
                                  admins
                                      .length
                                      .toString(),

                              icon: Icons
                                  .location_city_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      /// EMPTY
                      if (admins.isEmpty)
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
                                    .admin_panel_settings_rounded,

                                size: 70,

                                color: Colors
                                    .grey,
                              ),

                              SizedBox(
                                height: 18,
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

                      /// ADMINS LIST
                      ListView.builder(
                        shrinkWrap: true,

                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemCount:
                            admins.length,

                        itemBuilder:
                            (_, index) {
                          final admin =
                              admins[
                                  index];

                          final user =
                              admin[
                                  "user"];

                          final active =
                              user[
                                      "isActive"] ??
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

                              boxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withValues(
                                        alpha:
                                            0.04,
                                      ),

                                  blurRadius:
                                      10,

                                  offset:
                                      const Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),

                            child:
                                Column(
                              children: [
                                /// TOP
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          30,

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

                                          fontSize:
                                              22,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width:
                                          16,
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
                                              fontWeight:
                                                  FontWeight.bold,

                                              fontSize:
                                                  18,
                                            ),
                                          ),

                                          const SizedBox(
                                            height:
                                                6,
                                          ),

                                          Text(
                                            admin["district"] ??
                                                "-",

                                            style:
                                                const TextStyle(
                                              color:
                                                  AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            14,

                                        vertical:
                                            8,
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
                                          20,
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

                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height:
                                      20,
                                ),

                                /// INFO BOX
                                Container(
                                  width:
                                      double.infinity,

                                  padding:
                                      const EdgeInsets.all(
                                    18,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color: AppColors
                                        .primary
                                        .withValues(
                                          alpha:
                                              0.05,
                                        ),

                                    borderRadius:
                                        BorderRadius.circular(
                                      18,
                                    ),
                                  ),

                                  child:
                                      Column(
                                    children: [
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
                                            14,
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
                                            14,
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
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      20,
                                ),

                                /// ACTIONS
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            () {},

                                        style:
                                            ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primary,

                                          padding:
                                              const EdgeInsets.symmetric(
                                            vertical:
                                                14,
                                          ),

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),

                                        child:
                                            const Text(
                                          "View",
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width:
                                          14,
                                    ),

                                    Expanded(
                                      child:
                                          ElevatedButton(
                                        onPressed:
                                            () {
                                          deleteAdmin(
                                            admin["id"],
                                          );
                                        },

                                        style:
                                            ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.red,

                                          padding:
                                              const EdgeInsets.symmetric(
                                            vertical:
                                                14,
                                          ),

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),

                                        child:
                                            const Text(
                                          "Delete",
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
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
                  alpha: 0.05,
                ),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

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
                    alpha: 0.1,
                  ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              icon,

              color:
                  AppColors.primary,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 30,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            title,

            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
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