import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:trikal_up/Common/Api.dart';
import 'package:trikal_up/Common/SharedPreferHelper.dart';
import 'package:trikal_up/Modals/AspirationModel.dart';
import 'package:trikal_up/Modals/FeedBackModel.dart';
import 'package:trikal_up/Modals/QuestionModel.dart';
import 'package:trikal_up/Modals/challenge_cat_master.dart';
import 'package:trikal_up/Modals/challenge_subcat_master.dart';
import 'package:trikal_up/Modals/participant.dart';
import 'package:trikal_up/Modals/wayfor_cat_master.dart';
import 'package:trikal_up/Modals/wayfor_subcat_master.dart';

import '../Common/BrandColors.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/LocationService.dart';
import '../Common/SimpleTimer.dart';
import '../Dashboard/Manage_Aspirations/aspiration_monotoring.dart';
import '../Modals/add_remark.dart';

class AspirationController extends GetxController{
  RxList<Map<String, dynamic>> feedbackDataList = <Map<String, dynamic>>[].obs;
  final Dio dio = Dio();
  var selectedCategory = "".obs;
  var selectedSubCategory = "".obs;
  final TextEditingController descriptionController = TextEditingController();
  var selectedCategoryId = "".obs;
  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> selectedWayCategories = <String>[].obs;
  RxList<String> selectedWaySubCategories = <String>[].obs;
  RxList<String> selectedSubCategories = <String>[].obs;
  RxList<String> selectedChlnCategories = <String>[].obs;
  RxBool isSubCategoryExpanded = false.obs;

  RxBool isCategoryExpanded = false.obs;
  RxList<String> selectedChlnSubCategories = <String>[].obs;
  var selectedSubCategoryId = "".obs;
  final myTimer = SimpleTimer();

  var selectedQuestion = "".obs;
  var selectedQuestionId = "".obs;
  var selectedQuestionName = "".obs;
  var subcategories = <Map<String, dynamic>>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  String coachId="",participantId="",genrated_participantId="",profileImage="",latitude="",aspirationId="",type="",longitude="",deviceName="",osVersion="",appVersion="",name="",fatherName="";
  String languageId="1";
  var subCategoriesQuestion = <QuestionModel>[].obs;
  HashMap<String,String>questionName=HashMap();
  List<Map<String, dynamic>> asplist = [];
  List<Map<String, dynamic>> feedBackList = [];
  List<Map<String, dynamic>> asplistfeedBack = [];
  String cat_image = "https://stage-trickleup.indevconsultancy.in/public/assets/asp_category_images/";
  String sub_cat_image = "https://stage-trickleup.indevconsultancy.in/public/assets/asp_sub_category_images/";

  // remark variable
  final TextEditingController C_OtherReason = TextEditingController();
  final TextEditingController W_OtherReason = TextEditingController();
// Controller mein banao
  TextEditingController C_OtherReason_Cat7 = TextEditingController();   // Category 7 (Other)
  TextEditingController C_OtherReason_Sub6 = TextEditingController();   // Cat 1 + Sub 6
  TextEditingController C_OtherReason_Sub11 = TextEditingController();  // Cat 2 + Sub 11
  TextEditingController C_OtherReason_Sub19 = TextEditingController();  // Cat 3 + Sub 19
  TextEditingController C_OtherReason_Sub25 = TextEditingController();  // Cat 4 + Sub 25
  TextEditingController C_OtherReason_Sub33 = TextEditingController();  // Cat 5 + Sub 33
  TextEditingController C_OtherReason_Sub38 = TextEditingController();  // Cat 6 + Sub 38
  TextEditingController W_OtherReason_Cat8 = TextEditingController();   // Way Category 8 (Other)
  TextEditingController W_OtherReason_Sub9 = TextEditingController();   // WayCat 1 + Sub 9
  TextEditingController W_OtherReason_Sub17 = TextEditingController();  // WayCat 2 + Sub 17
  TextEditingController W_OtherReason_Sub23 = TextEditingController();  // WayCat 3 + Sub 23
  TextEditingController W_OtherReason_Sub29 = TextEditingController();  // WayCat 4 + Sub 29
  TextEditingController W_OtherReason_Sub35 = TextEditingController();  // WayCat 5 + Sub 35
  TextEditingController W_OtherReason_Sub40 = TextEditingController();  // WayCat 6 + Sub 40
  TextEditingController W_OtherReason_Sub44 = TextEditingController();  // WayCat 7 + Sub 44

