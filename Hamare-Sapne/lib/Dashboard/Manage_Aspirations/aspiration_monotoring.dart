import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/SharedPreferHelper.dart';
import 'package:trikal_up/Controllers/family_controller.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/Add_aspiration.dart';
import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/DatabaseHelper.dart';
import '../../Controllers/aspiration_controller.dart';
import '../HomeScreen/HomeScreen.dart';
import 'FeedBackList.dart';

class AspirationMonotoring extends StatefulWidget {
  final String p_id;
  const AspirationMonotoring({super.key, required this.p_id});

  @override
  State<AspirationMonotoring> createState() => _AspirationMonotoringState();
}

class _AspirationMonotoringState extends State<AspirationMonotoring> {
  AspirationController aspctr = Get.find<AspirationController>();
  familyController f = Get.find<familyController>();
  String name="",fatherName="",profileImage="",typeGone="", aspirationId ="";
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    getData();
    aspctr.getAllAsp(widget.p_id.toString());
    // f.getOneFamily(widget.p_id.toString());
  }

  String notAchievedMonth="Not Applicable";
  String notAchievedSubmittedDate="Not Applicable";
  bool notAchievedIsActive=false;

  String partiallyAchievedMonth="Not Applicable";
  String partiallyAchievedSubmittedDate="Not Applicable";
  bool partiallyAchievedIsActive=false;
  bool partiallyAchievedISFilled=false;
  List<Map<String, String>> aspirationFeedbackData = [];

  String achievedAchievedMonth="Not Applicable";
  String achievedAchievedSubmittedDate="Not Applicable";
  bool achievedIsActive=false,isVisible=true;
  bool achievedAchievedISFilled=false;
  String lastOption = "";
  Future<void> getData() async {
    typeGone=await SharedPreferHelper.getPrefString("typeGone","");
    name=await SharedPreferHelper.getPrefString("participantName","");
    fatherName=await SharedPreferHelper.getPrefString("participantFatherName","");
    profileImage=await SharedPreferHelper.getPrefString("ProfileImage","");
    await SharedPreferHelper.setPrefString("participantId",widget.p_id.toString());
    await asp_controller.getData();
    await asp_controller.getAllCategory();
    await asp_controller.loadSubcategories();
    await asp_controller.getSubCategoryQuestion();
    var db = await DatabaseHelper.instance.database;
    String participantId = widget.p_id.toString();

    List<Map<String, dynamic>> aspirationList = await db.query(
      'aspiration',
      where: 'participant_id = ?',
      whereArgs: [participantId],
    );

    aspirationFeedbackData.clear();

    if (aspirationList.isNotEmpty) {
      for (var asp in aspirationList) {
        String aspId = asp['asp_details_id'].toString();

        List<Map<String, dynamic>> latestFeedback = await db.rawQuery(
            """SELECT * FROM feedback WHERE aspiration_id = ? ORDER BY datetime(created_at) DESC LIMIT 1 """, [aspId]);


        if (latestFeedback.isNotEmpty) {
          var fb = latestFeedback.first;
          aspirationFeedbackData.add({
            "aspId": aspId,
            "optionId": fb['option_id'].toString(),
            "month": fb['month'] ?? "Not Applicable",
            "submittedDate": fb['created_at'] ?? "Not Applicable",
          });

          }else {
          aspirationFeedbackData.add({
            "aspId": aspId,
            "optionId": "",
            "month": "Not Applicable",
            "submittedDate": "Not Applicable",
          });
        }
      }

    }

    setState(() {});
  }


  String img = "assets/f_incul.png";
  List<String> _getFutureMonthYearList() {
    final now = DateTime.now();
    final List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    String monthName = months[now.month - 1];
    String year = now.year.toString();

    return ["$monthName $year"];   // Only current month
  }

  // List<String> _getFutureMonthYearList() {
  //     final now = DateTime.now();
  //     final List<String> months = [
  //       "January", "February", "March", "April", "May", "June",
  //       "July", "August", "September", "October", "November", "December"
  //     ];
  //
  //     List<String> result = [];
  //
  //     for (int i = 5; i >= 0; i--) {    // 5 months ago to current month
  //       final date = DateTime(now.year, now.month - i, 1);
  //       String monthName = months[date.month - 1];
  //       String year = date.year.toString();
  //       result.add("$monthName $year");
  //     }
  //
  //     return result;
  // }

  int getMonthDifference(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 + (endDate.month - startDate.month);
  }
  DateTime parseAspirationDate(String monthYear) {
    Map<String, int> monthMap = {
      "January": 1, "February": 2, "March": 3, "April": 4,
      "May": 5, "June": 6, "July": 7, "August": 8,
      "September": 9, "October": 10, "November": 11, "December": 12,
    };

    List<String> parts = monthYear.split(" ");
    return DateTime(int.parse(parts[1]), monthMap[parts[0]]!, 1);
  }


    @override
  Widget build(BuildContext context) {
    aspctr.getAllAsp(widget.p_id.toString());

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
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
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded( // ⭐ important
                child: Text(
                  "asp_appbaartext".tr,
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
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Participant Card (Top pe Image + Details)
           SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 3,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Circular Image
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: BrandColors.appColor.withOpacity(0.2),
                        backgroundImage: (profileImage != null && profileImage.isNotEmpty)
                            ? (profileImage.startsWith('/data/') || profileImage.startsWith('/storage/')
                            ? FileImage(File(profileImage)) as ImageProvider
                            : null) // We'll use CachedNetworkImage for network
                            : null,
                        child: (profileImage != null && profileImage!.isNotEmpty)
                            ? (profileImage.startsWith('/data/') || profileImage.startsWith('/storage/')
                            ? null
                            : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: Api.BaseUrl + Api.imageParticipantPath + profileImage!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                          ),
                        ))
                            : const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                      ),
                      const SizedBox(width: 16),

                      // 👩 Participant Name + Father Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Participant Name
                            Text(
                              name ?? "",
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // ✅ Father Name
                            Text(
                              "${'father_name'.tr}: ${fatherName ?? ''}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
        ),
            // 🟢 Month Selector Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: DropdownButtonFormField<String>(
                value: selectedMonth,
                decoration: InputDecoration(
                  hintText: "select_month".tr,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1.5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white,

                // ✅ Items dynamically generated for current & future months only
                items: _getFutureMonthYearList()
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14)),
                ))
                    .toList(),

                onChanged: (val) {
                  setState(() {
                    selectedMonth = val;
                  });
                },
              ),
            ),

            // 🟢 Aspiration List niche
            Expanded(
              child: GetBuilder<AspirationController>(
                builder: (ctrl) {
                  if (ctrl.asplist.isEmpty) {
                    return Center(
                      child: Text(
                        "empty_msg".tr,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return ListView.builder(

                    padding: const EdgeInsets.all(12),
                    itemCount: ctrl.asplist.length,
                    itemBuilder: (context, index) {
                      final asp = ctrl.asplist[index];


                      // final String createdMonthYear = asp["created_month_year"]; // <-- Your DB field name
                      // DateTime aspirationDate = parseAspirationDate(createdMonthYear);
                      // DateTime currentDate = DateTime.now();
                      //
                      // int diffMonths = getMonthDifference(aspirationDate, currentDate);
                      // bool allowFeedback = diffMonths >= 6;
                      // ids
                      final String catId = asp["asp_cat_id"].toString();
                      final String subCatId = asp["sub_cat_id"].toString();
                      final String questionId = asp["question_id"].toString();
                      final String aspirationId = asp["asp_details_id"].toString();
                      final String remarks = asp["remarks"].toString();
                      final String date = asp["created_at"].toString().substring(0, 10);
                      final createdAt = DateTime.parse(asp["created_at"].toString());
                      final dueDate = DateTime(createdAt.year, createdAt.month + 6, createdAt.day);
                      final bool isEligible = DateTime.now().isAfter(dueDate);

                      // data from ids
                      final category =
                      getCategoryById(catId, asp_controller.categories);
                      final subcategory =
                      getSubCategoryById(subCatId, asp_controller.subcategories);
                      // String? questionName = getNameById(questionId);

                      final catName = category?["asp_name"] ?? "unknown".tr;
                      final catImage = category?["asp_photo"] ?? img;

                      final subCatName =
                          subcategory?["asp_sub_category_name"] ?? "unknown".tr;
                      final subCatImage =
                          subcategory?["asp_sub_category_images"] ?? img;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🏷️ Sub Category Row
                              Row(
                                children: [
                                  Container(
                                    width: 80, // ⬅️ slightly larger for better proportion
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12), // 🟢 soft rounded rectangle
                                      border: Border.all(color: Colors.grey.shade300, width: 2),
                                      color: Colors.white, // background for transparent images
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: (subCatImage.isNotEmpty)
                                        ? CachedNetworkImage(
                                      imageUrl: asp_controller.sub_cat_image + subCatImage,
                                      fit: BoxFit.contain, // 🟢 ensures full image visible, no cropping
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image, color: Colors.redAccent),
                                    )
                                        : Image.asset(
                                      img,
                                      fit: BoxFit.contain, // 🟢 ensures full image visible
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      subCatName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // 🏷️ Question Heading
                              //  Text(
                              //   "question".tr,
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w600,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              // const SizedBox(height: 6),

                              Text(
                                remarks ?? "-",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),


                              const SizedBox(height: 10),



                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left: feedback vertical step (uses same single lookup)
                                  // Builder(
                                  //   builder: (_) {
                                  //     final feedbackForAsp = aspirationFeedbackData.firstWhere(
                                  //           (e) => e['aspId'] == aspirationId,
                                  //       orElse: () => {
                                  //         "optionId": "",
                                  //         "month": "Not Applicable",
                                  //         "submittedDate": "Not Applicable"
                                  //       },
                                  //     );
                                  //
                                  //     final String optionId = (feedbackForAsp["optionId"] ?? "").toString();
                                  //     final String month = (feedbackForAsp["month"] ?? "Not Applicable").toString();
                                  //     final String submittedDate = (feedbackForAsp["submittedDate"] ?? "Not Applicable").toString();
                                  //
                                  //     if (optionId == "1") {
                                  //       return _buildVerticalStep(
                                  //         stepTitle: "Not Achieved",
                                  //         month: month,
                                  //         submittedDate: submittedDate,
                                  //         color: Colors.redAccent,
                                  //         iconPath: "assets/notred.png",
                                  //         isActive: true,
                                  //       );
                                  //     } else if (optionId == "2") {
                                  //       return _buildVerticalStep(
                                  //         stepTitle: "Partially Achieved",
                                  //         month: month,
                                  //         submittedDate: submittedDate,
                                  //         color: Colors.orangeAccent,
                                  //         iconPath: "assets/notachivee.png",
                                  //         isActive: true,
                                  //       );
                                  //     } else if (optionId == "3") {
                                  //       return _buildVerticalStep(
                                  //         stepTitle: "Achieved",
                                  //         month: month,
                                  //         submittedDate: submittedDate,
                                  //         color: Colors.green,
                                  //         iconPath: "assets/achivegreen.png",
                                  //         isActive: true,
                                  //       );
                                  //     } else {
                                  //       return const SizedBox();
                                  //     }
                                  //   },
                                  // ),




                      //         Column(
                      //         children: aspirationFeedbackData
                      //             .where((e) => e['aspId'] == aspirationId)
                      //     .map((e) {
                      //           print("All Feedback Data: $aspirationFeedbackData");
                      //
                      //
                      //           final optionId = (e["optionId"] ?? "").toString();
                      //   final month = (e["month"] ?? "Not Applicable").toString();
                      //   final submittedDate =
                      //   (e["submittedDate"] ?? "Not Applicable").toString();
                      //
                      //   if (optionId == "1") {
                      //     return _buildVerticalStep(
                      //       stepTitle: "Not Achieved",
                      //       month: month,
                      //       submittedDate: submittedDate,
                      //       color: Colors.redAccent,
                      //       iconPath: "assets/notred.png",
                      //       isActive: true,
                      //     );
                      //   } else if (optionId == "2") {
                      //     return _buildVerticalStep(
                      //       stepTitle: "Partially Achieved",
                      //       month: month,
                      //       submittedDate: submittedDate,
                      //       color: Colors.orangeAccent,
                      //       iconPath: "assets/notachivee.png",
                      //       isActive: true,
                      //     );
                      //   } else if (optionId == "3") {
                      //     return _buildVerticalStep(
                      //       stepTitle: "Achieved",
                      //       month: month,
                      //       submittedDate: submittedDate,
                      //       color: Colors.green,
                      //       iconPath: "assets/achivegreen.png",
                      //       isActive: true,
                      //     );
                      //   } else {
                      //     return const SizedBox();
                      //   }
                      // }).toList(),
                      // ),

                                  // Middle: Due Date box — only when no feedback (optionId not 1/2/3)
                                  Builder(
                                    builder: (_) {
                                      final feedback = aspirationFeedbackData.firstWhere(
                                            (e) => e['aspId'] == aspirationId,
                                        orElse: () => {"optionId": ""},
                                      );
                                      final String optionId = (feedback["optionId"] ?? "").toString();

                                      if (optionId == "1" || optionId == "2" || optionId == "3") {
                                        return const SizedBox(); // hide due date when feedback exists
                                      }

                                      // compute due date (+6 months) from `date` variable
                                      final DateTime? parsed = _parseDate(date);
                                      final String display;
                                      if (parsed == null) {
                                        display = "-";
                                      } else {
                                        final DateTime due = _addMonths(parsed, 6);
                                        display = _formatDate(due);
                                      }

                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.blue.shade200),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Due Date: ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                            Text(
                                              display,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  // Right: Feedback button — hide when Achieved (optionId == "3")

                                  Builder(
                                    builder: (_) {
                                      final feedback = aspirationFeedbackData.firstWhere(
                                            (e) => e['aspId'] == aspirationId,
                                        orElse: () => {"optionId": ""},
                                      );
                                      final String optionId = (feedback["optionId"] ?? "").toString();

                                      // if (optionId == "3") {
                                      //   return const SizedBox(); // hide button when Achieved
                                      // }
                                      final DateTime? parsedDate = _parseDate(date);
                                      final DateTime? dueDate =
                                      parsedDate == null ? null : _addMonths(parsedDate, 6);

                                      final bool isDueCompleted =
                                          dueDate != null && DateTime.now().isAfter(dueDate);
                                        print('is $isDueCompleted');
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            style: TextButton.styleFrom(
                                              backgroundColor: isEligible ? Colors.green.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () async {
                                              // if (!isDueCompleted) {
                                              //   ScaffoldMessenger.of(context).showSnackBar(
                                              //     SnackBar(
                                              //       content: Text(
                                              //         "Feedback can be given only after due date",
                                              //       ),
                                              //       backgroundColor: Colors.red,
                                              //       behavior: SnackBarBehavior.floating,
                                              //     ),
                                              //   );
                                              //   return;
                                              // }

                                              if (selectedMonth == null || selectedMonth!.isEmpty) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("please_select_month_before_giving_feedback".tr),
                                                    duration: Duration(seconds: 2),
                                                    backgroundColor: Colors.red,
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }

                                              await SharedPreferHelper.setPrefString("aspirationId", aspirationId);
                                              await SharedPreferHelper.setPrefString("selectedMonth", selectedMonth.toString());
                                              await SharedPreferHelper.setPrefString("SubCategory", subCatName);
                                              await SharedPreferHelper.setPrefString("SubCategoryImage", asp_controller.sub_cat_image + subCatImage);
                                              await SharedPreferHelper.setPrefString("remarks", remarks);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FeedBackListNew(),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.feedback, color: isEligible ? Colors.green : Colors.green, size: 20),
                                            label: Text(
                                              "feedback".tr,
                                              style: TextStyle(
                                                color: isEligible ? Colors.green : Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                      ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // 🟢 Floating Add Button
        floatingActionButton: typeGone == "No"
            ? FloatingActionButton(
          backgroundColor: BrandColors.apporangeColor,
          onPressed: () async {
            await SharedPreferHelper.setPrefString(
                "participantId", widget.p_id.toString());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddAspiration()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      ),
    );
  }
// Helper: safely parse date string (ISO or dd-MM-yyyy). returns null if not parseable.
  DateTime? _parseDate(String? s) {
    if (s == null) return null;
    // Try ISO first
    DateTime? dt;
    try {
      dt = DateTime.tryParse(s);
      if (dt != null) return dt;
    } catch (_) {}
    // Try dd-MM-yyyy
    try {
      final parts = s.split(RegExp(r'[-/]'));
      if (parts.length == 3) {
        final d = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final y = int.tryParse(parts[2]);
        if (d != null && m != null && y != null) {
          return DateTime(y, m, d);
        }
      }
    } catch (_) {}
    return null;
  }

// Helper: add months correctly (handles year overflow and end-of-month)
  DateTime _addMonths(DateTime date, int monthsToAdd) {
    final year = date.year + ((date.month - 1 + monthsToAdd) ~/ 12);
    final month = ((date.month - 1 + monthsToAdd) % 12) + 1;
    final day = date.day;
    final lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
    final targetDay = day > lastDayOfTargetMonth ? lastDayOfTargetMonth : day;
    return DateTime(year, month, targetDay, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

// Helper: format DateTime as dd-MM-yyyy
  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
  }

  Widget _buildVerticalStep({
    required String stepTitle,
    required String month,          // not used now
    required String submittedDate,  // not used now
    required Color color,
    required String iconPath,       // not used now
    required bool isActive,
    VoidCallback? onFullyAchieved,
  }) {
    return GestureDetector(
      onTap: () {
        if (isActive && onFullyAchieved != null) {
          onFullyAchieved();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // STEP TITLE ONLY
          Text(
            stepTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isActive ? color : Colors.grey.shade600,
            ),
          ),

        ],
      ),
    );
  }

  // 🟢 Function to get Category Data from ID
  Map<String, dynamic>? getCategoryById(String catId, List<Map<String, dynamic>> categories) {
    try {
      return categories.firstWhere(
            (cat) => cat["asp_cat_code"] == catId,
        orElse: () => {}, // अगर ना मिले तो empty map
      );
    } catch (e) {
      return null;
    }
  }
  Map<String, dynamic>? getSubCategoryById(String catId, List<Map<String, dynamic>> categories) {
    try {
      return categories.firstWhere(
            (cat) => cat["asp_sub_cat_code"] == catId,
        orElse: () => {}, // अगर ना मिले तो empty map
      );
    } catch (e) {
      return null;
    }
  }
  String? getNameById(String id) {
    try {
      return asp_controller.subCategoriesQuestion
          .firstWhere((q) => q.question_id == id)
          .question_name;
    } catch (e) {
      return null; // agar nahi mila toh null
    }
  }

}
