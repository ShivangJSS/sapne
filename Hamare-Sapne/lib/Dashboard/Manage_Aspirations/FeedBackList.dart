import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Controllers/aspiration_controller.dart';
import '../../Controllers/family_controller.dart';
import '../../Modals/QuestionModel.dart';
import '../HomeScreen/HomeScreen.dart';
import 'Add_aspiration.dart';
import 'FeedBackNew.dart';

class FeedBackListNew extends StatefulWidget {
  const FeedBackListNew({super.key});

  @override
  State<FeedBackListNew> createState() => _FeedBackListNewState();
}

class _FeedBackListNewState extends State<FeedBackListNew> {
  AspirationController aspctr = Get.find<AspirationController>();
  familyController f = Get.find<familyController>();
  String name="",fatherName="",languageId="",profileImage="",question="",typeGone="",aspirationId="",remarks="",SubCategory="",SubCategoryImage="";
  String? selectedMonth;
  final List<Map<String, dynamic>> options = [
    {"id":1,"label": "not_achieved", "icon": "assets/notred.png"},
    {"id":2,"label": "partially_achieved", "icon": "assets/notachivee.png"},
    {"id":3,"label": "achieved", "icon": "assets/achivegreen.png"},


  ];

  String notAchievedMonth="Not Applicable";
  String notAchievedSubmittedDate="Not Applicable";
  bool notAchievedIsActive=false;

  String partiallyAchievedMonth="Not Applicable";
  String partiallyAchievedSubmittedDate="Not Applicable";
  bool partiallyAchievedIsActive=false;
  bool partiallyAchievedISFilled=false;

  String achievedAchievedMonth="Not Applicable";
  String achievedAchievedSubmittedDate="Not Applicable";
  bool achievedIsActive=false,isVisible=true;
  bool achievedAchievedISFilled=false;


  @override
  void initState() {
    super.initState();
    getData();
    // f.getOneFamily(widget.p_id.toString());
  }
  // Future<void> getData() async {
  //   aspctr.feedBackList.clear();
  //   SubCategory=await SharedPreferHelper.getPrefString("SubCategory","");
  //   SubCategoryImage=await SharedPreferHelper.getPrefString("SubCategoryImage","");
  //   remarks=await SharedPreferHelper.getPrefString("remarks","");
  //   languageId=await SharedPreferHelper.getPrefString("languageId","");
  //   aspirationId=await SharedPreferHelper.getPrefString("aspirationId","");
  //   aspctr.getAllFeedBack(aspirationId);
  //
  //   name=await SharedPreferHelper.getPrefString("participantName","");
  //   fatherName=await SharedPreferHelper.getPrefString("participantFatherName","");
  //   profileImage=await SharedPreferHelper.getPrefString("ProfileImage","");
  //   selectedMonth=await SharedPreferHelper.getPrefString("selectedMonth","");
  //   // await SharedPreferHelper.setPrefString("participantId",widget.p_id.toString());
  //   // await asp_controller.getData();
  //   // await asp_controller.getAllCategory();
  //   // await asp_controller.loadSubcategories();
  //   await asp_controller.getSubCategoryQuestion();
  //   await aspctr.getAllFeedBack(aspirationId);
  //   if(aspctr.feedBackList.isNotEmpty){
  //     for (var feedback in aspctr.feedBackList) {
  //       String month = feedback['month'] ?? '';
  //       String optionId = feedback['option_id'] ?? '';
  //       String questionId = feedback['question_id'] ?? '';
  //       String createdAt = feedback['created_at'] ?? '';
  //       question=getQuestionById(questionId, languageId, aspctr.subCategoriesQuestion!)!;
  //       if(optionId=="1"){
  //         notAchievedMonth=month;
  //         notAchievedSubmittedDate=createdAt;
  //         notAchievedIsActive=true;
  //       }else if(optionId=="2"){
  //         partiallyAchievedMonth=month;
  //         partiallyAchievedSubmittedDate=createdAt;
  //         partiallyAchievedIsActive=true;
  //         partiallyAchievedISFilled=true;
  //       }else if(optionId=="3"){
  //         isVisible=false;
  //         achievedAchievedMonth=month;
  //         achievedAchievedSubmittedDate=createdAt;
  //         achievedIsActive=true;
  //         achievedAchievedISFilled=true;
  //       }
  //
  //     }
  //   }
  //
  //   setState(() {});
  //
  // }
// Question-wise grouped map
  Map<String, Map<String, dynamic>> questionFeedbackMap = {};