  RxString selectedChlnCategory = ''.obs;        // For category
  RxString selectedChlnSubCategory = ''.obs;     // For subcategory
  RxList<ChallengeCatMaster> challengeCategories = <ChallengeCatMaster>[].obs;
  RxList<ChallengeSubcatMaster> allChlnSubCategories = <ChallengeSubcatMaster>[].obs;
  Map<String, TextEditingController> C_OtherReasonMap = {};
  Map<String, String> selectedChlnCategoryMap = {};
  RxString selected_waychln_ctgry = ''.obs;
  RxString selected_way_sbctgry = ''.obs;
  RxList<WayforCatMaster> challengeWayCategories = <WayforCatMaster>[].obs;
  RxList<WayforSubcatMaster> allWaySubCategories = <WayforSubcatMaster>[].obs;
  String month="";
  var expandedFeedbackIds = <String>{}.obs;
  var isRemarkEmpty = true.obs;

  // void toggleCard(String feedbackId) {
  //   if (expandedFeedbackIds.contains(feedbackId)) {
  //     expandedFeedbackIds.remove(feedbackId);
  //   } else {
  //     expandedFeedbackIds.add(feedbackId);
  //   }
  // }
  void clearRemarkFields() {
    selectedChlnCategory.value = "";

    selectedChlnCategories.clear();

    selectedChlnSubCategory.value = "";

    selectedChlnSubCategories.clear();

    allChlnSubCategories.clear();

    C_OtherReason.clear();
    C_OtherReason.clear();

    selected_waychln_ctgry.value = "";
    selected_way_sbctgry.value = "";
    W_OtherReason.clear();
    expandedFeedbackIds.clear(); // agar wahi open hai to sab band

  }

  Future<void> loadWaySubCategories() async {
    allWaySubCategories.clear();
    selectedWaySubCategories.clear();
    if (selectedWayCategories.isEmpty) return;

    String ids = selectedWayCategories.map((e) => "'$e'").join(",");

    String qry = """
    SELECT *
    FROM wayfor_sub_cat_master
    WHERE way_forward_cat_id IN ($ids)
    AND lang_id = $languageId
  """;

    List<WayforSubcatMaster> res =
    await DatabaseHelper.instance.SelectData(
      qry,
          (map) => WayforSubcatMaster.fromMap(map),
    );

    allWaySubCategories.assignAll(res);
  }

  void onChlnCategoryChanged(String code, bool checked) {

    if (checked) {

      if (!selectedChlnCategories.contains(code)) {
        selectedChlnCategories.add(code);
      }

    } else {

      selectedChlnCategories.remove(code);

    }

    print("selectedChlnCategories = $selectedChlnCategories");
    print("selectedChlnCategory = ${selectedChlnCategory.value}");

    loadSubCategories();

    update();
  }
  void toggleCard(String feedbackId) {
    if (expandedFeedbackIds.contains(feedbackId)) {
      expandedFeedbackIds.clear(); // agar wahi open hai to sab band
    } else {
      expandedFeedbackIds
        ..clear()        // pehle sabko band karo
        ..add(feedbackId); // phir sirf current open karo
    }
  }




  bool isExpanded(String feedbackId) {
    print("Checking expansion for feedbackId: $feedbackId");
    return expandedFeedbackIds.contains(feedbackId);

  }


  @override
  void onInit() {
    super.onInit();
    getData();
    myTimer.start();
  }
  Future<void> getData() async {
    name=await SharedPreferHelper.getPrefString("participantName","");
    fatherName=await SharedPreferHelper.getPrefString("participantFatherName","");
    profileImage=await SharedPreferHelper.getPrefString("ProfileImage","");
    aspirationId=await SharedPreferHelper.getPrefString("aspirationId","");
    participantId=await SharedPreferHelper.getPrefString("participantId","");
    type=await SharedPreferHelper.getPrefString("type","");
    getAspirationIdWise(aspirationId, "");
    selectedCategories.clear();
    selectedWayCategories.clear();
    coachId=await SharedPreferHelper.getPrefString("userId","");

    participantId=await SharedPreferHelper.getPrefString("participantId","");
    deviceName=await SharedPreferHelper.getPrefString("device_name","");
    osVersion=await SharedPreferHelper.getPrefString("os_version","");
    appVersion=await SharedPreferHelper.getPrefString("appVersion","");
    month=await SharedPreferHelper.getPrefString("selectedMonth","");

  }

  Future<void> getLocation(BuildContext context) async {
    Position? pos = await LocationService.getCurrentLocation(context);
    if (pos != null) {
      latitude=pos.latitude.toString();
      longitude=pos.longitude.toString();
    }
    // For continuous updates
    LocationService.getLocationStream().listen((position) {
      latitude=position.latitude.toString();
      longitude=position.longitude.toString();
      print("Stream Lat: ${position.latitude}, Lng: ${position.longitude}");
    });
  }
  var searchController = TextEditingController();


