import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/remark.dart';

import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/DatabaseHelper.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Controllers/aspiration_controller.dart';
import '../../Controllers/family_controller.dart';
import '../../Modals/AspirationModel.dart';
import '../../Modals/FeedBackModel.dart';
import '../../Modals/FeedbackAnswer.dart';
import '../../Modals/QuestionModel.dart';
import '../../Modals/sub_category_list.dart';
import '../HomeScreen/HomeScreen.dart';
import '../Manage_Family/family_list.dart';
import 'Add_aspiration.dart';
import 'feedback.dart';

class FeedBackNew extends StatefulWidget {
  const FeedBackNew({super.key});

  @override
  State<FeedBackNew> createState() => _FeedBackNewState();
}

class _FeedBackNewState extends State<FeedBackNew> {
  AspirationController aspirationController = Get.find<AspirationController>();
  final Dio _dio = Dio();
  Set<String> selectedQuestionIds = {};
  Map<String, int> selectedOptions = {};
  String subCategoryId="",categoryId="";
  // Map<int, int> selectedOptions = {};
  String selectedQuestionId="";
  int selectedOption=0;
  final List<Map<String, dynamic>> options = [
    {"label": "not_achieved", "icon": "assets/notred.png"},
    {"label": "partially_achieved", "icon": "assets/notachivee.png"},
    {"label": "achieved", "icon": "assets/achivegreen.png"},


  ];
  // String name="",fatherName="",profileImage="";

  String img = "assets/f_incul.png";

  String? selectedMonth;


  @override
  void initState() {
    super.initState();
    getInitialData();
    selectedMonth=aspirationController.month;

    getData();
    // f.getOneFamily(widget.p_id.toString());
  }