  Future<void> getData() async {
    aspctr.feedBackList.clear();
    questionFeedbackMap.clear();

     SubCategory=await SharedPreferHelper.getPrefString("SubCategory","");
      SubCategoryImage=await SharedPreferHelper.getPrefString("SubCategoryImage","");
      remarks=await SharedPreferHelper.getPrefString("remarks","");
      languageId=await SharedPreferHelper.getPrefString("languageId","");
      aspirationId=await SharedPreferHelper.getPrefString("aspirationId","");
      aspctr.getAllFeedBack(aspirationId);

      name=await SharedPreferHelper.getPrefString("participantName","");
      fatherName=await SharedPreferHelper.getPrefString("participantFatherName","");
      profileImage=await SharedPreferHelper.getPrefString("ProfileImage","");
      selectedMonth=await SharedPreferHelper.getPrefString("selectedMonth","");
    await aspctr.getAllFeedBack(aspirationId);
    await asp_controller.getSubCategoryQuestion();
    await aspctr.getAllFeedBack(aspirationId);

    if (aspctr.feedBackList.isNotEmpty) {
      for (var feedback in aspctr.feedBackList) {
        String questionId = feedback['question_id'] ?? '';
        String optionId   = feedback['option_id'] ?? '';
        String month      = feedback['month'] ?? '';
        String createdAt  = feedback['created_at'] ?? '';

        String qText = getQuestionById(
            questionId, languageId, aspctr.subCategoriesQuestion!
        ) ?? questionId;

        // Agar question pehle se nahi hai toh initialize karo
        if (!questionFeedbackMap.containsKey(questionId)) {
          questionFeedbackMap[questionId] = {
            'questionText': qText,
            'notAchievedMonth': 'Not Applicable',
            'notAchievedDate': 'Not Applicable',
            'notAchievedIsActive': false,
            'partiallyMonth': 'Not Applicable',
            'partiallyDate': 'Not Applicable',
            'partiallyIsActive': false,
            'partiallyIsFilled': false,
            'achievedMonth': 'Not Applicable',
            'achievedDate': 'Not Applicable',
            'achievedIsActive': false,
            'achievedIsFilled': false,
            'isVisible': true,
          };
        }

        // Option ke hisaab se fill karo
        if (optionId == "1") {
          questionFeedbackMap[questionId]!['notAchievedMonth']    = month;
          questionFeedbackMap[questionId]!['notAchievedDate']     = createdAt;
          questionFeedbackMap[questionId]!['notAchievedIsActive'] = true;
        } else if (optionId == "2") {
          questionFeedbackMap[questionId]!['partiallyMonth']    = month;
          questionFeedbackMap[questionId]!['partiallyDate']     = createdAt;
          questionFeedbackMap[questionId]!['partiallyIsActive'] = true;
          questionFeedbackMap[questionId]!['partiallyIsFilled'] = true;
        } else if (optionId == "3") {
          questionFeedbackMap[questionId]!['achievedMonth']    = month;
          questionFeedbackMap[questionId]!['achievedDate']     = createdAt;
          questionFeedbackMap[questionId]!['achievedIsActive'] = true;
          questionFeedbackMap[questionId]!['achievedIsFilled'] = true;
          questionFeedbackMap[questionId]!['isVisible']        = false;
        }
      }
    }
// Agar koi feedback nahi mila, toh bhi ek default card dikhao
    if (questionFeedbackMap.isEmpty && aspctr.subCategoriesQuestion != null && aspctr.subCategoriesQuestion!.isNotEmpty) {
      // Pehla question lo
      final firstQuestion = aspctr.subCategoriesQuestion!.first;
      final qId = firstQuestion.question_id_code ?? '';
      final qText = getQuestionById(qId, languageId, aspctr.subCategoriesQuestion!) ?? '';

      questionFeedbackMap[qId] = {
        'questionText': '',
        'notAchievedMonth': 'Not Applicable',
        'notAchievedDate': 'Not Applicable',
        'notAchievedIsActive': false,
        'partiallyMonth': 'Not Applicable',
        'partiallyDate': 'Not Applicable',
        'partiallyIsActive': false,
        'partiallyIsFilled': false,
        'achievedMonth': 'Not Applicable',
        'achievedDate': 'Not Applicable',
        'achievedIsActive': false,
        'achievedIsFilled': false,
        'isVisible': true,
      };
    }

    setState(() {});

  }
  String img = "assets/f_incul.png";


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
                  "feedback_list".tr,
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

