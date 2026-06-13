import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trikal_up/Common/BrandColors.dart';
import 'package:http/http.dart' as http;
import 'package:trikal_up/Dashboard/Manage_Family/family_list.dart';
import '../../Common/DatabaseHelper.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Modals/AspirationModel.dart';
import '../../Modals/FeedBackModel.dart';
import '../../Modals/panchayet_list.dart';
import '../../Modals/village_list.dart';
import 'HomeScreen.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  List<Map<String, dynamic>> chartData = [];
  List<Map<String, dynamic>> chartData1 = [];

  List<Map<String, dynamic>> vill = [];
  List<Map<String, dynamic>> gp = [];
  String? selectedVillage;
  String? selectedGP;
  int feedbackPartially = 0;
  int feedbackCompleted = 0;
  int feedbackPendingNew = 0;
  int countAssignList = 0;
  int countPersonalList = 0;
  int countSocialList = 0;
  int countFamilyList = 0;
  int countOtherList = 0;
  int countAspWithoutFeedback = 0;
  int countAspWithFeedback = 0;
  int countWithoutAspirationAndFeedback = 0;
  String? selectedYear;

  int completedCount = 0, partiallyCount = 0, pending = 0;
  String languageId = "";
  Map<String, List<VillageList>> villageMap = {};
  List<PanchayatList> panchayat = [];
  List<String> months = []; // declare only
  @override
  void initState() {
    super.initState();
    feedbackCompleted = 0;
    selectedYear = DateTime.now().year.toString();
    countParticipantsWithFeedback();
    loadPanchayatsWithVillages();
    months = getLast1Year();
  }

  double getCleanInterval(double maxY) {
    if (maxY <= 100) return 20;
    if (maxY <= 300) return 50;
    if (maxY <= 600) return 100;
    if (maxY <= 1200) return 200;
    if (maxY <= 2000) return 250;
    return 500;
  }

  double getDynamicMaxY() {
    if (chartData1.isEmpty) return 100;

    double maxValue = chartData1
        .map((e) => (e["value"] ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b);

    // Add 20% padding
    double paddedValue = maxValue * 1.2;

    // Round to nearest 100
    double cleanMax = (paddedValue / 100).ceil() * 100;

    // Minimum 100
    if (cleanMax < 100) return 100;

    return cleanMax;
  }



  void loadPanchayatsWithVillages() async {
    languageId = await SharedPreferHelper.getPrefString("languageId", "");
    print('languageId $languageId');
    // Load panchayats
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
    });
  }

  // Future<void> countParticipantsWithFeedback({String? gpCode, String? villageId}) async {
  //   try {
  //     setState(() {
  //       countAssignList = 0;
  //       countPersonalList = 0;
  //       countSocialList = 0;
  //       countFamilyList = 0;
  //       countOtherList = 0;
  //       countAspWithoutFeedback = 0;
  //       countAspWithFeedback = 0;
  //       countWithoutAspirationAndFeedback = 0;
  //     });
  //
  //     await fmlylistcontroller.getAllParticipant();
  //
  //     if (fmlylistcontroller.participantListDashboard.isNotEmpty) {
  //       var filteredParticipants = fmlylistcontroller.participantListDashboard.where((p) {
  //         bool matchesGP = gpCode == null || gpCode.isEmpty || p.gram_panchayat_lgd_code == gpCode;
  //         bool matchesVillage = villageId == null || villageId.isEmpty || p.village_lgd_code == villageId;
  //         return matchesGP && matchesVillage;
  //       }).toList();
  //
  //       countAssignList = filteredParticipants.length;
  //
  //       for (var participant in filteredParticipants) {
  //         String participantId = participant.p_id.toString();
  //
  //         List<AspirationModel> aspList = await DatabaseHelper.instance.SelectData(
  //           "SELECT * FROM aspiration WHERE participant_id = '$participantId'",
  //               (map) => AspirationModel.fromMap(map),
  //         );
  //
  //         if (aspList.isEmpty) {
  //           countWithoutAspirationAndFeedback++;
  //           continue;
  //         }
  //
  //         bool hasAnyFeedback = false;
  //
  //         for (var asp in aspList) {
  //           if (asp.asp_details_id != null && asp.asp_details_id!.isNotEmpty) {
  //             List<FeedBackModel> fbList = await DatabaseHelper.instance.SelectData(
  //               "SELECT * FROM feedback WHERE aspiration_id = '${asp.asp_details_id}'",
  //                   (map) => FeedBackModel.fromMap(map),
  //             );
  //
  //             if (fbList.isNotEmpty) {
  //               hasAnyFeedback = true;
  //             }
  //           }
  //           String createdAt = asp.created_at ?? "";
  //           String aspYear = createdAt.length >= 4 ? createdAt.substring(0, 4) : "";
  //           if (selectedMonth == null || aspYear == selectedMonth) {
  //             if (asp.asp_cat_id == "2") countFamilyList++;
  //             if (asp.asp_cat_id == "3") countSocialList++;
  //             if (asp.asp_cat_id == "4") countOtherList++;
  //           }
  //         }
  //         if (hasAnyFeedback) {
  //           countAspWithFeedback++; // at least 1 feedback
  //         } else {
  //           countAspWithoutFeedback++; // has aspirations, but no feedback
  //         }
  //       }
  //     }
  //
  //     setState(() {
  //       chartData = [
  //         {"label": "Completed", "value": countAspWithFeedback, "color": Colors.teal},
  //         {"label": "Partially Completed", "value": countAspWithoutFeedback, "color": Colors.pink},
  //         {"label": "Pending", "value": countWithoutAspirationAndFeedback, "color": Colors.purple},
  //         {"label": "Assigned", "value": countAssignList, "color": Colors.blue},
  //       ];
  //       chartData1 = [
  //         {"label": "Personal", "value": countPersonalList, "color": Colors.teal},
  //         {"label": "Family", "value": countFamilyList, "color": Colors.pink},
  //         {"label": "Social", "value": countSocialList, "color": Colors.purple},
  //         {"label": "Other", "value": countOtherList, "color": Colors.blue},
  //       ];
  //     });
  //   } catch (e) {
  //     print("❌ Error while counting participants: $e");
  //   }
  // }

  Future<void> countParticipantsWithFeedback({String? gpCode, String? villageId}) async {
    try {
      setState(() {
        countAssignList = 0;
        countPersonalList = 0;
        countSocialList = 0;
        countFamilyList = 0;
        countOtherList = 0;
        countAspWithoutFeedback = 0; // participants with aspirations
        countAspWithFeedback = 0; // participants with at least 1 feedback
        countWithoutAspirationAndFeedback = 0; // participants with no aspirations
      });

      await fmlylistcontroller.getAllParticipant();

      if (fmlylistcontroller.participantListDashboard.isNotEmpty) {
        var filteredParticipants = fmlylistcontroller.participantListDashboard.where((p) {
          bool matchesGP = gpCode == null || gpCode.isEmpty || p.gram_panchayat_lgd_code == gpCode;
          bool matchesVillage = villageId == null || villageId.isEmpty || p.village_lgd_code == villageId;
          return matchesGP && matchesVillage;
        }).toList();

        countAssignList = filteredParticipants.length;

        for (var participant in filteredParticipants) {
          String participantId = participant.p_id.toString();

          List<AspirationModel> aspList = await DatabaseHelper.instance.SelectData(
            "SELECT * FROM aspiration WHERE participant_id = '$participantId'",
                (map) => AspirationModel.fromMap(map),
          );

          if (aspList.isEmpty) {
            countWithoutAspirationAndFeedback++;
            continue;
          }

          // Participant has at least 1 aspiration
          countAspWithoutFeedback++;

          bool hasFeedback = false;

          for (var asp in aspList) {
            // Count category-specific aspirations
            String createdAt = asp.created_at ?? "";
            print("Participant ${participant.p_id} => asp_id: ${asp.asp_details_id}, created_at: '${asp.created_at}', category: ${asp.asp_cat_id}");

            String aspYear = createdAt.length >= 4 ? createdAt.substring(0, 4) : "";
            print("created_atss: $aspYear}");
            if (selectedYear == null || aspYear == selectedYear) {
              if (asp.asp_cat_id == "1") countPersonalList++;
              if (asp.asp_cat_id == "2") countFamilyList++;
              if (asp.asp_cat_id == "3") countSocialList++;
              if (asp.asp_cat_id == "4") countOtherList++;
              print("------ Aspiration Category Count ------");
              print("asp_cat_id: ${asp.asp_cat_id}");
              print("created_at: ${asp.created_at}");
              print("aspYear: $aspYear");
              print("selectedYear: $selectedYear");
              print("----------------");
              print("Personal Count: $countPersonalList");
              print("Family Count: $countFamilyList");
              print("Social Count: $countSocialList");
              print("Other Count: $countOtherList");
              print("---------------------------------------");
            }

            // Check for feedback
            if (asp.asp_details_id != null && asp.asp_details_id!.isNotEmpty) {
              List<FeedBackModel> fbList = await DatabaseHelper.instance.SelectData(
                "SELECT * FROM feedback WHERE aspiration_id = '${asp.asp_details_id}'",
                    (map) => FeedBackModel.fromMap(map),
              );

              if (fbList.isNotEmpty) {
                hasFeedback = true;
              }
            }
          }

          if (hasFeedback) {
            countAspWithFeedback++; // participant has at least 1 feedback
          }
        }
      }

      setState(() {
        chartData = [
          {"label": "Completed", "value": countAspWithFeedback, "color": Colors.teal.shade300},
          {"label": "With Aspirations", "value": countAspWithoutFeedback, "color": Colors.teal.shade400},
          {"label": "Pending", "value": countWithoutAspirationAndFeedback, "color": Colors.teal.shade200},
          {"label": "Assigned", "value": countAssignList, "color":  BrandColors.appColor},
        ];
        chartData1 = [
          {"label": "Personal", "value": countPersonalList, "color": Colors.purple},
          {"label": "Family", "value": countFamilyList, "color": Colors.purple.shade400},
          {"label": "Social", "value": countSocialList, "color": Colors.purple.shade300},
          {"label": "Other", "value": countOtherList, "color": Colors.purple.shade200},
        ];
      });
    } catch (e) {
      print("❌ Error while counting participants: $e");
    }
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
        appBar: AppBar(
          backgroundColor: BrandColors.appColor,
          elevation: 2,
          automaticallyImplyLeading: false,
          leadingWidth: 40,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
              Text(
                'card_text1'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 19
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Get.offAll(() => HomeScreen());
              },
            ),
          ],
        ),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "program_participant_update".tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Container(
                height: 45,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: BrandColors.appColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                      "add_select_gp".tr,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    value: selectedGP,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,
                        color: BrandColors.appColor),
                    dropdownColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGP = newValue;
                        vill = [];
                        selectedVillage = null;

                        if (newValue != null &&
                            villageMap.containsKey(newValue)) {
                          vill = villageMap[newValue]!
                              .map((v) => {
                            "village_id": v.village_lgd_code,
                            "village_name": v.village_name,
                          })
                              .toList();
                        }
                      });
                      countParticipantsWithFeedback(gpCode: newValue);
                    },
                    items: panchayat.map((p) {
                      return DropdownMenuItem<String>(
                        value: p.gp_lgd_code,
                        child: Text(p.gp_name ?? ""),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                height: 45,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: BrandColors.appColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                      "add_select_village".tr,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    value: selectedVillage,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down,
                        color: BrandColors.appColor),
                    dropdownColor: Colors.white,
                    // onChanged: (String? newValue) {
                    //   setState(() {
                    //     selectedVillage = newValue;
                    //   });
                    //   countParticipantsWithFeedback(
                    //       gpCode: selectedGP, villageId: newValue);
                    // },
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVillage = newValue;
                      });

                      if (selectedGP != null && selectedVillage != null) {
                        countParticipantsWithFeedback(
                          gpCode: selectedGP,
                          villageId: selectedVillage,
                        );
                      }
                    },
                    items: vill.map((r) {
                      return DropdownMenuItem<String>(
                        value: r['village_id'],
                        child: Text(r['village_name']),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // safe maxValue calculation
                    double maxValue;
                    if (chartData.isEmpty) {
                      maxValue = 1.0;
                    } else {
                      maxValue = chartData
                          .map((item) => (item["value"] as num).toDouble())
                          .reduce((a, b) => a > b ? a : b);
                      if (maxValue == 0) maxValue = 1.0;
                    }

                    double maxY = 100; // fixed y axis shown in chart (you're using percent)
                    double barWidth = 35;

                    const double verticalPaddingTop = 8;
                    const double verticalPaddingBottom = 8;
                    const double labelHeight = 16;

                    double chartHeight =
                    (constraints.maxHeight - verticalPaddingTop - verticalPaddingBottom)
                        .clamp(1.0, double.infinity);

                    final int n = chartData.length;
                    return Stack(
                      children: [
                        BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxY,
                            minY: 0,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 5,
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(color: Colors.black.withOpacity(0.5)),
                                bottom: BorderSide(color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 10,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toInt().toString(),
                                    style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            barGroups: List.generate(n, (index) {
                              final actual = (chartData[index]["value"] as num).toDouble();
                              final percentValue = maxValue > 0 ? (actual / maxValue) * 100.0 : 0.0;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: percentValue,
                                    color: chartData[index]["color"],
                                    width: barWidth,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),

                        // percentage labels centered above each bar
                        if (n > 0)

                          ...List.generate(n, (index) {
                            final actual = (chartData[index]["value"] as num).toDouble();
                            final percentValue =
                            maxValue > 0 ? (actual / maxValue) * 100.0 : 0.0;

                            if (percentValue == 0) return const SizedBox.shrink();

                            double barHeightRatio = (percentValue / maxY).clamp(0.0, 1.0);

                            // bar top
                            double barTop = verticalPaddingTop + (1 - barHeightRatio) * chartHeight;

                            double topPos = barTop - labelHeight - 2;
                            if (topPos < 0) topPos = 0;

                            double centerX = constraints.maxWidth * ((index + 0.5) / n);

                            // 🔥 increased right shift
                            const double rightOffset = 10;

                            double labelLeft = centerX - (barWidth / 2) + rightOffset;

                            if (labelLeft < 0) labelLeft = 0;
                            if (labelLeft + barWidth > constraints.maxWidth) {
                              labelLeft = constraints.maxWidth - barWidth;
                            }

                            return Positioned(
                              left: labelLeft,
                              top: topPos,
                              child: SizedBox(
                                width: barWidth,
                                height: labelHeight,
                                child: Center(
                                  child: Text(
                                    "${percentValue.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 2),
              // Text(
              //   "current_status".tr,
              //   style:
              //   const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              //   textAlign: TextAlign.center,
              // ),
              // Legend below Pie Chart

              const SizedBox(height: 8),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     buildLegend(Colors.teal, "aspiration_identification_bucketing_feedback_collected".tr),
              //     buildLegend(Colors.pink, "aspirations_identification_done_but_feedback_pending".tr),
              //     buildLegend(Colors.purple, "pending".tr),
              //     buildLegend(Colors.blue, "assigned".tr),
              //   ],
              // ),

              const SizedBox(height: 20),
              buildCard("participant_assigned".tr, countAssignList.toString(),
                  BrandColors.appColor, () {
                    // Get.to(() => FamilyList(villLgdCode: "", fromDashboard: true)); // <-- yeh change
                  }),

              SizedBox(height: 6),
              buildCard(
                  "aspirations_identification_done_but_feedback_pending".tr,
                  countAspWithoutFeedback.toString(),
                  Colors.teal.shade400, () {
                // Get.to(()=>FilterParticipant());
                if (selectedGP != null &&
                    (selectedVillage == null || selectedVillage!.isEmpty)) {
                  Get.snackbar(
                    "add_select_village".tr,
                    "select_village".tr,
                    snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white
                  );
                  return;
                }


                Get.to(() => FamilyList(villLgdCode: selectedVillage ?? "", fromDashboard: true, isAspirNotFeed: true));
              }),
              const SizedBox(height: 6),
              buildCard(
                  "aspiration_identification_bucketing_feedback_collected".tr,
                  countAspWithFeedback.toString(),
                  Colors.teal.shade300, () {
                if (selectedGP != null &&
                    (selectedVillage == null || selectedVillage!.isEmpty)) {
                  Get.snackbar(
                      "add_select_village".tr,
                      "select_village".tr,
                    snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white
                  );
                  return;
                }


                Get.to(() => FamilyList(villLgdCode: selectedVillage ?? "", fromDashboard: true,  Feed: true));
              }),

              const SizedBox(height: 6),
              buildCard("all_actions_pending".tr,
                  countWithoutAspirationAndFeedback.toString(), Colors.teal.shade200, () {
                    if (selectedGP != null &&
                        (selectedVillage == null || selectedVillage!.isEmpty)) {
                      Get.snackbar(
                          "add_select_village".tr,
                          "select_village".tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white
                      );
                      return;
                    }


                    Get.to(() => FamilyList(villLgdCode: selectedVillage ?? "", fromDashboard: true, pending : true));
                  }),

              const SizedBox(height: 33),

              Column(
                children: [
                  buildYearFilter(months),

                  const SizedBox(height: 33),
                  SizedBox(
                    height: 220,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double maxY = getDynamicMaxY();
                        double barWidth = 35;

                        return Stack(
                          children: [
                            BarChart(
                              BarChartData(
                                maxY: maxY,
                                minY: 0,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  // horizontalInterval: maxY / 6,
                                  horizontalInterval: getCleanInterval(maxY),

                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    left: BorderSide(color: Colors.black54),
                                    bottom: BorderSide(color: Colors.black54),
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      // interval: maxY / 6,
                                      interval: getCleanInterval(maxY),

                                      getTitlesWidget: (val, meta) => Text(
                                        val.toInt().toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  bottomTitles:
                                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles:
                                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles:
                                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                barGroups: List.generate(chartData1.length, (index) {
                                  final d = chartData1[index];
                                  final value = (d["value"] ?? 0).toDouble();
                                  final color = d["color"];

                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        // toY: value == 0 ? 0.001 : value,
                                        toY: value,
                                        width: barWidth,
                                        color: color,
                                        borderRadius: BorderRadius.circular(6),
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),

                            // TOP LABELS (Count + %)
                            ...List.generate(chartData1.length, (index) {
                              final d = chartData1[index];
                              final value = (d["value"] ?? 0).toDouble();

                              if (value == 0) return SizedBox.shrink();

                              double percent = (value / maxY) * 100;
                              double barHeightRatio = value / maxY;

                              double topPosition =
                                  constraints.maxHeight * (1 - barHeightRatio) - 18;

                              double leftPosition = (index * (barWidth + 40)) + 40;

                              return Positioned(
                                left: leftPosition,
                                top: topPosition,
                                child: Text(
                                  "${value.toInt()} (${percent.toStringAsFixed(1)}%)",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            })
                          ],
                        );
                      },
                    ),
                  )

                ],
              ),
              // Legend below Pie Chart
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildLegend(Colors.purple, "personal".tr),
                  buildLegend(Colors.purple.shade400, "family".tr),
                  buildLegend(Colors.purple.shade300, "social".tr),
                  buildLegend(Colors.purple.shade200, "p_other".tr),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                "types_of_aspiration_status".tr,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  List<String> getLast1Year() {
    List<String> months = [];

    DateTime start = DateTime(2025, 1, 1);
    DateTime now = DateTime.now();

    while (start.isBefore(DateTime(now.year, now.month + 1, 1))) {
      months.add(DateFormat('yyyy-MM').format(start));
      start = DateTime(start.year, start.month + 1, 1);
    }

    return months;
  }

  List<String> getYearsOnly(List<String> months) {
    return months
        .map((m) => m.substring(0, 4)) // extract year
        .toSet()                      // remove duplicates
        .toList();
  }


  Widget buildYearFilter(List<String> months) {
    List<String> years = getYearsOnly(months);

    return Container(
      height: 45,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: BrandColors.appColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedYear, // ab yaha 'year' store karoge
          isExpanded: true,
          hint: Text("select_year".tr, style: TextStyle(color: Colors.grey[700])),
          items: years.map((year) {
            return DropdownMenuItem<String>(
              value: year,
              child: Text(year, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value; // store selected year
            });
            countParticipantsWithFeedback(gpCode: selectedGP, villageId: selectedVillage);
          },
        ),
      ),
    );
  }

// card builder function
  Widget buildCard(
      String title, String subtitle, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      // height: 70,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Legend builder function
  Widget buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

// get village
  Future<List<Map<String, dynamic>>> fetchDataFromApi(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure 'data' exists and is a List
        if (data['data'] != null && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          return []; // Empty list if no data
        }
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }
}