  // void matchCategory(String query) {
  //   if (query.isEmpty) {
  //     selectedCategory.value = "Other Aspirations";
  //     selectedCategoryId.value = "";
  //
  //     selectedSubCategory.value = "Other";
  //     selectedSubCategoryId.value = "";
  //
  //     selectedQuestion.value = "Other";
  //     selectedQuestionId.value = "";
  //     selectedQuestionName.value = "Other";
  //     return;
  //   }
  //
  //   final searchText = query.toLowerCase();
  //
  //   bool categoryFound = false;
  //   bool questionFound = false;
  //   bool subCategoryFound = false;
  //
  //   // ✅ 1. Category check
  //   for (var cat in categories) {
  //     final keyword = (cat["key_word"] ?? "").toString().toLowerCase();
  //     if (keywordMatch(searchText, keyword)) {
  //       selectedCategory.value = cat["asp_name"] ?? "";
  //       selectedCategoryId.value = cat["asp_cat_id"].toString(); // ✅ ID add
  //       categoryFound = true;
  //       break;
  //     }
  //   }
  //
  //   // ✅ 2. Question check
  //   for (var q in subCategoriesQuestion) {
  //     final keyword = (q.key_word ?? "").toLowerCase();
  //     if (keywordMatch(searchText, keyword)) {
  //       selectedQuestion.value = q.question_id.toString(); // ✅ Question ID
  //       selectedQuestionId.value = q.question_id.toString();
  //       selectedQuestionName.value = q.question_name ?? ""; // ✅ Question name
  //       questionFound = true;
  //
  //       // ✅ SubCategory from Question
  //       final subCatId = q.sub_category_id.toString();
  //       final subcat = subcategories.firstWhere(
  //             (s) => s["asp_sub_cat_id"].toString() == subCatId,
  //         orElse: () => {},
  //       );
  //
  //       if (subcat.isNotEmpty) {
  //         selectedSubCategory.value = subcat["asp_sub_category_name"] ?? "";
  //         selectedSubCategoryId.value = subcat["asp_sub_cat_id"].toString(); // ✅ ID add
  //         subCategoryFound = true;
  //       }
  //       break;
  //     }
  //   }
  //
  //   // ✅ 3. If no Question found → check SubCategory directly
  //   if (!questionFound) {
  //     for (var subcat in subcategories) {
  //       final keyword = (subcat["key_word"] ?? "").toString().toLowerCase();
  //       if (keywordMatch(searchText, keyword)) {
  //         selectedSubCategory.value = subcat["asp_sub_category_name"] ?? "";
  //         selectedSubCategoryId.value = subcat["asp_sub_cat_id"].toString(); // ✅ ID add
  //         subCategoryFound = true;
  //         break;
  //       }
  //     }
  //   }
  //
  //   // ✅ 4. Fallbacks (agar kuch bhi match na ho)
  //   if (!categoryFound) {
  //     selectedCategory.value = "Other Aspirations";
  //     selectedCategoryId.value = "";
  //   }
  //   if (!subCategoryFound) {
  //     selectedSubCategory.value = "Other";
  //     selectedSubCategoryId.value = "";
  //   }
  //   if (!questionFound) {
  //     selectedQuestion.value = "Other";
  //     selectedQuestionId.value = "";
  //     selectedQuestionName.value = "Other";
  //   }
  // }
// ✅ Helper methods to get "Other" IDs from list itself
  String getOtherCategoryId() {
    final other = categories.firstWhere(
          (c) => (c["asp_name"] ?? "").toString().toLowerCase() == "other aspirations",
      orElse: () => {},
    );
    return other.isNotEmpty ? other["asp_cat_code"].toString() : "";
  }

