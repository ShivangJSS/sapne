import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/SharedPreferHelper.dart';
import 'package:trikal_up/Controllers/family_controller.dart';
import 'package:trikal_up/Dashboard/Feedback/feedback_list.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/Add_aspiration.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/FeedBackNew.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/feedback.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/remark.dart';
import 'package:trikal_up/Dashboard/Manage_Family/family_list.dart';

import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/DatabaseHelper.dart';
import '../../Controllers/aspiration_controller.dart';
import '../HomeScreen/HomeScreen.dart';
import 'FeedBackList.dart';

class AspirationMonotoringWithoutFeedback extends StatefulWidget {
  const AspirationMonotoringWithoutFeedback({super.key});

  @override
  State<AspirationMonotoringWithoutFeedback> createState() => _AspirationMonotoringState();
}

class _AspirationMonotoringState extends State<AspirationMonotoringWithoutFeedback> {
  AspirationController aspctr = Get.find<AspirationController>();
  familyController f = Get.find<familyController>();
  String name="",fatherName="",profileImage="",typeGone="", aspirationId ="";
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    getData();
    aspctr.getAllAspWithoutFeedback();
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
    await aspctr.getData();
    await aspctr.getAllCategory();
    await aspctr.loadSubcategories();
    await aspctr.getSubCategoryQuestion();
    var db = await DatabaseHelper.instance.database;

    List<Map<String, dynamic>> aspirationList = await db.rawQuery(''' 
SELECT a.*
FROM aspiration a
LEFT JOIN feedback f ON a.asp_details_id = f.aspiration_id
WHERE f.aspiration_id IS NULL
''',);


    // aspirationFeedbackData.clear();

