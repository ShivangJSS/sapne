import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/BrandColors.dart';
import 'package:trikal_up/Controllers/aspiration_controller.dart';
import 'package:trikal_up/Modals/AspirationModel.dart';
import 'package:trikal_up/Modals/QuestionModel.dart';
import 'package:trikal_up/Modals/sub_category_list.dart';
import '../../Common/Api.dart';
import '../../Common/DatabaseHelper.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Modals/add_remark.dart';
import '../HomeScreen/HomeScreen.dart';
AspirationController rmkcontroller = Get.find<AspirationController>();

class Remark extends StatefulWidget {
  final bool fromFeedback;
  const Remark({this.fromFeedback = false, super.key});

  @override
  State<Remark> createState() => _RemarkState();
}

class _RemarkState extends State<Remark> {

  String name="",fatherName="",profileImage="",typeGone="";
  String SubCategoryImage ="", SubCategory ="", remarks ="", question ="", ParticipantFeedbackId ="";
  bool achievedIsActive=false,isVisible=true;
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    getInitialData();
    rmkcontroller.getData();
    rmkcontroller.getRemarkData();
    rmkcontroller.expandedFeedbackIds.clear();
    rmkcontroller.getLocation(context);
    setState(() {

    });
  }

  String notAchievedMonth="Not Applicable";
  String notAchievedSubmittedDate="Not Applicable";
  bool notAchievedIsActive=false;

  String partiallyAchievedMonth="Not Applicable";
  String partiallyAchievedSubmittedDate="Not Applicable";
  bool partiallyAchievedIsActive=false;
  bool partiallyAchievedISFilled=false;

  String achievedAchievedMonth="Not Applicable";
  String achievedAchievedSubmittedDate="Not Applicable";
  bool achievedAchievedISFilled=false;

  List<Map<String, dynamic>> SubCategoryList1 = [];
  String optionNameImage = "";
  String imageUrl = "";
  String optionName = "";
  String questionName = "";


  Future<void> getInitialData({bool fromFeedback = false}) async {
    typeGone = await SharedPreferHelper.getPrefString("typeGone", "");
    name = await SharedPreferHelper.getPrefString("participantName", "");
    fatherName = await SharedPreferHelper.getPrefString("participantFatherName", "");
    profileImage = await SharedPreferHelper.getPrefString("ProfileImage", "");

    setState(() {});

    String participantId = await SharedPreferHelper.getPrefString("participantId", "");
    String allFeedbackIds = await SharedPreferHelper.getPrefString("participant_feedback_ids", "");

    if (allFeedbackIds.isEmpty) {
      print("⚠️ No feedback found for this participant");
      return;
    }

    List<String> feedbackIds = allFeedbackIds
        .split(",")
        .where((e) => e.trim().isNotEmpty)
        .toSet()
        .toList();

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
    var db = await DatabaseHelper.instance.database;
    for (String feedbackId in feedbackIds) {
      List<Map<String, dynamic>> feedbackRows = await db.query(
        'feedback',
        where: 'feedback_id = ?',
        whereArgs: [feedbackId],
      );

      // for (var row in feedbackRows) {
      //   String QuetionId = row['question_id'].toString();
      // String subCategory = await SharedPreferHelper.getPrefString("SubCategory_$feedbackId", "");
      // String subCategoryImage = await SharedPreferHelper.getPrefString("SubCategoryImages_$feedbackId", "");
      // String optionIdsStr = await SharedPreferHelper.getPrefString("OptionIds_$feedbackId$QuetionId", "");
      // String questionIdStr = await SharedPreferHelper.getPrefString("QuetionId_$feedbackId", "");
      // String remark = await SharedPreferHelper.getPrefString("Remark_$feedbackId", "");
      //
      // final match = subCategoryList.firstWhere(
      //       (e) => e.asp_sub_cat_id.toString() == subCategory,
      //   orElse: () => SubCategoryList(
      //     asp_sub_cat_id: "",
      //     asp_sub_category_name: "",
      //     asp_sub_category_images: "",
      //   ),
      // );
      //
      // final question = questionList.firstWhere(
      //       (e) => e.question_id.toString() == questionIdStr,
      //   orElse: () => QuestionModel(
      //     question_id: "",
      //     question_name: "",
      //   ),
      // );
      //
      // String optionName = match.asp_sub_category_name ?? "";
      // String optionNameImage = match.asp_sub_category_images ?? "";
      // String imageUrl = "${Api.BaseUrl}${Api.AssetsImage}$optionNameImage";
      // String questionName = question.question_name ?? "";
      // print('remark $remark');
      // Map<String, dynamic> feedbackData = {
      //   "feedbackId": feedbackId,
      //   "participantId": participantId,
      //   "SubCategory": optionName,
      //   "SubCategoryImage": imageUrl,
      //   "optionIds": optionIdsStr,
      //   "Question": questionName,
      //   "Remark": remark,
      // };
      //
      // allFeedbackData.add(feedbackData);
      // }
      for (var row in feedbackRows) {
        String subCategory = await SharedPreferHelper.getPrefString("SubCategory_$feedbackId", "");
        String questionIdStr = row['question_id'].toString();
        String optionIdsStr = row['option_id'].toString();
        List<Map<String, dynamic>> remarkRows = await db.query(
          'remark',
          where: 'feedback_id = ? AND question_id = ?',
          whereArgs: [feedbackId, questionIdStr],
        );

        String createdAt = '';

        if (remarkRows.isNotEmpty) {
          createdAt = remarkRows.first['created_at']?.toString() ?? '';
        }
        String remark = await SharedPreferHelper.getPrefString("Remark_$feedbackId", "");
        final question = questionList.firstWhere(
              (e) => e.question_id.toString() == questionIdStr,
          orElse: () => QuestionModel(
            question_id: "",
            question_name: "",
          ),
        );
        final match = subCategoryList.firstWhere(
              (e) => e.asp_sub_cat_id.toString() == subCategory,
          orElse: () => SubCategoryList(
            asp_sub_cat_id: "",
            asp_sub_category_name: "",
            asp_sub_category_images: "",
          ),
        );

        String optionName = match.asp_sub_category_name ?? "";
        String optionNameImage = match.asp_sub_category_images ?? "";
        String questionName = question.question_name ?? "";
        String imageUrl = "${Api.BaseUrl}${Api.AssetsImage}$optionNameImage";
        Map<String, dynamic> feedbackData = {
          "feedbackId": feedbackId,
          "question_id": questionIdStr,
          "participantId": participantId,
          "SubCategory": optionName,
          "SubCategoryImage": imageUrl,
          "optionIds": optionIdsStr,
          "Question": questionName,
          "Remark": remark,
          "createdAt": createdAt
        };

        allFeedbackData.add(feedbackData);
      }    }

    rmkcontroller.feedbackDataList.assignAll(allFeedbackData);

    print("✅ Loaded ${allFeedbackData.length} feedback(s): $allFeedbackData");

    setState(() {});
  }