  String getOtherSubCategoryId() {
    final other = subcategories.firstWhere(
          (s) => (s["asp_sub_category_name"] ?? "").toString().toLowerCase() == "other",
      orElse: () => {},
    );
    return other.isNotEmpty ? other["asp_sub_cat_code"].toString() : "";
  }
  void matchCategory(String query) {
    if (query.isEmpty) {
      // Empty query → fallback to last entries
      if (categories.isNotEmpty) {
        final lastCat = categories.last;
        selectedCategory.value = lastCat["asp_name"] ?? "";
        selectedCategoryId.value = lastCat["asp_cat_code"].toString();
      }

      if (subcategories.isNotEmpty) {
        final lastSubCat = subcategories.last;
        selectedSubCategory.value = lastSubCat["asp_sub_category_name"] ?? "";
        selectedSubCategoryId.value = lastSubCat["asp_sub_cat_code"].toString();
      }

      return;
    }

    final searchText = query.toLowerCase();

    bool categoryFound = false;
    bool subCategoryFound = false;

    // 🔹 1. Category match check
    for (var cat in categories) {
      final keyword = (cat["key_word"] ?? "").toString().toLowerCase();
      if (keywordMatch(searchText, keyword)) {
        selectedCategory.value = cat["asp_name"] ?? "";
        selectedCategoryId.value = cat["asp_cat_code"].toString();
        categoryFound = true;
        break;
      }
    }

    // 🔹 2. SubCategory match check
    for (var subcat in subcategories) {
      final keyword = (subcat["key_word"] ?? "").toString().toLowerCase();
      if (keywordMatch(searchText, keyword)) {
        selectedSubCategory.value = subcat["asp_sub_category_name"] ?? "";
        selectedSubCategoryId.value = subcat["asp_sub_cat_code"].toString();
        subCategoryFound = true;
        break;
      }
    }

    // 🔹 3. Fallback → last value from list if not matched
    if (!categoryFound && categories.isNotEmpty) {
      final lastCat = categories.last;
      selectedCategory.value = lastCat["asp_name"] ?? "";
      selectedCategoryId.value = lastCat["asp_cat_code"].toString();
    }

    if (!subCategoryFound && subcategories.isNotEmpty) {
      final lastSubCat = subcategories.last;
      selectedSubCategory.value = lastSubCat["asp_sub_category_name"] ?? "";
      selectedSubCategoryId.value = lastSubCat["asp_sub_cat_code"].toString();
    }
  }

  // void matchCategory(String query) {
  //   if (query.isEmpty) {
  //     selectedCategory.value = "Other Aspirations";
  //     selectedCategoryId.value = getOtherCategoryId();
  //
  //     selectedSubCategory.value = "Other";
  //     selectedSubCategoryId.value = getOtherSubCategoryId();
  //
  //     return;
  //   }
  //
  //   final searchText = query.toLowerCase();
  //
  //   bool categoryFound = false;
  //   bool subCategoryFound = false;
  //
  //   // 1. Category check
  //   for (var cat in categories) {
  //     final keyword = (cat["key_word"] ?? "").toString().toLowerCase();
  //     if (keywordMatch(searchText, keyword)) {
  //       selectedCategory.value = cat["asp_name"] ?? "";
  //       selectedCategoryId.value = cat["asp_cat_code"].toString();
  //       categoryFound = true;
  //       break;
  //     }
  //   }
  //
  //   // ✅ 2. SubCategory check
  //   for (var subcat in subcategories) {
  //     final keyword = (subcat["key_word"] ?? "").toString().toLowerCase();
  //     if (keywordMatch(searchText, keyword)) {
  //       selectedSubCategory.value = subcat["asp_sub_category_name"] ?? "";
  //       selectedSubCategoryId.value = subcat["asp_sub_cat_code"].toString();
  //       subCategoryFound = true;
  //       break;
  //     }
  //   }
  //
  //   // ✅ 3. Fallbacks → "Other" ko list se pick karo
  //   if (!categoryFound) {
  //     selectedCategory.value = "Other Aspirations";
  //     selectedCategoryId.value = getOtherCategoryId();
  //   }
  //   if (!subCategoryFound) {
  //     selectedSubCategory.value = "Other";
  //     selectedSubCategoryId.value = getOtherSubCategoryId();
  //   }
  // }