        // 🟢 BODY
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 👤 Participant Card (Top)
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
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: BrandColors.appColor.withOpacity(0.2),
                          backgroundImage: (profileImage != null && profileImage.isNotEmpty)
                              ? (profileImage.startsWith('/data/') || profileImage.startsWith('/storage/')
                              ? FileImage(File(profileImage)) as ImageProvider
                              : null)
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
                              placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                            ),
                          ))
                              : const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? "",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
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
                    ),
                  ),
                ),
              ),



              const SizedBox(height: 10),

              // 🌟 Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.teal, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "feedback_progress".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Card(
              //     elevation: 6,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //     shadowColor: Colors.grey.withOpacity(0.3),
              //     color: Colors.white,
              //     child: Padding(
              //       padding: const EdgeInsets.all(20.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           // 🟢 Detail Section
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               // 🟢 Circle Image
              //               Container(
              //                 width: 80, // you can adjust width/height as needed
              //                 height: 80,
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(15), // 🟢 Rounded rectangle look
              //                   border: Border.all(color: Colors.grey.shade300, width: 2),
              //                 ),
              //                 clipBehavior: Clip.antiAlias,
              //                 child: CachedNetworkImage(
              //                   imageUrl: SubCategoryImage,
              //                   fit: BoxFit.contain, // 🟢 Ensures full image is visible, no cropping
              //                   alignment: Alignment.center,
              //                   placeholder: (context, url) => const Center(
              //                     child: CircularProgressIndicator(strokeWidth: 2),
              //                   ),
              //                   errorWidget: (context, url, error) =>
              //                   const Icon(Icons.error, color: Colors.redAccent),
              //                 ),
              //               ),
              //               const SizedBox(width: 15),
              //
              //               // 🟢 Text Section
              //               Expanded(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     // Sub-category Name
              //                     Text(
              //                       SubCategory,
              //                       style: const TextStyle(
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w600,
              //                         color: Colors.black87,
              //                       ),
              //                     ),
              //                     const SizedBox(height: 6),
              //
              //                     // Remarks Text
              //                     Text(
              //                       "$remarks",
              //                       style: const TextStyle(
              //                         fontSize: 14,
              //                         color: Colors.grey,
              //                         height: 1.4,
              //                       ),
              //                     ),
              //                     const SizedBox(height: 8),
              //
              //                     // 🟢 Question Text
              //                     Text(
              //                       "$question",
              //                       style: const TextStyle(
              //                         fontSize: 14,
              //                         color: Colors.black87,
              //                         fontWeight: FontWeight.w500,
              //                         height: 1.4,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //
              //           const SizedBox(height: 20),
              //           const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
              //           const SizedBox(height: 20),
              //
              //           // 🟢 Vertical Stepper
              //           Column(
              //             children: [
              //               _buildVerticalStep(
              //                 stepTitle: "not_achieved".tr,
              //                 month: notAchievedMonth,
              //                 submittedDate: notAchievedSubmittedDate,
              //                 color: Colors.redAccent,
              //                 iconPath: "assets/notred.png",
              //                 isActive: notAchievedIsActive,
              //               ),
              //
              //               _buildConnectorLine(
              //                 isFilled: partiallyAchievedISFilled,
              //                 startColor: Colors.redAccent,
              //                 endColor: Colors.orangeAccent,
              //               ),
              //
              //               _buildVerticalStep(
              //                 stepTitle: "partially_achieved".tr,
              //                 month: partiallyAchievedMonth,
              //                 submittedDate: partiallyAchievedSubmittedDate,
              //                 color: Colors.orangeAccent,
              //                 iconPath: "assets/notachivee.png",
              //                 isActive: partiallyAchievedIsActive,
              //               ),
              //
              //               _buildConnectorLine(
              //                 isFilled: achievedAchievedISFilled,
              //                 startColor: Colors.orangeAccent,
              //                 endColor: Colors.green,
              //               ),
              //
              //               _buildVerticalStep(
              //                 stepTitle: "achieved".tr,
              //                 month: achievedAchievedMonth,
              //                 submittedDate: achievedAchievedSubmittedDate,
              //                 color: Colors.green,
              //                 iconPath: "assets/achivegreen.png",
              //                 isActive: achievedIsActive,
              //                 onFullyAchieved: () {
              //                   // _showCongratsDialog(context);
              //                 },
              //               ),
              //             ],
              //           ),
              //
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
// Body mein jahan abhi single card hai, uski jagah yeh lagao:

            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questionFeedbackMap.length,
                itemBuilder: (context, index) {
                  final entry  = questionFeedbackMap.entries.elementAt(index);
                  final data   = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      shadowColor: Colors.grey.withOpacity(0.3),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SubCategory image + name + remarks (same as before)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80, height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300, width: 2),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl: SubCategoryImage,
                                    fit: BoxFit.contain,
                                    placeholder: (ctx, url) =>
                                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    errorWidget: (ctx, url, e) =>
                                    const Icon(Icons.error, color: Colors.redAccent),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(SubCategory,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),
                                      Text(remarks,
                                          style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4)),
                                      const SizedBox(height: 8),
                                      // ✅ Har card ka apna alag question
                                      Text(data['questionText'],
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                            const SizedBox(height: 20),

                            // ✅ Har card ka apna alag stepper
                            Column(
                              children: [
                                _buildVerticalStep(
                                  stepTitle: "not_achieved".tr,
                                  month: data['notAchievedMonth'],
                                  submittedDate: data['notAchievedDate'],
                                  color: Colors.redAccent,
                                  iconPath: "assets/notred.png",
                                  isActive: data['notAchievedIsActive'],
                                ),
                                _buildConnectorLine(
                                  isFilled: data['partiallyIsFilled'],
                                  startColor: Colors.redAccent,
                                  endColor: Colors.orangeAccent,
                                ),
                                _buildVerticalStep(
                                  stepTitle: "partially_achieved".tr,
                                  month: data['partiallyMonth'],
                                  submittedDate: data['partiallyDate'],
                                  color: Colors.orangeAccent,
                                  iconPath: "assets/notachivee.png",
                                  isActive: data['partiallyIsActive'],
                                ),
                                _buildConnectorLine(
                                  isFilled: data['achievedIsFilled'],
                                  startColor: Colors.orangeAccent,
                                  endColor: Colors.green,
                                ),
                                _buildVerticalStep(
                                  stepTitle: "achieved".tr,
                                  month: data['achievedMonth'],
                                  submittedDate: data['achievedDate'],
                                  color: Colors.green,
                                  iconPath: "assets/achivegreen.png",
                                  isActive: data['achievedIsActive'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),              const SizedBox(height: 100),
            ],
          ),
        ),

        // 🟠 Floating Add Button
        floatingActionButton: isVisible
            ? FloatingActionButton.extended(
          backgroundColor: BrandColors.apporangeColor,
          onPressed: () async {
            await SharedPreferHelper.setPrefString("aspirationId", aspirationId);
            await SharedPreferHelper.setPrefString(
                "selectedMonth", selectedMonth.toString());
            await asp_controller.getData();
            // await asp_controller.getLocation(context);
            await asp_controller.getAllCategory();
            await asp_controller.loadSubcategories();
            await asp_controller.getSubCategoryQuestion();

            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedBackNew()),
            );

            // if (result == "refresh") {
            //   getData();
            // }
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label:  Text(
            "add_feedback".tr,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        )
            : null, // 👈 hide FAB when isVisible == false

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildVerticalStep({
    required String stepTitle,
    required String month,
    required String submittedDate,
    required Color color,
    required String iconPath,
    required bool isActive,
    VoidCallback? onFullyAchieved,
  }) {
    final bool isAchieved = iconPath.contains("achivegreen.png");

    return GestureDetector(
      onTap: () {
        if (isAchieved && onFullyAchieved != null) {
          onFullyAchieved();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔵 Left: Circular Step Icon
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive
                      ? LinearGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : LinearGradient(
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                    ],
                  ),
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: color.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : [],
                ),
                child: Center(
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    width: iconPath.contains("notred.png") ? 40 : 55, // 🟢 Smaller if “notred.png”
                    height: iconPath.contains("notred.png") ? 40 : 55,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // 🔵 Right: Step Details + Achieved Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isActive ? color : Colors.grey.shade600,
                  ),
                  child: Text(stepTitle),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(
                      "${"month".tr}: $month",
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.black87,
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 2),

                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${"date".tr}: $submittedDate",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),

                // 🟢 Show greeting when achieved
                if (isAchieved && achievedIsActive) ...[
                  const SizedBox(height: 14),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.green.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.celebration,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "achieved_greeting".tr,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 18),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🟢 Connector line (danda)
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


  // 🟢 Function to get Category Data from ID
  String? getQuestionById(
      String questionId,
      String languageId,
      RxList<QuestionModel> questions,
      ) {
    try {
      final question = questions.firstWhere(
            (q) =>
        q.question_id_code == questionId &&
            q.lang_id == languageId,
      );
      return question.question_name;
    } catch (e) {
      return null; // अगर नहीं मिला
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