    if (aspirationList.isNotEmpty) {
      for (var asp in aspirationList) {
        String aspId = asp['asp_details_id'].toString();

        aspirationFeedbackData.add({
          "aspId": aspId,
          "optionId": "",
          "month": "Not Applicable",
          "submittedDate": "Not Applicable",
        });
      }


      print("=== Aspiration Feedback Data ===");
      for (var item in aspirationFeedbackData) {
        print("AspID: ${item['aspId']}, Option: ${item['optionId']}, Month: ${item['month']}, Date: ${item['submittedDate']}");
      }
      print("================================");
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
    aspctr.getAllAspWithoutFeedback();

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
              Text(
                'asp_appbaartext'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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

                      final String catId = asp["asp_cat_id"].toString();
                      final String subCatId = asp["sub_cat_id"].toString();
                      final String questionId = asp["question_id"].toString();
                      final String aspirationId = asp["aspId"].toString();

                      final String remarks = asp["remarks"].toString();
                      String createdAtStr = asp["created_at"]?.toString() ?? "";

// Safe date preview
                      String date = createdAtStr.length >= 10
                          ? createdAtStr.substring(0, 10)
                          : createdAtStr;

// Safe DateTime parse
                      DateTime createdAt;
                      try {
                        createdAt = DateTime.parse(createdAtStr);
                      } catch (e) {
                        createdAt = DateTime.now();  // fallback to avoid crash
                      }

                      final dueDate = DateTime(createdAt.year, createdAt.month + 6, createdAt.day);
                      final bool isEligible = DateTime.now().isAfter(dueDate);

                      // data from ids
                      final category =
                      getCategoryById(catId, aspctr.categories);
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
                                        fontSize: 18,
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

                              // ✅ Feedback button sabse niche right side
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     TextButton.icon(
                              //       style: TextButton.styleFrom(
                              //         backgroundColor: Colors.green.withOpacity(0.1),
                              //         shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(12),
                              //         ),
                              //       ),
                              //       onPressed: () async {
                              //
                              //
                              //         if (selectedMonth == null || selectedMonth!.isEmpty) {
                              //           ScaffoldMessenger.of(context).showSnackBar(
                              //             SnackBar(
                              //               content: Text("please_select_month_before_giving_feedback".tr),
                              //               duration: Duration(seconds: 2),
                              //               backgroundColor: Colors.red,
                              //               behavior: SnackBarBehavior.floating, // shows above bottom
                              //               shape: RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.circular(12),
                              //               ),
                              //             ),
                              //           );
                              //           return; // Stop execution here
                              //         }
                              //
                              //         await SharedPreferHelper.setPrefString("aspirationId", aspirationId);
                              //         await SharedPreferHelper.setPrefString("selectedMonth", selectedMonth.toString());
                              //         await SharedPreferHelper.setPrefString("SubCategory", subCatName);
                              //         await SharedPreferHelper.setPrefString("SubCategoryImage", asp_controller.sub_cat_image + subCatImage);
                              //         await SharedPreferHelper.setPrefString("remarks", remarks);
                              //
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //             builder: (context) => FeedBackListNew(),
                              //           ),
                              //         );
                              //
                              //
                              //       },
                              //       icon: const Icon(Icons.feedback,
                              //           color: Colors.green, size: 22),
                              //       label: Text(
                              //         "feedback".tr,
                              //         style: TextStyle(
                              //           color: Colors.green,
                              //           fontWeight: FontWeight.w600,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // if (allowFeedback)


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Column(
                                    children: [
                                      Builder(
                                        builder: (_) {
                                          final feedbackForAsp = aspirationFeedbackData.firstWhere(
                                                (e) => e['aspId'] == aspirationId,
                                            orElse: () => {
                                              "optionId": "",
                                              "month": "Not Applicable",
                                              "submittedDate": "Not Applicable"
                                            },
                                          );

                                          String optionId = feedbackForAsp["optionId"] ?? "";
                                          String month = feedbackForAsp["month"] ?? "Not Applicable";
                                          String submittedDate = feedbackForAsp["submittedDate"] ?? "Not Applicable";

                                          if (optionId == "1") {
                                            return _buildVerticalStep(
                                              stepTitle: "Not Achieved",
                                              month: month,
                                              submittedDate: submittedDate,
                                              color: Colors.redAccent,
                                              iconPath: "assets/notred.png",
                                              isActive: true,
                                            );
                                          } else if (optionId == "2") {
                                            return _buildVerticalStep(
                                              stepTitle: "Partially Achieved",
                                              month: month,
                                              submittedDate: submittedDate,
                                              color: Colors.orangeAccent,
                                              iconPath: "assets/notachivee.png",
                                              isActive: true,
                                            );
                                          } else if (optionId == "3") {
                                            return _buildVerticalStep(
                                              stepTitle: "Achieved",
                                              month: month,
                                              submittedDate: submittedDate,
                                              color: Colors.green,
                                              iconPath: "assets/achivegreen.png",
                                              isActive: true,
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      ),
                                    ],
                                  ),

                                  // ✅ Show Due Date only if no feedback (optionId not 1,2,3)
                                  if ((aspirationFeedbackData.firstWhere(
                                          (e) => e['aspId'] == aspirationId,
                                      orElse: () => {"optionId": ""}
                                  )["optionId"]) != "1"
                                      && (aspirationFeedbackData.firstWhere(
                                              (e) => e['aspId'] == aspirationId,
                                          orElse: () => {"optionId": ""}
                                      )["optionId"]) != "2"
                                      && (aspirationFeedbackData.firstWhere(
                                              (e) => e['aspId'] == aspirationId,
                                          orElse: () => {"optionId": ""}
                                      )["optionId"]) != "3"
                                  )
                                    Container(
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
                                            date ?? "-",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: isEligible
                                              ? Colors.green.withOpacity(0.1)
                                              : Colors.green.withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () async {

                                          String optionId = aspirationFeedbackData.firstWhere(
                                                  (e) => e['aspId'] == aspirationId,
                                              orElse: () => {"optionId": ""}
                                          )["optionId"] ?? "";
                                          // if (optionId.isEmpty && !isEligible) {
                                          //   ScaffoldMessenger.of(context).showSnackBar(
                                          //     SnackBar(
                                          //       content: Text("Feedback should be taken after 6 months of Aspiration"),
                                          //       duration: Duration(seconds: 2),
                                          //       backgroundColor: Colors.red,
                                          //       behavior: SnackBarBehavior.floating,
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius: BorderRadius.circular(12),
                                          //       ),
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

                                        icon: Icon(Icons.feedback, color: isEligible? Colors.green : Colors.green, size: 22),
                                        label: Text(
                                          "feedback".tr,
                                          style: TextStyle(
                                            color:isEligible? Colors.green : Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
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
      ),
    );
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