// Helper function banao class mein
  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return dateStr;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "remark_appbaar_text".tr,
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
      body: SingleChildScrollView(
          child:Column(
            children: [
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // ✅ Father Name
                                Text(
                                  "${'father_name'.tr}: ${fatherName ?? ''}",
                                  style: const TextStyle(
                                    fontSize: 15,
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




              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rmkcontroller.feedbackDataList.length,
                  itemBuilder: (context, index) {
                    var feedback = rmkcontroller.feedbackDataList[index];
                    String feedbackId = feedback['feedbackId'] ?? "";
                    String QuestionId = feedback['question_id'] ?? "";
                    final isExpandeds = rmkcontroller.isExpanded(feedbackId);
                    print('isExpandeds $isExpandeds');
                    print('feedbackId $feedbackId');
                    // if (feedback['optionIds'] != null && feedback['optionIds'].contains("3")) {
                    //   return SizedBox.shrink();
                    // }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // SubCategory Image
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.grey.shade300, width: 2),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: CachedNetworkImage(
                                            imageUrl: feedback['SubCategoryImage'] ?? "",
                                            fit: BoxFit.contain,
                                            alignment: Alignment.center,
                                            placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error, color: Colors.redAccent),
                                          ),
                                        ),
                                        const SizedBox(width: 15),

                                        // SubCategory Name
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                feedback['SubCategory'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 6),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    feedback['Remark'],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                  if (feedback['createdAt'] != null && feedback['createdAt'].toString().isNotEmpty)
                                                    Row(
                                                      children: [
                                                        const Icon(Icons.calendar_today, size: 14, color: Colors.black),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          formatDate(feedback['createdAt'].toString()), // ✅ formatted date
                                                          style: const TextStyle(fontSize: 12, color: Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              Text(
                                                feedback['Question'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  // fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _buildVerticalStep(
                                                iconPath: "assets/notred.png",
                                                isSelected: feedback['optionIds'].contains("1"),
                                              ),
                                              _buildVerticalStep(
                                                iconPath: "assets/notachivee.png",
                                                isSelected: feedback['optionIds'].contains("2"),
                                              ),
                                              _buildVerticalStep(
                                                iconPath: "assets/achivegreen.png",
                                                isSelected: feedback['optionIds'].contains("3"),
                                              ),
                                              SizedBox(height: 10),

                                              // ElevatedButton(
                                              //   style: ElevatedButton.styleFrom(
                                              //     backgroundColor: BrandColors.apporangeColor,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius: BorderRadius.circular(12),
                                              //     ),
                                              //   ),
                                              //   onPressed: () {
                                              //     rmkcontroller.toggleCard(feedbackId);
                                              //     print("Tapped Feedback ID: $feedbackId");                               },
                                              //   child: Text(
                                              //     isExpandeds ? "remarks".tr : "remarks".tr,
                                              //     style: const TextStyle(color: Colors.white),
                                              //   ),
                                              // ),

                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: BrandColors.apporangeColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  minimumSize: const Size(40, 28), // width, height
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                ),
                                                onPressed: () async {
                                                  if (rmkcontroller.isExpanded(feedbackId)) {
                                                    rmkcontroller.toggleCard(feedbackId);
                                                    return; // bas close karo, kuch aur mat karo
                                                  }

                                                  rmkcontroller.expandedFeedbackIds.clear();
                                                  var remarkData = await DatabaseHelper.instance.getRemarkByFeedbackId(feedbackId,QuestionId);

                                                  if (remarkData != null) {
                                                    String cats =
                                                        remarkData[AddRmk.columnChallengeCat]
                                                            ?.toString() ?? "";

                                                    rmkcontroller.selectedChlnCategories.clear();

                                                    if(cats.isNotEmpty){

                                                      rmkcontroller.selectedChlnCategories
                                                          .assignAll(
                                                          cats.split(",")
                                                      );

                                                    }

                                                    await rmkcontroller.loadSubCategories();

                                                    String subs =
                                                        remarkData[AddRmk.columnChallengeSubCat]
                                                            ?.toString() ?? "";

                                                    rmkcontroller.selectedChlnSubCategories.clear();

                                                    if(subs.isNotEmpty){

                                                      rmkcontroller.selectedChlnSubCategories
                                                          .assignAll(
                                                          subs.split(",")
                                                      );

                                                    }

                                                    rmkcontroller.C_OtherReason.text =
                                                        remarkData[AddRmk.columnOtherChallengeText]
                                                            ?.toString() ?? "";
                                                    rmkcontroller.C_OtherReason.text=remarkData[AddRmk.columnOtherChallengeText].toString();

                                                    rmkcontroller.selected_waychln_ctgry.value=remarkData[AddRmk.columnWayFrowordCat].toString();
                                                    rmkcontroller.onWayCatChanged(remarkData[AddRmk.columnWayFrowordCat].toString());
                                                    rmkcontroller.W_OtherReason.text=remarkData[AddRmk.columnOtherWayText].toString();
                                                    rmkcontroller.selected_way_sbctgry.value=remarkData[AddRmk.columnChlWayforwordSubCat].toString();
                                                    rmkcontroller.isRemarkEmpty.value = false;
                                                    await SharedPreferHelper.setPrefString("feedback_id", "");
                                                    await SharedPreferHelper.setPrefString("question_id", "");


                                                    setState(() {

                                                    });

                                                  } else {
                                                    print("No remark found for this feedback id $feedbackId" );
                                                    rmkcontroller.selectedChlnCategory.value = "";
                                                    rmkcontroller.selectedChlnSubCategory.value = "";
                                                    rmkcontroller.C_OtherReason.clear();

                                                    rmkcontroller.selected_waychln_ctgry.value = "";
                                                    rmkcontroller.selected_way_sbctgry.value = "";
                                                    rmkcontroller.W_OtherReason.clear();
                                                    rmkcontroller.isRemarkEmpty.value = true;

                                                  }
                                                  await SharedPreferHelper.setPrefString("feedback_id", feedbackId ?? "");
                                                  await SharedPreferHelper.setPrefString("question_id", QuestionId ?? "");
                                                  print('ff ${feedbackId}');
                                                  print('que ${QuestionId}');

                                                  rmkcontroller.toggleCard(feedbackId);
                                                  print("Tapped Feedback ID: $feedbackId");                               },
                                                child: Text(
                                                  isExpandeds ? "remarks".tr : "remarks".tr,
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ),                                    ],
                                          ),
                                        ]),
                                  ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Obx(() {
                          if (rmkcontroller.isExpanded(feedbackId)) {

                            return Column(
                                children: [
                                  //   Expanded(child:
                                  ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(6),
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Challenges Section
                                              Text("challenge".tr, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                                              const SizedBox(height: 8),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Category Label
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 6, left: 4),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "select_category".tr,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "*",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Obx(() => Row(
                                                    children: [

                                                      Expanded(

                                                        child: Column(

                                                          children: [

                                                            GestureDetector(

                                                              onTap: () {

                                                                rmkcontroller.isCategoryExpanded.toggle();

                                                              },

                                                              child: Container(

                                                                width: double.infinity,

                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 16,
                                                                  vertical: 18,
                                                                ),

                                                                decoration: BoxDecoration(

                                                                  border: Border.all(
                                                                    color: BrandColors.apporangeColor,
                                                                  ),

                                                                  borderRadius: BorderRadius.circular(14),

                                                                  color: Colors.white,

                                                                ),

                                                                child: Row(

                                                                  children: [

                                                                    Expanded(

                                                                      child: Text(

                                                                        rmkcontroller.selectedChlnCategories.isEmpty

                                                                            ?

                                                                        "select_category".tr

                                                                            :

                                                                        rmkcontroller.challengeCategories

                                                                            .where(

                                                                                (cat)=>

                                                                                rmkcontroller.selectedChlnCategories

                                                                                    .contains(

                                                                                    cat.challenges_cat_code

                                                                                )

                                                                        )

                                                                            .map(

                                                                                (cat)=>

                                                                            cat.challenges_cat_name ?? ""

                                                                        )

                                                                            .join(", "),

                                                                        maxLines: 2,

                                                                        overflow: TextOverflow.ellipsis,

                                                                      ),

                                                                    ),

                                                                    Icon(

                                                                      rmkcontroller.isCategoryExpanded.value

                                                                          ?

                                                                      Icons.keyboard_arrow_up

                                                                          :

                                                                      Icons.keyboard_arrow_down,

                                                                    )

                                                                  ],

                                                                ),

                                                              ),

                                                            ),

                                                            if(rmkcontroller.isCategoryExpanded.value)

                                                              Container(

                                                                margin: const EdgeInsets.only(top: 5),

                                                                decoration: BoxDecoration(

                                                                  color: Colors.white,

                                                                  border: Border.all(
                                                                    color: Colors.grey.shade300,
                                                                  ),

                                                                  borderRadius: BorderRadius.circular(14),

                                                                ),

                                                                child: Column(

                                                                  children:

                                                                  rmkcontroller.challengeCategories

                                                                      .map((cat){

                                                                    return CheckboxListTile(

                                                                      dense: true,

                                                                      controlAffinity:

                                                                      ListTileControlAffinity.leading,

                                                                      value:

                                                                      rmkcontroller.selectedChlnCategories

                                                                          .contains(

                                                                          cat.challenges_cat_code

                                                                      ),

                                                                      title: Text(

                                                                        cat.challenges_cat_name ?? "",

                                                                      ),

                                                                      onChanged: (value){

                                                                        rmkcontroller.onChlnCategoryChanged(

                                                                          cat.challenges_cat_code ?? "",

                                                                          value ?? false,

                                                                        );

                                                                      },

                                                                    );

                                                                  }).toList(),

                                                                ),

                                                              )

                                                          ],

                                                        ),

                                                      ),

                                                    ],

                                                  )),
                                                  const SizedBox(height: 16),

// SubCategory Label
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 6, left: 4),
                                                    child: Row(
                                                      children: [
                                                        Obx(
                                                              () => Text(
                                                            rmkcontroller.selectedChlnCategories.contains("7")
                                                                ? "Other_reason".tr
                                                                : "select_sub_category".tr,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.black87,
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(width: 4),

                                                        const Text(
                                                          "*",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Obx(() {
                                                    return rmkcontroller.selectedChlnCategories.contains("7")

                                                        ? TextField(
                                                      controller: rmkcontroller.C_OtherReason,
                                                      minLines: 2,
                                                      maxLines: 5,
                                                      decoration: InputDecoration(
                                                        hintText: "Enter Other Reason",
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(14),
                                                          borderSide: const BorderSide(
                                                            color: BrandColors.apporangeColor,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(14),
                                                          borderSide: const BorderSide(
                                                            color: BrandColors.apporangeColor,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(14),
                                                          borderSide: const BorderSide(
                                                            color: BrandColors.apporangeColor,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                    )

                                                        : Column(
                                                      children: [

                                                        GestureDetector(
                                                          onTap: () {
                                                            rmkcontroller.isSubCategoryExpanded.toggle();
                                                          },

                                                          child: Container(
                                                            width: double.infinity,

                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 16,
                                                              vertical: 18,
                                                            ),

                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: BrandColors.apporangeColor,
                                                              ),

                                                              borderRadius: BorderRadius.circular(14),

                                                              color: Colors.white,
                                                            ),

                                                            child: Row(
                                                              children: [

                                                                Expanded(
                                                                  child: Text(
                                                                    rmkcontroller.selectedChlnSubCategories.isEmpty
                                                                        ? "select_sub_category".tr
                                                                        : rmkcontroller.allChlnSubCategories
                                                                        .where(
                                                                          (sub) => rmkcontroller
                                                                          .selectedChlnSubCategories
                                                                          .contains(
                                                                        sub.challenges_sub_cat_code,
                                                                      ),
                                                                    )
                                                                        .map(
                                                                          (sub) =>
                                                                      sub.challenges_sub_cat_name ?? "",
                                                                    )
                                                                        .join(", "),

                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),

                                                                Icon(
                                                                  rmkcontroller.isSubCategoryExpanded.value
                                                                      ? Icons.keyboard_arrow_up
                                                                      : Icons.keyboard_arrow_down,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),

                                                        if (rmkcontroller.isSubCategoryExpanded.value)
                                                          Container(
                                                            margin: const EdgeInsets.only(top: 5),

                                                            decoration: BoxDecoration(
                                                              color: Colors.white,

                                                              border: Border.all(
                                                                color: Colors.grey.shade300,
                                                              ),

                                                              borderRadius: BorderRadius.circular(14),
                                                            ),

                                                            child: Column(

                                                              crossAxisAlignment: CrossAxisAlignment.start,

                                                              children:

                                                              rmkcontroller.selectedChlnCategories

                                                                  .map((catCode) {

                                                                final cat =

                                                                rmkcontroller.challengeCategories.firstWhere(

                                                                      (e) =>

                                                                  e.challenges_cat_code == catCode,

                                                                );

                                                                final subs =

                                                                rmkcontroller.allChlnSubCategories

                                                                    .where(

                                                                      (e) =>

                                                                  e.challenges_cat_id == catCode,

                                                                )

                                                                    .toList();

                                                                return Column(

                                                                  crossAxisAlignment:

                                                                  CrossAxisAlignment.start,

                                                                  children: [

                                                                    Padding(

                                                                      padding:

                                                                      const EdgeInsets.only(

                                                                        left: 16,

                                                                        top: 12,

                                                                        bottom: 5,

                                                                      ),

                                                                      child: Text(

                                                                        cat.challenges_cat_name ?? "",

                                                                        style:

                                                                        const TextStyle(

                                                                          fontWeight:

                                                                          FontWeight.bold,

                                                                          fontSize: 16,

                                                                        ),

                                                                      ),

                                                                    ),

                                                                    ...subs.map(

                                                                          (sub) {

                                                                        return CheckboxListTile(

                                                                          dense: true,

                                                                          controlAffinity:

                                                                          ListTileControlAffinity.leading,

                                                                          value:

                                                                          rmkcontroller

                                                                              .selectedChlnSubCategories

                                                                              .contains(

                                                                            sub.challenges_sub_cat_code,

                                                                          ),

                                                                          title: Text(

                                                                            sub.challenges_sub_cat_name

                                                                                ?? "",

                                                                          ),

                                                                          onChanged: (value) {

                                                                            rmkcontroller

                                                                                .onSubchlnChanged(

                                                                              sub.challenges_sub_cat_code

                                                                                  ?? "",

                                                                              value ?? false,

                                                                            );

                                                                          },

                                                                        );

                                                                      },

                                                                    )

                                                                  ],

                                                                );

                                                              }).toList(),

                                                            ),
                                                          ),
                                                      ],
                                                    );
                                                  }),

                                                  const SizedBox(height: 15),

                                                  Obx(() {
                                                    if (rmkcontroller.selectedChlnCategory.value == "1" &&
                                                        rmkcontroller.selectedChlnSubCategory.value == "6") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.C_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),


                                                  Obx(() {
                                                    if (rmkcontroller.selectedChlnCategory.value == "2" &&
                                                        rmkcontroller.selectedChlnSubCategory.value == "11") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.C_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),




                                                  Obx(() {
                                                    if (rmkcontroller.selectedChlnCategory.value == "3" &&
                                                        rmkcontroller.selectedChlnSubCategory.value == "19") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.C_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),

                                                  Obx(() {
                                                    if (rmkcontroller.selectedChlnCategory.value == "4" &&
                                                        rmkcontroller.selectedChlnSubCategory.value == "25") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.C_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),

                                                  Obx(() {
                                                    if (rmkcontroller.selectedChlnCategory.value == "5" &&
                                                        rmkcontroller.selectedChlnSubCategory.value == "33") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.C_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),
                                                  Obx(() {
                                                    if (rmkcontroller.selectedChlnCategory.value == "6" &&
                                                        rmkcontroller.selectedChlnSubCategory.value == "38") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.C_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  })
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Challenges Section
                                              Text("way_forword".tr, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                                              const SizedBox(height: 8),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Wayforword Label
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 6, left: 4),
                                                    child: Row(
                                                      children: [
                                                        Text("select_category".tr,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "*",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    // height: 49,
                                                    child: Obx(() {
                                                      final items = rmkcontroller.challengeWayCategories
                                                          .map((c) => DropdownMenuItem<String>(
                                                        value: c.way_forward_cat_code ?? "",
                                                        child: Text(
                                                          c.way_forward_cat_name ?? "",
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black87,
                                                          ),
                                                          overflow: TextOverflow.visible,
                                                          maxLines: 2,
                                                        ),
                                                      ))
                                                          .toList();

                                                      // selected value safe check
                                                      final selectedValue = (rmkcontroller.selected_waychln_ctgry.value.isNotEmpty &&
                                                          items.any((item) => item.value == rmkcontroller.selected_waychln_ctgry.value))
                                                          ? rmkcontroller.selected_waychln_ctgry.value
                                                          : null;

                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child: DropdownButtonFormField<String>(
                                                              isExpanded: true,
                                                              value: selectedValue,
                                                              dropdownColor: Colors.white,
                                                              decoration: InputDecoration(
                                                                hintText: "select_category".tr,
                                                                filled: true,
                                                                fillColor: Colors.white,
                                                                hintStyle: TextStyle(
                                                                  color: Colors.grey[500],
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                contentPadding: EdgeInsets.symmetric(
                                                                  horizontal: 16,
                                                                  vertical: MediaQuery.of(context).size.height < 820
                                                                      ? 28   // Redmi Note 5 Pro, chhote phones
                                                                      : 26,  // bade phones
                                                                ),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(14),
                                                                  borderSide: BorderSide(
                                                                      color: BrandColors.apporangeColor, width: 1),
                                                                ),
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(14),
                                                                  borderSide: BorderSide(
                                                                      color: BrandColors.apporangeColor, width: 1),
                                                                ),
                                                                focusedBorder: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(14),
                                                                  borderSide: BorderSide(
                                                                    color: BrandColors.apporangeColor,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                              ),
                                                              items: items,
                                                              onChanged: rmkcontroller.onWayCatChanged,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  // Way Forword sub Label
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 6, left: 4),
                                                    child: Row(
                                                      children: [
                                                        Obx(()=>Text((rmkcontroller.selected_waychln_ctgry.value == "8") ? "Other_reason".tr :"select_sub_category".tr,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "*",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Obx(() {
                                                    return rmkcontroller.selected_waychln_ctgry.value == "8"
                                                        ? TextField(
                                                      controller: rmkcontroller.W_OtherReason,
                                                      minLines: 2,
                                                      maxLines: 5,
                                                      decoration: InputDecoration(
                                                        hintText: "Enter Other Reason",
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(14),
                                                          borderSide: BorderSide(
                                                            color: BrandColors.apporangeColor,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(14),
                                                          borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(14),
                                                          borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1.5),
                                                        ),
                                                      ),
                                                    )
                                                        : SizedBox(
                                                      // height: 49,
                                                      child: DropdownButtonFormField<String>(
                                                        isExpanded: true,
                                                        // value: rmkcontroller.selected_way_sbctgry.value.isNotEmpty
                                                        //     ? rmkcontroller.selected_way_sbctgry.value
                                                        //     : null,
                                                        value: (
                                                            rmkcontroller.selected_way_sbctgry.value.isNotEmpty &&
                                                                rmkcontroller.allWaySubCategories.any(
                                                                        (item) =>
                                                                    item.way_forward_sub_cat_code ==
                                                                        rmkcontroller.selected_way_sbctgry.value
                                                                )
                                                        )
                                                            ? rmkcontroller.selected_way_sbctgry.value
                                                            : null,


                                                        dropdownColor: Colors.white,
                                                        decoration: InputDecoration(
                                                          hintText: "select_sub_category".tr,
                                                          filled: true,
                                                          fillColor: Colors.white,
                                                          hintStyle: TextStyle(
                                                            color: Colors.grey[500],
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                          contentPadding: EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: MediaQuery.of(context).size.height < 820
                                                                ? 28   // Redmi Note 5 Pro, chhote phones
                                                                : 26,  // bade phones
                                                          ),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(14),
                                                            borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(14),
                                                            borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(14),
                                                            borderSide: BorderSide(color: BrandColors.apporangeColor, width: 1.5),
                                                          ),
                                                        ),
                                                        items: rmkcontroller.allWaySubCategories
                                                            .map((c) => DropdownMenuItem(
                                                          value: c.way_forward_sub_cat_code,
                                                          child: Text(
                                                            c.way_forward_sub_cat_name ?? "",
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black87,
                                                            ),
                                                            overflow: TextOverflow.visible,
                                                            maxLines: 2,
                                                          ),
                                                        ))
                                                            .toList(),
                                                        onChanged: rmkcontroller.onSubWayChanged,
                                                      ),
                                                    );
                                                  }),

                                                  const SizedBox(height: 16),

                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "1" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "9") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),




                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "2" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "17") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),


                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "3" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "23") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),

                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "4" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "29") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),

                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "5" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "35") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),

                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "6" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "40") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),

                                                  Obx(() {
                                                    if (rmkcontroller.selected_waychln_ctgry.value == "7" &&
                                                        rmkcontroller.selected_way_sbctgry.value == "44") {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: 6, left: 4),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Other_reason".tr,
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black87,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  "*",
                                                                  style: TextStyle(
                                                                    color: Colors.red,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          TextField(
                                                            controller: rmkcontroller.W_OtherReason,
                                                            minLines: 2,
                                                            maxLines: 5,
                                                            decoration: InputDecoration(
                                                              hintText: "Enter Other Reason",
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(14),
                                                                borderSide: BorderSide(
                                                                  color: BrandColors.apporangeColor,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }

                                                    return SizedBox();
                                                  }),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Obx(() {
                                        return rmkcontroller.isRemarkEmpty.value
                                            ?  Padding(
                                          padding: const EdgeInsets.only(bottom: 18.0),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: BrandColors.apporangeColor,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                            ),
                                            onPressed: () {

                                              if(rmkcontroller.selectedChlnCategory.value.isEmpty){
                                                print("a");
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"),backgroundColor: Colors.redAccent,));
                                                return;
                                              }
                                              if(rmkcontroller.selectedChlnCategory.value == "7"){
                                                if(rmkcontroller.C_OtherReason.text.isEmpty) {
                                                  print("b");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if(rmkcontroller.selectedChlnCategory.value != "7"){
                                                if(rmkcontroller.selectedChlnSubCategory.value.isEmpty) {
                                                  print("c");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }

                                              if (rmkcontroller.selectedChlnCategory.value == "1" &&
                                                  rmkcontroller.selectedChlnSubCategory.value == "6") {


                                                if (rmkcontroller.C_OtherReason.text.trim().isEmpty) {
                                                  print("p");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selectedChlnCategory.value == "2" &&
                                                  rmkcontroller.selectedChlnSubCategory.value == "11") {


                                                if (rmkcontroller.C_OtherReason.text.trim().isEmpty) {
                                                  print("q");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selectedChlnCategory.value == "3" &&
                                                  rmkcontroller.selectedChlnSubCategory.value == "19") {


                                                if (rmkcontroller.C_OtherReason.text.trim().isEmpty) {
                                                  print("r");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selectedChlnCategory.value == "4" &&
                                                  rmkcontroller.selectedChlnSubCategory.value == "25") {


                                                if (rmkcontroller.C_OtherReason.text.trim().isEmpty) {
                                                  print("s");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selectedChlnCategory.value == "5" &&
                                                  rmkcontroller.selectedChlnSubCategory.value == "33") {


                                                if (rmkcontroller.C_OtherReason.text.trim().isEmpty) {
                                                  print("t");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selectedChlnCategory.value == "6" &&
                                                  rmkcontroller.selectedChlnSubCategory.value == "38") {


                                                if (rmkcontroller.C_OtherReason.text.trim().isEmpty) {
                                                  print("u");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if(rmkcontroller.selected_waychln_ctgry.value.isEmpty){
                                                print("d");
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                return;
                                              }
                                              if(rmkcontroller.selected_waychln_ctgry.value == "8"){
                                                if(rmkcontroller.W_OtherReason.text.isEmpty) {
                                                  print("e");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if(rmkcontroller.selected_waychln_ctgry.value != "8"){
                                                if(rmkcontroller.selected_way_sbctgry.value.isEmpty) {
                                                  print("f");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selected_waychln_ctgry.value == "1" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "9") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("P");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }

                                              if (rmkcontroller.selected_waychln_ctgry.value == "2" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "17") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("Q");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selected_waychln_ctgry.value == "3" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "23") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("R");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selected_waychln_ctgry.value == "4" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "29") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("S");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selected_waychln_ctgry.value == "5" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "35") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("T");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selected_waychln_ctgry.value == "6" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "40") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("U");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              if (rmkcontroller.selected_waychln_ctgry.value == "7" &&
                                                  rmkcontroller.selected_way_sbctgry.value == "44") {


                                                if (rmkcontroller.W_OtherReason.text.trim().isEmpty) {
                                                  print("V");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill out all fields!"), backgroundColor: Colors.redAccent,));
                                                  return;
                                                }
                                              }
                                              rmkcontroller.remarkdata(context);
                                            },
                                            child: Text("submit".tr, style: TextStyle(color: Colors.white)),
                                          ),
                                        ) : SizedBox.shrink(); // HIDE BUTTON
                                      }),
                                    ],
                                  ),
                                ]);}
                          else {
                            return SizedBox.shrink();
                          }})
                      ],
                    );
                  },
                );
              }),





            ],
          )),
    );
  }


  void _showCongratsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events,
                    color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  "🎉 Congratulations!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You have successfully achieved your goal!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("OK", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildConnectorLine({
    required bool isFilled,
    required Color startColor,
    required Color endColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 55,
        width: 3,
        decoration: BoxDecoration(
          gradient: isFilled
              ? const LinearGradient(
            colors: [Colors.green, Colors.greenAccent], // ✅ Green when complete
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
              : null,
          color: isFilled ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildVerticalStep({
    required String iconPath,
    required bool isSelected, // new parameter
  }) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.green.withOpacity(0.3) : Colors.transparent, // highlight
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              width: iconPath.contains("notred.png") ? 40 : 55,
              height: iconPath.contains("notred.png") ? 40 : 55,
            ),
          ),
        ),
      ],
    );
  }


}