  // void matchCategory(String query) {
  //   if (query.isEmpty) {
  //     selectedCategory.value = "Other Aspirations";
  //     selectedCategoryId.value = getOtherCategoryId();
  //
  //     selectedSubCategory.value = "Other";
  //     selectedSubCategoryId.value = getOtherSubCategoryId();
  //
  //     selectedQuestion.value = "Other";
  //     selectedQuestionId.value = "";
  //     selectedQuestionName.value = "Other";
  //     return;
  //   }
  //
  //   final searchText = query.toLowerCase();
  //
  //   bool categoryFound = false;
  //   bool questionFound = false;
  //   bool subCategoryFound = false;
  //
  //   // ✅ 1. Category check
  //   for (var cat in categories) {
  //     final keyword = (cat["key_word"] ?? "").toString().toLowerCase();
  //     if (keywordMatch(searchText, keyword)) {
  //       selectedCategory.value = cat["asp_name"] ?? "";
  //       selectedCategoryId.value = cat["asp_cat_id"].toString();
  //       categoryFound = true;
  //       break;
  //     }
  //   }
  //
  //   // ✅ 2. Question check
  //   for (var q in subCategoriesQuestion) {
  //     final keyword = (q.key_word ?? "").toLowerCase();
  //     if (keywordMatch(searchText, keyword)) {
  //       selectedQuestion.value = q.question_id.toString();
  //       selectedQuestionId.value = q.question_id.toString();
  //       selectedQuestionName.value = q.question_name ?? "";
  //       questionFound = true;
  //
  //       // ✅ SubCategory from Question
  //       final subCatId = q.sub_category_id.toString();
  //       final subcat = subcategories.firstWhere(
  //             (s) => s["asp_sub_cat_id"].toString() == subCatId,
  //         orElse: () => {},
  //       );
  //
  //       if (subcat.isNotEmpty) {
  //         selectedSubCategory.value = subcat["asp_sub_category_name"] ?? "";
  //         selectedSubCategoryId.value = subcat["asp_sub_cat_id"].toString();
  //         subCategoryFound = true;
  //       }
  //       break;
  //     }
  //   }
  //
  //   // ✅ 3. If no Question found → check SubCategory directly
  //   if (!questionFound) {
  //     for (var subcat in subcategories) {
  //       final keyword = (subcat["key_word"] ?? "").toString().toLowerCase();
  //       if (keywordMatch(searchText, keyword)) {
  //         selectedSubCategory.value = subcat["asp_sub_category_name"] ?? "";
  //         selectedSubCategoryId.value = subcat["asp_sub_cat_id"].toString();
  //         subCategoryFound = true;
  //         break;
  //       }
  //     }
  //   }
  //
  //   // ✅ 4. Fallbacks → "Other" ko list se pick karo
  //   if (!categoryFound) {
  //     selectedCategory.value = "Other Aspirations";
  //     selectedCategoryId.value = getOtherCategoryId();
  //   }
  //   if (!subCategoryFound) {
  //     selectedSubCategory.value = "Other";
  //     selectedSubCategoryId.value = getOtherSubCategoryId();
  //   }
  //   if (!questionFound) {
  //     selectedQuestion.value = "Other";
  //     selectedQuestionId.value = "";
  //     selectedQuestionName.value = "Other";
  //   }
  // }

  bool keywordMatch(String searchText, String keywordString) {
    if (keywordString.trim().isEmpty || searchText.trim().isEmpty) return false;

    // Convert to lowercase for case-insensitive matching
    final text = searchText.toLowerCase();

    // Split keywords by comma or space, remove empty items
    final keywords = keywordString
        .toLowerCase()
        .split(RegExp(r'[, ]+'))
        .where((kw) => kw.trim().isNotEmpty)
        .toList();

    if (keywords.isEmpty) return false;

    // ✅ Build one combined regex for all keywords (faster than looping)
    final pattern = r'\b(' + keywords.map(RegExp.escape).join('|') + r')\b';
    final regex = RegExp(pattern);

    // ✅ Check if any keyword matches as a full word
    return regex.hasMatch(text);
  }