  Future<void> getData() async {
    await asp_controller.getLocation(context);
    setState(() {});

  }
  Future<void> getInitialData({bool fromFeedback = false}) async {


    String participantId = await SharedPreferHelper.getPrefString("participantId", "");
    String allFeedbackIds = await SharedPreferHelper.getPrefString("participant_feedback_ids", "");
    print("⚠️ participantId $participantId");

    if (allFeedbackIds.isEmpty) {
      print("⚠️ No feedback found for this participant");
      return;
    }

    List<String> feedbackIds = allFeedbackIds.split(",");

    // 🟣 if user came from Feedback page, show only last feedback
    if (fromFeedback && feedbackIds.isNotEmpty) {
      feedbackIds = [feedbackIds.last];
    }

    String querySub = "SELECT * FROM sub_category_list";
    String queryAsp = "SELECT * FROM aspiration";
    String queryQues = "SELECT * FROM question_list";

    List<SubCategoryList> subCategoryList = await DatabaseHelper.instance.getSubList(querySub);
    List<QuestionModel> questionList = await DatabaseHelper.instance.getQuestionList(queryQues);
    List<AspirationModel> aspList = await DatabaseHelper.instance.getAsp(queryAsp);

    List<Map<String, dynamic>> allFeedbackData = [];

    for (String feedbackId in feedbackIds) {
      String subCategory = await SharedPreferHelper.getPrefString("SubCategory_$feedbackId", "");
      String subCategoryImage = await SharedPreferHelper.getPrefString("SubCategoryImages_$feedbackId", "");
      String optionIdsStr = await SharedPreferHelper.getPrefString("OptionIds_$feedbackId", "");
      String questionIdStr = await SharedPreferHelper.getPrefString("QuetionId_$feedbackId", "");
      String remark = await SharedPreferHelper.getPrefString("Remark_$feedbackId", "");

      final match = subCategoryList.firstWhere(
            (e) => e.asp_sub_cat_id.toString() == subCategory,
        orElse: () => SubCategoryList(
          asp_sub_cat_id: "",
          asp_sub_category_name: "",
          asp_sub_category_images: "",
        ),
      );

      final question = questionList.firstWhere(
            (e) => e.question_id.toString() == questionIdStr,
        orElse: () => QuestionModel(
          question_id: "",
          question_name: "",
        ),
      );

      String optionName = match.asp_sub_category_name ?? "";
      String optionNameImage = match.asp_sub_category_images ?? "";
      String imageUrl = "${Api.BaseUrl}${Api.AssetsImage}$optionNameImage";
      String questionName = question.question_name ?? "";
      print('remark $remark');
      Map<String, dynamic> feedbackData = {
        "feedbackId": feedbackId,
        "participantId": participantId,
        "SubCategory": optionName,
        "SubCategoryImage": imageUrl,
        "optionIds": optionIdsStr,
        "Question": questionName,
        "Remark": remark,
      };

      allFeedbackData.add(feedbackData);
    }

    rmkcontroller.feedbackDataList.assignAll(allFeedbackData);

    print("✅ Loaded ${allFeedbackData.length} feedback(s): $allFeedbackData");

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
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
                  "feed_appbaar_text".tr,
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
            // 🟢 Participant Card
// 🟢 Participant Card (Top pe dikhane ke liye replace kiya)
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 🟠 Circular Image
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: BrandColors.appColor.withOpacity(0.2),
                        backgroundImage: (aspirationController.profileImage != null && aspirationController.profileImage!.isNotEmpty)
                            ? (aspirationController.profileImage!.startsWith('/data/') ||
                            aspirationController.profileImage!.startsWith('/storage/'))
                            ? FileImage(File(aspirationController.profileImage!)) as ImageProvider
                            : null
                            : null,
                        child: (aspirationController.profileImage != null && aspirationController.profileImage!.isNotEmpty)
                            ? (aspirationController.profileImage!.startsWith('/data/') ||
                            aspirationController.profileImage!.startsWith('/storage/'))
                            ? null
                            : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: Api.BaseUrl +
                                Api.imageParticipantPath +
                                aspirationController.profileImage!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.person,
                                color: BrandColors.appColor, size: 28),
                          ),
                        )
                            : const Icon(Icons.person,
                            color: BrandColors.appColor, size: 28),
                      ),
                      const SizedBox(width: 16),

                      // 👩 Participant Name + Father Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              aspirationController.name ?? "",
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // ✅ Father Name
                            Text(
                              "${"father_name".tr}: ${aspirationController.fatherName ?? ''}",
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
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // // 🟢 Month Selector Dropdown
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            //   child: DropdownButtonFormField<String>(
            //     value: selectedMonth,
            //     decoration: InputDecoration(
            //       hintText: "select_month".tr,
            //       isDense: true,
            //       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: const BorderSide(color: Colors.black54, width: 1),
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //         borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1.5),
            //       ),
            //       filled: true, // ✅ background fill enable
            //       fillColor: Colors.white, // ✅ background white
            //     ),
            //     dropdownColor: Colors.white,
            //     items: [
            //       "April","May","June","July","August","September",
            //       "October","November","December","January","February","March"
            //     ]
            //         .map((e) => DropdownMenuItem(
            //       value: e,
            //       child: Text(e, style: const TextStyle(fontSize: 14)),
            //     ))
            //         .toList(),
            //     onChanged: (val) {
            //       setState(() {
            //         selectedMonth = val;
            //       });
            //     },
            //   ),
            // ),

            // 🟢 Aspiration List
            Expanded(
              child: GetBuilder<AspirationController>(
                builder: (ctrl) {
                  if (ctrl.asplistfeedBack.isEmpty) {
                    return Center(
                      child: Text(
                        "empty_msg".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
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
                          children: List.generate(ctrl.asplistfeedBack.length, (index) {
                            final asp = ctrl.asplistfeedBack[index];

                            final String subCatId = asp["sub_cat_id"].toString();
                            final String catId = asp["asp_cat_id"].toString();
                            final String remarksQuestion = asp["remarks"].toString();
                            subCategoryId=subCatId;
                            categoryId=catId;
                            // ✅ SubCategory Details
                            final subCat = getSubCategoryById(subCatId, asp_controller.subcategories);
                            final subCatName = subCat?["asp_sub_category_name"] ?? "Unknown Sub Category";
                            final subCatImage = subCat?["asp_sub_category_images"] ?? img;

                            // ✅ Filter all questions for this SubCategory
                            final subCatQuestions = asp_controller.subCategoriesQuestion
                                .where((q) => q.sub_category_id == subCatId)
                                .toList();

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔢 SubCategory Row
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ClipOval(
                                        child: (subCatImage.isNotEmpty)
                                            ? CachedNetworkImage(
                                          imageUrl: asp_controller.sub_cat_image + subCatImage,
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.contain,
                                        )
                                            : Image.asset(img,
                                            width: 55, height: 55, fit: BoxFit.contain),
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
                                  const SizedBox(height: 8),
                                  // 🏷️ Question Heading
                                  Text(
                                    "question".tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    remarksQuestion ?? "-",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),

                                  // // 📝 Remarks Question (SubCategory ke niche)
                                  // if (remarksQuestion.isNotEmpty && remarksQuestion != "null")
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(left: 6, bottom: 8),
                                  //     child: Text(
                                  //       remarksQuestion,
                                  //       style: const TextStyle(
                                  //         fontSize: 14,
                                  //         fontWeight: FontWeight.w500,
                                  //         color: Colors.blueGrey,
                                  //       ),
                                  //     ),
                                  //   ),
                                  const SizedBox(height: 12),

                                  // 🟢 Show All Questions of this SubCategory
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: List.generate(subCatQuestions.length, (qIndex) {
                                  //     final q = subCatQuestions[qIndex];
                                  //     final String questionId = q.question_id_code.toString(); // ✅ question_id use karo
                                  //
                                  //     return Padding(
                                  //       padding: const EdgeInsets.only(bottom: 18),
                                  //       child: Column(
                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                  //         children: [
                                  //           // 🏷️ Question as Radio Button
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               setState(() {
                                  //                 selectedQuestionId = questionId;
                                  //
                                  //                 selectedOption = 0;
                                  //               });
                                  //             },
                                  //             child: Row(
                                  //               children: [
                                  //                 Container(
                                  //                   margin: const EdgeInsets.only(right: 8),
                                  //                   height: 20,
                                  //                   width: 20,
                                  //                   decoration: BoxDecoration(
                                  //                     shape: BoxShape.circle,
                                  //                     border: Border.all(
                                  //                       color: selectedQuestionId == questionId ? Colors.green : Colors.grey,
                                  //                       width: 2,
                                  //                     ),
                                  //                     color: selectedQuestionId == questionId
                                  //                         ? Colors.green.withOpacity(0.2)
                                  //                         : Colors.white,
                                  //                   ),
                                  //                   child: selectedQuestionId == questionId
                                  //                       ? const Icon(Icons.circle, size: 12, color: Colors.green)
                                  //                       : null,
                                  //                 ),
                                  //                 Expanded(
                                  //                   child: Text(
                                  //                     q.question_name ?? "-",
                                  //                     style: const TextStyle(
                                  //                       fontSize: 14,
                                  //                       fontWeight: FontWeight.w600,
                                  //                       color: Colors.black87,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //
                                  //           const SizedBox(height: 10),
                                  //
                                  //           // 🟢 Options Row - sirf selectedQuestionId ke liye hi dikhega
                                  //           if (selectedQuestionId == questionId)
                                  //             Row(
                                  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //               children: List.generate(options.length, (optIndex) {
                                  //                 int optionValue = optIndex + 1;
                                  //                 bool isSelected = selectedOption == optionValue;
                                  //
                                  //                 // 👇 Responsive sizes (bigger than before)
                                  //                 double screenWidth = MediaQuery.of(context).size.width;
                                  //                 double circleSize = screenWidth * 0.18; // पहले 0.18 था, अब 22% width
                                  //                 double iconSize = circleSize * 0.80;   // पहले 0.6 था, अब 75%
                                  //                 double labelWidth = screenWidth * 0.26;
                                  //
                                  //                 return GestureDetector(
                                  //                   onTap: () async{
                                  //                     setState(() {
                                  //                       selectedOption = optionValue;
                                  //                     });
                                  //                     showStatusPopup(context, optionValue);
                                  //
                                  //                   },
                                  //                   child: Column(
                                  //                     mainAxisSize: MainAxisSize.min,
                                  //                     children: [
                                  //                       AnimatedContainer(
                                  //                         duration: const Duration(milliseconds: 300),
                                  //                         margin: const EdgeInsets.only(bottom: 8),
                                  //                         padding: EdgeInsets.all(circleSize * 0.22),
                                  //                         decoration: BoxDecoration(
                                  //                           shape: BoxShape.circle,
                                  //                           gradient: isSelected
                                  //                               ? const LinearGradient(
                                  //                             colors: [Color(0xFFa8e063), Color(0xFF56ab2f)],
                                  //                             begin: Alignment.topLeft,
                                  //                             end: Alignment.bottomRight,
                                  //                           )
                                  //                               : const LinearGradient(
                                  //                             colors: [Colors.white, Colors.white],
                                  //                             begin: Alignment.topLeft,
                                  //                             end: Alignment.bottomRight,
                                  //                           ),
                                  //                           boxShadow: [
                                  //                             BoxShadow(
                                  //                               color: Colors.black.withOpacity(0.15),
                                  //                               blurRadius: 6,
                                  //                               offset: const Offset(3, 3),
                                  //                             ),
                                  //                             BoxShadow(
                                  //                               color: Colors.white.withOpacity(0.8),
                                  //                               blurRadius: 6,
                                  //                               offset: const Offset(-3, -3),
                                  //                             ),
                                  //                           ],
                                  //                           border: Border.all(
                                  //                             color: isSelected ? Colors.green : Colors.grey.shade400,
                                  //                             width: isSelected ? 3 : 2,
                                  //                           ),
                                  //                         ),
                                  //                         child: AnimatedScale(
                                  //                           scale: options[optIndex]["icon"] == "assets/notred.png"
                                  //                               ? (isSelected ? 1.4 : 1.0) // notred.png के लिए छोटा scale
                                  //                               : (isSelected ? 1.99 : 1.4), // बाकी icons के लिए पुराना scale
                                  //                           duration: const Duration(milliseconds: 300),
                                  //                           curve: Curves.easeOutBack,
                                  //                           child: SizedBox(
                                  //                             height: iconSize,
                                  //                             width: iconSize,
                                  //                             child: FittedBox(
                                  //                               fit: BoxFit.contain,
                                  //                               child: Image.asset(options[optIndex]["icon"]),
                                  //                             ),
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       SizedBox(
                                  //                         width: labelWidth,
                                  //                         child: Text(
                                  //                           options[optIndex]["label"].toString().tr,
                                  //                           textAlign: TextAlign.center,
                                  //                           maxLines: 4,
                                  //                           overflow: TextOverflow.ellipsis,
                                  //                           style: TextStyle(
                                  //                             fontSize: screenWidth * 0.035, // font भी थोड़ा बड़ा
                                  //                             fontWeight: FontWeight.w600,
                                  //                             color: isSelected ? Colors.green.shade800 : Colors.black87,
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 );
                                  //               }),
                                  //             )
                                  //
                                  //
                                  //
                                  //         ],
                                  //       ),
                                  //     );
                                  //   }),
                                  // ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: List.generate(
                                        subCatQuestions.length, (qIndex) {
                                      final q = subCatQuestions[qIndex];
                                      final String questionId =
                                      q.question_id_code.toString();

                                      final bool isQuestionSelected =
                                      selectedQuestionIds
                                          .contains(questionId);

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 18),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // 🏷️ Question Row
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  // ✅ Toggle selection
                                                  if (selectedQuestionIds
                                                      .contains(questionId)) {
                                                    selectedQuestionIds
                                                        .remove(questionId);
                                                    selectedOptions
                                                        .remove(questionId);
                                                  } else {
                                                    selectedQuestionIds
                                                        .add(questionId);
                                                  }
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                    const EdgeInsets.only(
                                                        right: 8),
                                                    height: 20,
                                                    width: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: isQuestionSelected
                                                            ? Colors.green
                                                            : Colors.grey,
                                                        width: 2,
                                                      ),
                                                      color: isQuestionSelected
                                                          ? Colors.green
                                                          .withOpacity(0.2)
                                                          : Colors.white,
                                                    ),
                                                    child: isQuestionSelected
                                                        ? const Icon(
                                                        Icons.circle,
                                                        size: 12,
                                                        color: Colors.green)
                                                        : null,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      q.question_name ?? "-",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            // 🟢 Options — sirf is question ke liye dikhao
                                            if (isQuestionSelected)
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: List.generate(
                                                    options.length, (optIndex) {
                                                  int optionValue =
                                                      optIndex + 1;

                                                  // ✅ Har question ka apna option check
                                                  bool isSelected =
                                                      selectedOptions[
                                                      questionId] ==
                                                          optionValue;

                                                  double screenWidth =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;
                                                  double circleSize =
                                                      screenWidth * 0.18;
                                                  double iconSize =
                                                      circleSize * 0.80;
                                                  double labelWidth =
                                                      screenWidth * 0.26;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedOptions[
                                                        questionId] =
                                                            optionValue;
                                                      });
                                                      showStatusPopup(
                                                          context, optionValue);
                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        AnimatedContainer(
                                                          duration: const Duration(
                                                              milliseconds:
                                                              300),
                                                          margin: const EdgeInsets
                                                              .only(bottom: 8),
                                                          padding:
                                                          EdgeInsets.all(
                                                              circleSize *
                                                                  0.22),
                                                          decoration:
                                                          BoxDecoration(
                                                            shape:
                                                            BoxShape.circle,
                                                            gradient: isSelected
                                                                ? const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFFa8e063),
                                                                Color(
                                                                    0xFF56ab2f)
                                                              ],
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                            )
                                                                : const LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .white,
                                                                Colors
                                                                    .white
                                                              ],
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                    0.15),
                                                                blurRadius: 6,
                                                                offset:
                                                                const Offset(
                                                                    3, 3),
                                                              ),
                                                              BoxShadow(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                    0.8),
                                                                blurRadius: 6,
                                                                offset:
                                                                const Offset(
                                                                    -3, -3),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                              color: isSelected
                                                                  ? Colors.green
                                                                  : Colors.grey
                                                                  .shade400,
                                                              width: isSelected
                                                                  ? 3
                                                                  : 2,
                                                            ),
                                                          ),
                                                          child: AnimatedScale(
                                                            scale: options[optIndex]
                                                            [
                                                            "icon"] ==
                                                                "assets/notred.png"
                                                                ? (isSelected
                                                                ? 1.4
                                                                : 1.0)
                                                                : (isSelected
                                                                ? 1.99
                                                                : 1.4),
                                                            duration: const Duration(
                                                                milliseconds:
                                                                300),
                                                            curve: Curves
                                                                .easeOutBack,
                                                            child: SizedBox(
                                                              height: iconSize,
                                                              width: iconSize,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .contain,
                                                                child:
                                                                Image.asset(
                                                                    options[optIndex]
                                                                    [
                                                                    "icon"]),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: labelWidth,
                                                          child: Text(
                                                            options[optIndex][
                                                            "label"]
                                                                .toString()
                                                                .tr,
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 4,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                              fontSize:
                                                              screenWidth *
                                                                  0.035,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              color: isSelected
                                                                  ? Colors.green
                                                                  .shade800
                                                                  : Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                  const Divider(height: 15, color: Colors.white),

                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🟢 Submit Button at bottom
            const SizedBox(height: 10,),
          SafeArea(child:   Padding(
              padding: const EdgeInsets.only(bottom: 18.0, left: 12, right: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.apporangeColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    var now = DateTime.now();
                    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

                    // 🟢 Step 1: Month Validation
                    if (selectedMonth == null || selectedMonth!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("pls_select_month".tr),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // 🟢 Step 2: Question Validation
                    if (selectedQuestionIds == null || selectedQuestionIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("pls_select_question".tr),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // 🟢 Step 3: Option Validation
                    if (selectedOptions == null || selectedOptions == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("pls_select_option".tr),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    List<Map<String, dynamic>> questions = [];

                    selectedOptions.forEach((questionId, optionId) {
                      questions.add({
                        "question_id": questionId,
                        "option_id": optionId,
                      });
                    });
                    // ✅ Sab kuch valid hai → Data bana ke bhejo
                    Map<String, dynamic> finalSubmitData = {
                      "coach_id": asp_controller.coachId.toString(),
                      "aspiration_id": aspirationController.aspirationId.toString(),
                      "participant_id": asp_controller.participantId.toString(),
                      "asp_sub_cat_id": subCategoryId.toString(),
                      "asp_cat_id": categoryId.toString(),
                      // "question_id": selectedQuestionIds.toString(),
                      // "option_id": selectedOptions.toString(),
                      "questions": questions,
                      "month": selectedMonth.toString(),
                      "latitude": asp_controller.latitude.toString(),
                      "longitude": asp_controller.longitude.toString(),
                      "mobile_version": asp_controller.osVersion.toString(),
                      "device_name": asp_controller.deviceName.toString(),
                      "app_version": asp_controller.appVersion.toString(),
                      "created_at": formattedDateTime,
                    };

                    // ⚠️ Confirmation Alert Popup
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title:  Text("confirm_submission".tr),
                          content:  Text("are_you_sure".tr),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child:  Text("cancel".tr, style: TextStyle(color: Colors.red)),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child:  Text("yes".tr,style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        );
                      },
                    );

                    // ✅ User pressed "Yes"
                    if (confirm == true) {
                      sendFeedbackData(finalSubmitData);

                      print("📤 Final Submit Data: $finalSubmitData");
                    } else {
                      print("🚫 User cancelled submission.");
                    }
                  },
                  child: Text(
                    "submit".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void showStatusPopup(BuildContext context, int optionValue) {
    String message = "";
    String extraMessage = "";
    IconData icon = Icons.help_outline;
    Color bgColor = Colors.grey;

    if (optionValue == 1) {
      message = "${"not_achieved".tr} 😢";
      icon = Icons.sentiment_dissatisfied;
      bgColor = Colors.redAccent;
      extraMessage = "dont_worry_try_again".tr;
    } else if (optionValue == 2) {
      message = "${"partially_achieved".tr} 😐";
      icon = Icons.sentiment_neutral;
      bgColor = Colors.orangeAccent;
      extraMessage = "you_are_on_the_right_track".tr;
    } else if (optionValue == 3) {
      message = "${"achieved".tr} 😍";
      icon = Icons.sentiment_very_satisfied;
      bgColor = Colors.green;
      extraMessage = "great_job_keep_it_up".tr;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Popup",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Center(
            child: Dialog(
              elevation: 12,
              backgroundColor: Colors.white, // ✅ pure white card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white, // ✅ pure white card
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: CurvedAnimation(
                        parent: anim1,
                        curve: Curves.easeOutBack,
                      ),
                      child: Icon(icon, color: bgColor, size: 60),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: bgColor, // ✅ text color dynamic
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Text(
                    //   extraMessage,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     fontStyle: FontStyle.italic,
                    //     color: bgColor.withOpacity(0.85), // ✅ lighter text
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: child,
        );
      },
    );
  }

  String generateFeedbackId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return "${timestamp}_$random";
  }

  Future<void> sendFeedbackData(Map<String, dynamic> feedback) async {
    SmartDialog.showLoading(msg: "Please wait...");

    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      // ✅ Offline save




      String feedbackId = "";
      var now = DateTime.now();
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      List<String> savedFeedbackIds = [];

      for (var entry in selectedOptions.entries) {
         feedbackId = generateFeedbackId();
        // String newFeedbackId = generateFeedbackId(); // alag naam
        // savedFeedbackIds.add(newFeedbackId);

        Map<String, dynamic> rowData = {
          "coach_id": asp_controller.coachId.toString(),
          "aspiration_id": aspirationController.aspirationId.toString(),
          "participant_id": asp_controller.participantId.toString(),
          "asp_sub_cat_id": subCategoryId.toString(),
          "asp_cat_id": categoryId.toString(),

          "question_id": entry.key.toString(),
          "option_id": entry.value.toString(),

          "month": selectedMonth.toString(),
          "latitude": asp_controller.latitude.toString(),
          "longitude": asp_controller.longitude.toString(),
          "mobile_version": asp_controller.osVersion.toString(),
          "device_name": asp_controller.deviceName.toString(),
          "app_version": asp_controller.appVersion.toString(),
          "created_at": formattedDateTime,
        };

        FeedBackModel fb = FeedBackModel.fromMap(rowData);
        fb.feedbackId = feedbackId;
        fb.status = "0";

        int feedbackLocalId = await DatabaseHelper.instance.insertFeedback(fb);
        print("Offline Saved Feedback ID: $feedbackLocalId");
      }
      String aspirationId=await SharedPreferHelper.getPrefString("aspirationId","");
      await SharedPreferHelper.setPrefString("feedback_id", feedbackId ?? "");

      await aspirationController.getAllFeedBack(aspirationId);

      SmartDialog.dismiss();
      SmartDialog.showToast(" Data has been saved locally");
      // if (feedback["option_id"] == "1" || feedback["option_id"] == "2")  {
        var db = await DatabaseHelper.instance.database;
      List<Map<String, dynamic>> feedbackData = await db.query(
        'feedback',
        where: 'participant_id = ? AND aspiration_id = ?',
        whereArgs: [
          aspirationController.participantId,
          aspirationController.aspirationId,  // ✅ current aspiration only
        ],

        orderBy: 'local_id ASC', // assuming id is autoincrement in feedback table
        // limit: 1,
      );

        if (feedbackData.isEmpty) {
          await SharedPreferHelper.setPrefString("participant_feedback_ids", "");
          print('id is $feedbackData');
        } else {
          Set<String> feedbackIds = feedbackData
              .map((e) => e['feedback_id'].toString())
              .toSet();

          await SharedPreferHelper.setPrefString(
            "participant_feedback_ids",
            feedbackIds.join(','),
          );


          List<Map<String, dynamic>> currentFeedback = await db.query(
            'feedback',
            where: 'feedback_id = ?',
            whereArgs: [feedbackId],
          );

          for (var feedbackRow in feedbackData) {
            String fId = feedbackRow['feedback_id'].toString();
            String AspCatId = feedbackRow['asp_sub_cat_id'].toString();
            String aspId = feedbackRow['aspiration_id'].toString();

            List<Map<String, dynamic>> aspirationData = await db.query(
              'aspiration',
              where: 'asp_details_id = ? AND participant_id = ?',
              whereArgs: [aspId, aspirationController.participantId],
            );

            String remark = aspirationData.isNotEmpty
                ? aspirationData.first['remarks'] ?? ''
                : '';

            await SharedPreferHelper.setPrefString("current_feedback_id", fId);
            await SharedPreferHelper.setPrefString("Remark_$fId", remark);
            await SharedPreferHelper.setPrefString("SubCategory_$fId", AspCatId); // ✅ har entry ke liye
          }
        }

        await SharedPreferHelper.setPrefString("participantId", aspirationController.participantId.toString());
        await SharedPreferHelper.setPrefString("participantName", aspirationController.name.toString());
        await SharedPreferHelper.setPrefString("participantFatherName", aspirationController.fatherName.toString());
        await SharedPreferHelper.setPrefString("ProfileImage", aspirationController.profileImage.toString());

      await SharedPreferHelper.setPrefBool("cameFromFeedback", true);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Remark(fromFeedback: true),
        ),
      );
      // }
      // else {
      //   Navigator.pop(context, "refresh");
      // }
      return;
    }

    try {
      print("📤 Sending Payload: $feedback");

      Response response = await _dio.post(
        Api.BaseUrl + Api.addFeedback,
        data: feedback,
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        final res = response.data;
        if (res["status"] == "success") {
          List<dynamic> insertedIds = res["inserted_ids"] ?? [];
          int index = 0;

          print("insertedIds = ${res["inserted_ids"]}");
          print("selectedOptions count = ${selectedOptions.length}");
          feedback["status"] = "1";

          var now = DateTime.now();
          String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          String feedbackId = "";
          for (var entry in selectedOptions.entries) {
            String newFeedbackId = generateFeedbackId(); // alag naam

             feedbackId = insertedIds[index].toString();
            Map<String, dynamic> rowData = {
              "feedback_id": feedbackId,
              "coach_id": asp_controller.coachId.toString(),
              "aspiration_id": aspirationController.aspirationId.toString(),
              "participant_id": asp_controller.participantId.toString(),
              "asp_sub_cat_id": subCategoryId.toString(),
              "asp_cat_id": categoryId.toString(),

              "question_id": entry.key.toString(),
              "option_id": entry.value.toString(),

              "month": selectedMonth.toString(),
              "latitude": asp_controller.latitude.toString(),
              "longitude": asp_controller.longitude.toString(),
              "mobile_version": asp_controller.osVersion.toString(),
              "device_name": asp_controller.deviceName.toString(),
              "app_version": asp_controller.appVersion.toString(),
              "created_at": formattedDateTime,
            };


            FeedBackModel fb = FeedBackModel.fromMap(rowData);
            int feedbackLocalId = await DatabaseHelper.instance.insertFeedback(
                fb);
            print("✅ Inserted feedbackLocalId: ${feedbackId}");

            index++;
          }
          String aspirationId=await SharedPreferHelper.getPrefString("aspirationId","");
          await SharedPreferHelper.setPrefString("feedback_id", feedbackId);
          await aspirationController.getAllFeedBack(aspirationId);

          SmartDialog.dismiss();
          SmartDialog.showToast(" ${res["message"]}");
          // if (feedback["option_id"] == "1" || feedback["option_id"] == "2")  {
            var db = await DatabaseHelper.instance.database;
            List<Map<String, dynamic>> feedbackData = await db.query(
              'feedback',
              where: 'participant_id = ? AND aspiration_id = ?',
              whereArgs: [
                aspirationController.participantId,
                aspirationController.aspirationId,  //  current aspiration only
              ],

              orderBy: 'local_id ASC', // assuming id is autoincrement in feedback table
              // limit: 1,
            );

            if (feedbackData.isEmpty) {
              await SharedPreferHelper.setPrefString("participant_feedback_ids", "");

            } else {

              // List<String> feedbackIds = feedbackData
              //     .map((e) => e['feedback_id'].toString())
              //     .toList();
              Set<String> feedbackIds = feedbackData
                  .map((e) => e['feedback_id'].toString())
                  .toSet();
              await SharedPreferHelper.setPrefString(
                "participant_feedback_ids",
                feedbackIds.join(','),
              );

              for (var feedback in feedbackData) {
                String feedbackId = feedback['feedback_id'].toString();
                String optionId = feedback['option_id'].toString();
                String AspCatId = feedback['asp_sub_cat_id'].toString();
                String QuetionId = feedback['question_id'].toString();
                String aspId = feedback['aspiration_id'].toString();
                print('aspId $aspId');
                List<Map<String, dynamic>> aspirationData = await db.query(
                  'aspiration',
                  where: 'asp_details_id = ? AND participant_id = ?',
                  whereArgs: [aspId, aspirationController.participantId],
                );
                String remark = aspirationData.isNotEmpty
                    ? aspirationData.first['remarks'] ?? ''
                    : '';
                print('remarks $remark');
                await SharedPreferHelper.setPrefString("current_feedback_id", feedbackId);
                await SharedPreferHelper.setPrefString("Remark_$feedbackId", remark);
                // await SharedPreferHelper.setPrefString("OptionIds_$feedbackId$QuetionId", optionId);
                await SharedPreferHelper.setPrefString("SubCategory_$feedbackId", AspCatId);
                // await SharedPreferHelper.setPrefString("QuetionId_$feedbackId", QuetionId);

              }
            }

            await SharedPreferHelper.setPrefString("participantId", aspirationController.participantId.toString());
            await SharedPreferHelper.setPrefString("participantName", aspirationController.name.toString());
            await SharedPreferHelper.setPrefString("participantFatherName", aspirationController.fatherName.toString());
            await SharedPreferHelper.setPrefString("ProfileImage", aspirationController.profileImage.toString());
          await SharedPreferHelper.setPrefBool("cameFromFeedback", true);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Remark(fromFeedback: true),
            ),
          );

          // }
        //   else{
        //   Navigator.pop(context, "refresh");
        // }
        }else {
          SmartDialog.dismiss();
          SmartDialog.showToast("⚠️ ${res["message"] ?? "Something went wrong"}");
        }
      } else {
        SmartDialog.dismiss();
        SmartDialog.showToast("⚠️ Failed! Status: ${response.statusCode}");
      }
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast("❌ Error: $e");
      print("Error is $e");
    }
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
