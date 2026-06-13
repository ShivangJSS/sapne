import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:trikal_up/Common/DatabaseHelper.dart';
import 'package:trikal_up/Common/SharedPreferHelper.dart';
import 'package:trikal_up/Dashboard/Manage_Family/family_list.dart';

import '../../Common/BrandColors.dart';
import '../../Modals/panchayet_list.dart';
import '../../Modals/village_list.dart';
import '../HomeScreen/HomeScreen.dart';

class PanchayetList extends StatefulWidget {
  const PanchayetList({super.key});

  @override
  State<PanchayetList> createState() => _PanchayetListState();
}

class _PanchayetListState extends State<PanchayetList> {
  List<PanchayatList> panchayat = [];
  List<VillageList> villages = [];
  Map<String, List<VillageList>> villageMap = {};
  int? expandedIndex;
  String languageId = "";
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPanchayatsWithVillages();
  }

  Future<void> loadPanchayatsWithVillages() async {
    languageId = await SharedPreferHelper.getPrefString("languageId", "");
    print('languageId $languageId');
    // Load panchayats
    setState(() {
      _isLoading = true;
    });
    List<PanchayatList> listPanchayat = await DatabaseHelper.instance
        // .SelectData("SELECT * FROM panchayat_list where lang_id=$languageId",
        .SelectData("SELECT * FROM panchayat_list",
            (map) => PanchayatList.fromMap(map));

    // Load all villages
    List<VillageList> allVillages = await DatabaseHelper.instance.SelectData(
        // "SELECT * FROM village_list where lang_id=$languageId",
        "SELECT * FROM village_list",
        (map) => VillageList.fromMap(map));

    // Group villages by gp_lgd_code
    villageMap = {};
    for (var v in allVillages) {
      if (v.gp_lgd_code != null) {
        if (villageMap.containsKey(v.gp_lgd_code)) {
          villageMap[v.gp_lgd_code]!.add(v);
        } else {
          villageMap[v.gp_lgd_code!] = [v];
        }
      }
    }

    setState(() {
      panchayat = listPanchayat;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
          return false;
        },
        child: Scaffold(
            backgroundColor: BrandColors.appbackgroundColor,
            // backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: BrandColors.appColor,
              elevation: 2,
              automaticallyImplyLeading: false,
              leadingWidth: 40,
              titleSpacing: 0,
              title: Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  ),
                  Expanded(
                    // ⭐ important
                    child: Text(
                      "punch_apptext".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis, // ⭐ prevent overflow
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
            body:  RefreshIndicator(
                    onRefresh: loadPanchayatsWithVillages,
                    child: _isLoading
                        ? const SizedBox()
                        : panchayat.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(height: 200),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/lootie.png",
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "No Panchayat found",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: panchayat.length,
                                itemBuilder: (context, index) {
                                  final p = panchayat[index];
                                  final isExpanded = expandedIndex == index;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                          leading: CircleAvatar(
                                            backgroundColor: BrandColors
                                                .applightColor1
                                                .withOpacity(0.15),
                                            child: Image.asset(
                                                "assets/village.png"),
                                          ),
                                          title: Text(
                                            p.gp_name ?? "",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: AnimatedRotation(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            turns: isExpanded
                                                ? 0.5
                                                : 0, // arrow rotation
                                            child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 28),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              expandedIndex =
                                                  isExpanded ? null : index;
                                            });
                                          },
                                        ),

                                        // ✅ Expansion area
                                        AnimatedCrossFade(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          crossFadeState: isExpanded
                                              ? CrossFadeState.showFirst
                                              : CrossFadeState.showSecond,
                                          firstChild: Column(
                                            children:
                                                (villageMap[p.gp_lgd_code] ??
                                                        [])
                                                    .map<Widget>((village) {
                                              return InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                onTap: () {
                                                  Get.to(() => FamilyList(
                                                      villLgdCode: village
                                                          .village_lgd_code!,
                                                      fromDashboard: false));
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 30,
                                                      right: 30,
                                                      bottom: 10),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14,
                                                      vertical: 12),
                                                  decoration: BoxDecoration(
                                                    color: BrandColors
                                                        .appbackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/Village3.png",
                                                        width: 32,
                                                        height: 32,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          village.village_name ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 18,
                                                          color: Colors.grey),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          secondChild: const SizedBox.shrink(),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ))));
  }

  // Widget _buildActivityCard({
  //   required String title,
  //   required IconData icon,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(20),
  //     child: Card(
  //       elevation: 6,
  //       shadowColor: Colors.black.withOpacity(0.1),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //           gradient: LinearGradient(
  //             colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //           ),
  //         ),
  //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
  //         child: Row(
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: BrandColors.appColor,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               padding: const EdgeInsets.all(12),
  //               child: Icon(icon, color: Colors.white, size: 26),
  //             ),
  //             const SizedBox(width: 16),
  //             Expanded(
  //               child: Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w600,
  //                   letterSpacing: 0.3,
  //                 ),
  //               ),
  //             ),
  //             const Icon(Icons.arrow_forward_ios, size: 23, color: Colors.white),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildActivityCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    IconData trailingIcon = Icons.arrow_forward_ios, // default
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // gradient: LinearGradient(
            //   colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: BrandColors.appgreenColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: BrandColors.appColor,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Icon(trailingIcon, size: 28, color: BrandColors.appColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVillageCard(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: BrandColors.applightColor.withOpacity(0.8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.villa, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