  String generateFeedbackId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return "$timestamp/$random";
  }

  Future<void> btnSubmit(BuildContext context) async {
    SmartDialog.showLoading(msg: "Please wait...");

    bool result = await InternetConnectionChecker().hasConnection;
    myTimer.stop();

    final data = {
      "coach_id": coachId.toString().trim(),
      "participant_id": participantId.trim(),
      "question_id": selectedQuestionId.value.toString().trim(),
      "remarks": descriptionController.text.toString().trim(),
      "sub_cat_id": selectedSubCategoryId.value.toString().trim(),
      "asp_cat_id": selectedCategoryId.value.toString().trim(),
      "lang_id": languageId,
      "duration": myTimer.formattedTime.toString().trim(),
      "latitude": latitude,
      "longitude": longitude,
      "mobile_version": osVersion,
      "device_name": deviceName,
      "app_version": appVersion,
      "created_at": DateTime.now().toString(), // ✅ local insert ke liye
      "status": "0", // ✅ 0 = pending, 1 = uploaded
      "asp_details_id": generateFeedbackId(), // ✅ 0 = pending, 1 = uploaded
    };

    if(!result){
      await DatabaseHelper.instance.insertData(data, "aspiration");
      try {
        AspirationController controller = Get.find<AspirationController>();
        await controller.getAllAsp(participantId);
      } catch (cErr) {
        print("Controller error: $cErr");
      }
      SmartDialog.dismiss();
      SmartDialog.showToast(" Data has been saved to local database");
      Get.back();
      return;
    }

    try {

      if (result) {
        try {
          var response = await Dio().post(Api.BaseUrl + Api.addAspiration, data: data);

          if (response.statusCode == 200) {
            var resData = response.data;

            if (resData["status"] == "success") {
              // ✅ API success → local DB insert karo with status=1
              data["status"] = "1";
              data["asp_details_id"] = resData["insert_id"].toString();
              await DatabaseHelper.instance.insertData(data, "aspiration");

              // ✅ Refresh list
              try {
                AspirationController controller = Get.find<AspirationController>();
                await controller.getAllAsp(participantId);
              } catch (cErr) {
                print("Controller error: $cErr");
              }

              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${resData["message"]}"),
                  backgroundColor: Colors.green,
                ),
              );
              Get.back();
            } else {
              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${resData["message"]}"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed! Server down."),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        } catch (e) {
          SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("API Error: $e"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        // ✅ Agar internet nahi hai to local insert karo
        await DatabaseHelper.instance.insertData(data, "aspiration");

        SmartDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Saved locally. Will sync later."),
            backgroundColor: Colors.orange,
          ),
        );
        Get.back();
      }
    } catch (e) {
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected Error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
  Future<void> btnSubmitRemark(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;

    try {
      myTimer.stop();
      // ✅ SmartDialog loader start
      SmartDialog.showLoading(msg: "Please wait...");

      // ✅ Final Data Map (NEW KEYS ONLY)
      final data = {
        "coach_id": 1,
        "participant_id": 10,
        "challenge_cat": 2,
        "challenge_sub_cat": 5,
        "wayforward_cat": 3,
        "wayforward_sub_cat": 7,
        "latitude": "28.6139",
        "longitude": "77.2090",
        "mobile_version": "Android 13",
        "device_name": "Samsung Galaxy S21",
        "app_version": "1.0.5",
        "created_at": DateTime.now().toString(), // ✅ local insert ke liye
        "status": "0", // ✅ 0 = pending, 1 = uploaded
        "asp_details_id": "0", // ✅ 0 = pending, 1 = uploaded
      };

      // ✅ Agar internet hai to API hit karo
      if (result) {
        try {
          var response =
          await Dio().post(Api.BaseUrl + Api.addAspiration, data: data);

          if (response.statusCode == 200) {
            var resData = response.data;

            if (resData["status"] == "success") {
              // ✅ API success → local DB insert karo with status=1
              data["status"] = "1";
              data["asp_details_id"] = resData["insert_id"].toString();
              await DatabaseHelper.instance.insertData(data, "aspiration");

              // ✅ Refresh list
              try {
                AspirationController controller =
                Get.find<AspirationController>();
                await controller.getAllAsp(data["participant_id"].toString());
              } catch (cErr) {
                print("Controller error: $cErr");
              }

              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${resData["message"]}"),
                  backgroundColor: Colors.green,
                ),
              );
              Get.back();
            } else {
              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${resData["message"]}"),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed! Server down."),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        } catch (e) {
          SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("API Error: $e"),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        // ✅ Agar internet nahi hai to local insert karo
        await DatabaseHelper.instance.insertData(data, "aspiration");

        SmartDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Saved locally. Will sync later."),
            backgroundColor: Colors.orange,
          ),
        );
        Get.back();
      }
    } catch (e) {
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected Error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


  Future<void> getAllAsp(String participantId ) async {
    try {
      String query = "SELECT * FROM aspiration WHERE participant_id = '$participantId' ORDER BY local_id DESC";
      List<AspirationModel> asp = await DatabaseHelper.instance.SelectData(query,(map) => AspirationModel.fromMap(map),);
      asplist = asp.map((f) => f.toMap()).toList();
    }catch(e){
      print(e);
    }finally{
      update();
    }
  }

  Future<void> getAllAspWithoutFeedback() async {
    try {
      String query =
          '''SELECT a.*
FROM aspiration a
LEFT JOIN feedback f ON a.asp_details_id = f.aspiration_id
WHERE f.aspiration_id IS NULL''';
      List<AspirationModel> asp = await DatabaseHelper.instance.SelectData(query,(map) => AspirationModel.fromMap(map),);
      asplist = asp.map((f) => f.toMap()).toList();
    }catch(e){
      print(e);
    }finally{
      update();
    }
  }
  Future<void> getAllFeedBack(String aspirationId ) async {
    try {
      String query = "SELECT * FROM feedback WHERE aspiration_id = '$aspirationId' ORDER BY local_id DESC";
      List<FeedBackModel> asp = await DatabaseHelper.instance.SelectData(query,(map) => FeedBackModel.fromMap(map),);
      feedBackList = asp.map((f) => f.toMap()).toList();
    }catch(e){
      print(e);
    }finally{
      update();
    }
  }

  Future<void> getAspirationIdWise(String aspirationId,String type ) async {
    try {
      String query="";
      if(type.isNotEmpty){
        query = "SELECT * FROM aspiration WHERE participant_id = '$aspirationId' ORDER BY local_id DESC";
      }else{
        query = "SELECT * FROM aspiration WHERE asp_details_id = '$aspirationId' ORDER BY local_id DESC";
      }
      List<AspirationModel> asp = await DatabaseHelper.instance.SelectData(query,(map) => AspirationModel.fromMap(map),);
      asplistfeedBack = asp.map((f) => f.toMap()).toList();
    }catch(e){
      print(e);
    }finally{
      update();
    }
  }

// Filter dialog box
  void showFilterDialog(BuildContext context) {
    String? selectedOption1;
    String? selectedOption2;
    String? selectedOption3;
    String? selectedOption4;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Apply Filter",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedOption4,
                      hint: Text("Select Village"),
                      items: [
                        "Chandpur",
                        "Rampur",
                        "Bhawanipur",
                        "Sultanpur",
                        "Nagla Kalan"
                      ]
                          .map(
                              (e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (val) => setState(() => selectedOption4 = val),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();

                    setState(() {
                      selectedOption1 = null;
                      selectedOption2 = null;
                      selectedOption3 = null;
                      selectedOption4 = null;
                    });
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Color(0xFF45757F),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.appColor,
                  ),
                  onPressed: () {
                    print(
                        "Apply clicked with filters: $selectedOption1, $selectedOption2, $selectedOption3, $selectedOption4");
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "Apply",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Future<void> loadSubcategories() async {
    languageId=await SharedPreferHelper.getPrefString("languageId","");

    try {
      String qry = "SELECT * FROM sub_category_list where lang_id=$languageId";
      List<Map<String, dynamic>> subList = await DatabaseHelper.instance
          .SelectData(qry, (map) => map);
      subcategories.assignAll(subList);
    } catch (e) {
      print(e);
    }
  }

  Future<void> clearData() async {
    descriptionController.text="";
   selectedCategory.value="";
    selectedSubCategory.value="";
    selectedQuestion.value="";
   selectedCategoryId.value="";
    selectedSubCategoryId.value="";
    selectedQuestionId.value="";
  }

  Future<void> getAllCategory() async {
    languageId=await SharedPreferHelper.getPrefString("languageId","");

    try {
      String qry = "SELECT * FROM category_list where lang_id=$languageId";
      List<Map<String, dynamic>> subList = await DatabaseHelper.instance
          .SelectData(qry, (map) => map);
      categories.assignAll(subList);
    } catch (e) {
      print(e);
    }

  }

  Future<void> getSubCategoryQuestion() async {
    languageId=await SharedPreferHelper.getPrefString("languageId","");

    try {
      String qry = "SELECT * FROM question_list where lang_id=$languageId";
      List<Map<String, dynamic>> subList = await DatabaseHelper.instance
          .SelectData(qry, (map) => map);

      subCategoriesQuestion.assignAll(
        subList.map((e) => QuestionModel.fromMap(e)).toList(),
      );

    } catch (e) {
      print("Error: $e");
    }
  }



///////////////////////////////  Add remark Code //////////////////////////////////////
  Future<void> getRemarkData() async {
    languageId=await SharedPreferHelper.getPrefString("languageId","");
    print('LanguageId $languageId');
    allChlnSubCategories.clear();
    allWaySubCategories.clear();
    String qry1 = "Select * from challenge_cat_master where lang_id=$languageId";
    List<ChallengeCatMaster> res1 = await DatabaseHelper.instance.SelectData(qry1, (map) => ChallengeCatMaster.fromMap(map),);
    challengeCategories.assignAll(res1);

    String qry3 = "Select * from wayfor_cat_master where lang_id=$languageId";
    List<WayforCatMaster> res3 = await DatabaseHelper.instance.SelectData(qry3, (map) => WayforCatMaster.fromMap(map),);
    challengeWayCategories.assignAll(res3);

    update();
  }
  Future<void> loadSubCategories() async {
    allChlnSubCategories.clear();
    selectedChlnSubCategories.clear();


    if (selectedChlnCategories.isEmpty) {
      update();
      return;
    }

    String ids = selectedChlnCategories
        .map((e) => "'$e'")
        .join(",");

    String query = """
    SELECT *
    FROM challenge_sub_cat_master
    WHERE challenges_cat_id IN ($ids)
    AND lang_id = $languageId
  """;

    print(query);

    List<ChallengeSubcatMaster> result =
    await DatabaseHelper.instance.SelectData(
      query,
          (map) => ChallengeSubcatMaster.fromMap(map),
    );

    print("Subcategories Count = ${result.length}");

    allChlnSubCategories.assignAll(result);

    update();
  }

  void onSubchlnChanged(
      String code,
      bool checked,
      ) {

    if (checked) {

      if (!selectedChlnSubCategories.contains(code)) {

        selectedChlnSubCategories.add(code);

      }

    }

    else {

      selectedChlnSubCategories.remove(code);

    }

    update();

  }


  // Way Forword
  void onWayCatChanged(String? catId) async {
    print("subcategory= $catId");
    print("language= $languageId");
    selected_waychln_ctgry.value = catId ?? '';
    selected_way_sbctgry.value = '';
    W_OtherReason.clear();
    String qry1 = "Select * from wayfor_sub_cat_master where way_forward_cat_id = '$catId' and lang_id=$languageId";
    List<WayforSubcatMaster> res1 = await DatabaseHelper.instance.SelectData(qry1, (map) => WayforSubcatMaster.fromMap(map),);
    allWaySubCategories.assignAll(res1);
    update();
  }
  void onSubWayChanged(String? subId) {
    selected_way_sbctgry.value = subId ?? '';
  }


// submit data
  Future<void> remarkdata(BuildContext context) async{
    SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
    String fId = await SharedPreferHelper.getPrefString("feedback_id", '');
    String QId = await SharedPreferHelper.getPrefString("question_id", '');

    bool result = await InternetConnectionChecker().hasConnection;
    try{
      List<AddRmk> dataList = [];
      final data = AddRmk(
        feedback_id: fId,
        question_id: QId,

        coachId: coachId,
        participantId: participantId,

        // Multi-select categories
        challengeCat: selectedChlnCategories.join(","),

        // If category 7 ("Other") is selected, don't save subcategories
        challengeSubCat: selectedChlnCategories.contains("7")
            ? null
            : selectedChlnSubCategories.join(","),

        other_challenge_text: C_OtherReason.text.trim(),

        wayforwardCat: selected_waychln_ctgry.value,

        wayforwardSubCat: selected_waychln_ctgry.value == "8"
            ? null
            : selected_way_sbctgry.value,

        other_wayforward_sub_cat_text: W_OtherReason.text.trim(),

        latitude: latitude,
        longitude: longitude,

        mobileVersion: osVersion,
        deviceName: deviceName,
        appVersion: appVersion,

        created_at: DateTime.now().toString(),

        status: "1",
      );
     // print(jsonEncode(data.toJson()));
     if(result){
        var response = await dio.post(Api.BaseUrl+Api.AddRemark, data: data.toJson(), );
        if (response.statusCode == 200) {
          final resData = response.data is String ? jsonDecode(response.data) : response.data;
          if (resData["status"] == "success") {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData["message"]} (Live)"), backgroundColor: Colors.green,),);
          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData["message"]}"), backgroundColor: Colors.redAccent,),);
          }
          await DatabaseHelper.instance.insertData(data.toJson(), 'remark');
          SmartDialog.dismiss();
        } else {
          SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("failed! server down."), backgroundColor: Colors.redAccent,),);
        }
      }
     else{
       print("📴 Offline — saving remark locally");
       Map<String, dynamic> offlineRemark = data.toJson();
       offlineRemark["status"] = 0; // mark as offline

       await DatabaseHelper.instance.insertData(offlineRemark, 'remark');
       SmartDialog.showToast(" Data has been saved locally");
     }
      selectedChlnCategory.value = "";
      selectedChlnSubCategory.value = "";

      selectedChlnCategories.clear();
      selectedChlnSubCategories.clear();

      allChlnSubCategories.clear();

      isCategoryExpanded.value = false;
      isSubCategoryExpanded.value = false;
     selected_waychln_ctgry.value = "";
     selected_way_sbctgry.value = "";
     C_OtherReason.text = "";
     W_OtherReason.text = "";
     SmartDialog.dismiss();
     // Get.back();
     bool cameFromFeedback = await SharedPreferHelper.getPrefBool("cameFromFeedback", false);

     if (cameFromFeedback) {
       print("Coming from Feedback screen → closing 3 screens");
       Get.close(3);
     } else {
       print(" Direct entry → closing 1 screen");
       Get.back();
     }
     await SharedPreferHelper.setPrefBool("cameFromFeedback", false);

    } catch (e) {
      SmartDialog.dismiss();
      print(" Error: $e");
    }
  }
}