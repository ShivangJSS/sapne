import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:trikal_up/Common/Api.dart';
import 'package:trikal_up/Dashboard/Manage_Family/add_family.dart';
import 'package:trikal_up/Modals/clf_master.dart';
import 'package:trikal_up/Modals/village_list.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/LocationService.dart';
import '../Common/SharedPreferHelper.dart';
import '../Modals/panchayet_list.dart';
import '../Modals/participant.dart';

class familyController extends GetxController {
  final Dio dio = Dio();
  RxString title="".obs;
  String id="";
  String type="", latitude = "", longitude = "";
  var addfmlyctrl = ''.obs;
  var addfmlytype = ''.obs;

  RxList<Participant> upd_list_data = <Participant>[].obs;
  RxList<Participant> list_data = <Participant>[].obs;
  RxList<Participant> participantListDashboard = <Participant>[].obs;
  RxList<Participant> filteredList = <Participant>[].obs;
  var selpanch = <PanchayatList>[].obs;
  var selvill = <VillageList>[].obs;
  var allVillages = <VillageList>[].obs;
  var selclf = <ClfMaster>[].obs;
  var panchayatNameLgd = ''.obs;
  var villageNameLgd = ''.obs;

  final formKey = GlobalKey<FormState>();
  // Controllers
  String state_lgd_code = "0";
  String district_lgd_code = "0";
  String block_lgd_code = "0";
  var profileImage = Rxn<File>();
  Rxn<String> networkUrl = Rxn<String>();
@override
  void onInit() {
    super.onInit();
    getData();
}

Future<void> getData() async {
  id = await SharedPreferHelper.getPrefString('id', '');
  type = await SharedPreferHelper.getPrefString('type', '');
  state_lgd_code = await SharedPreferHelper.getPrefString('state_lgd_code', '');
  district_lgd_code = await SharedPreferHelper.getPrefString('district_lgd_code', '');
  block_lgd_code = await SharedPreferHelper.getPrefString('block_lgd_code', '');
  coach_id = await SharedPreferHelper.getPrefString('userId', '');
}

Future<void> getFilterData() async{
  String? aspTitle = await SharedPreferHelper.getPrefString("asp_title");
  String? feedTitle = await SharedPreferHelper.getPrefString("feed_title");
  if (aspTitle != null && aspTitle.isNotEmpty) {
    title.value = aspTitle;
  } else if (feedTitle != null && feedTitle.isNotEmpty) {
    title.value = feedTitle;
  } else {
    title.value = "Pending";
  }
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


  final TextEditingController nameController     = TextEditingController();
  final TextEditingController fahernameController     = TextEditingController();
  final TextEditingController pidController      = TextEditingController();
  final TextEditingController ageController      = TextEditingController();
  final TextEditingController tolaController     = TextEditingController();
  final TextEditingController dateController     = TextEditingController();
  final TextEditingController contectController  = TextEditingController();
  final TextEditingController fmlyheadController = TextEditingController();
  final TextEditingController coachnameController= TextEditingController();
  final TextEditingController otherMarriageController= TextEditingController();
  final TextEditingController contectcoachController= TextEditingController();
  final TextEditingController total_family_mem= TextEditingController();
  final TextEditingController tadult_mem= TextEditingController();
  final TextEditingController tchildren_mem= TextEditingController();

   String coach_id = "";
  // Dropdown values
  RxString selectedPanchayet = "".obs;
  RxString selectedVillage = "".obs;
  RxString selectedclf = "".obs;
  RxString selectedquali = "".obs;
  RxString marriage = "".obs;
  RxString selected_hh = "".obs;
  var hhError = ''.obs;

  var mem_of_shg = "".obs;
  var attendshg = "".obs;
  var wantshg = "".obs;
  var lightrate = "".obs;
  var otherMarriageText = ''.obs;
  var diffabledFamily = ''.obs;
  var noReasonText = ''.obs;
  TextEditingController reasonController = TextEditingController();

  var abled_person_family = "".obs;
  RxString adultsError = ''.obs;
  final TextEditingController abled_person_adult = TextEditingController();
  final TextEditingController abled_person_children = TextEditingController();

  // Error variablesf
  var pidError = RxnString();
  var selectedpunchError = RxnString();
  var selectedvillError = RxnString();
  var nameError = RxnString();
  var fathernameError = RxnString();
  var ageError = RxnString();
  var tolaError = RxnString();
  var clfError = RxnString();
  var dateError = RxnString();
  var marrigeError = RxnString();
  var contectError = RxnString();
  var totalfmlyError = RxnString();
  var educationError = RxnString();
  var headError = RxnString();
  var lightrateError = RxnString("");
  var diffabledfmlyyError = RxnString("");
  var memofshgError = RxnString("");
  var attendShgError = RxnString("");
  var wantShgError = RxnString("");
  var coachnameError = RxnString();
  var coachcontectError = RxnString();
  var imageError = RxnString();

  String generateUniqueId() {
    // final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return "PID$random";
  }
  String generateUId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return "$timestamp/$random";
  }
  // Add family code
  Future<void> insertData(BuildContext context) async {
    bool isValid = false;

    bool network = await InternetConnectionChecker().hasConnection;
    int total = int.tryParse(addfmly.total_family_mem.text.trim()) ?? 0;
    int adults = int.tryParse(addfmly.tadult_mem.text.trim()) ?? 0;
    int children = int.tryParse(addfmly.tchildren_mem.text.trim()) ?? 0;

    bool isTrue=validateForm(isValid);
    if(isTrue){

    if (adults + children != total) {
      Get.snackbar(
        "Invalid",
        "Total family members must be equal to Adults + Children",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return ;
    }

    try {
      SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);

      final data = Participant(
        p_id: id,
        name_participant: nameController.text.toString(),
        participant_id: pidController.text.toString(),
        father_name: fahernameController.text.toString(),
        participant_age: ageController.text.toString(),
        state_lgd_code: state_lgd_code,
        district_lgd_code: district_lgd_code,
        block_lgd_code: block_lgd_code,
        gram_panchayat_lgd_code: selectedPanchayet.value,
        village_lgd_code: selectedVillage.value,
        tola_para: tolaController.text.toString(),
        community_institution: selectedclf.value,
        selection_year: dateController.text.toString(),
        marital_status: marriage.value,
        mobile_no: contectController.text.toString(),
        level_of_education: selectedquali.value,
        total_family_members: total_family_mem.text.toString(),
        number_adults_member: tadult_mem.text.toString(),
        number_children_member: tchildren_mem.text.toString(),
        head_of_family: fmlyheadController.text.toString(),
        signature_literate: lightrate.value,
        any_differently_abled_person_family: abled_person_family.value,
        total_differently_adults_member: abled_person_adult.text.toString(),
        total_differently_children_member: abled_person_children.text.toString(),
        are_you_member_of_shg: mem_of_shg.value,
        do_you_attend_any_shg_meeting: (mem_of_shg.value == 'Yes') ? attendshg.value : "",
        would_you_want_shg_member: (mem_of_shg.value == 'No') ? wantshg.value : "",
        coach_id: coach_id,
        coach_contact_number: contectcoachController.text.toString(),
        hh_visit_day: selected_hh.value,
        status: "0",
        coach_name: coachnameController.text.toString(),
        latitude: latitude,
        longitude: longitude,
        martial_status_other: otherMarriageController.text.toString(),
        any_diffrent_abled_reason: reasonController.text.toString(),

      );
      File? image = profileImage.value;

      if(image!=null) {
        data.participant_photo = image.path;
      }


      FormData formData = FormData.fromMap({
        ...data.toJson(),
      });

      if (image != null) {
        formData.files.add(
          MapEntry(
            'participant_photo',
            await MultipartFile.fromFile(
              image!.path,
              filename: image!.path.split('/').last,
            ),
          ),
        );
      }else{
        data.participant_photo = networkUrl.value.toString();
        formData.fields.add(
          const MapEntry(
            'participant_photo',""
          ),
        );
      }

      if(network){
        if(type!="edit") {
          var response = await dio.post(
              Api.BaseUrl + Api.add_participant, data: formData);
          if (response.statusCode == 200) {
            var resData = response.data;
            if (resData["status"] == "success") {
              data.p_id = resData["insert_id"].toString();
              data.status = "1";

              await DatabaseHelper.instance.insertData(
                  data.toMap(), 'participant');

              await getAllFamily(selectedVillage.value);
              await getOneFamily(id);
              clearValue();
              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${resData["message"]}"),
                backgroundColor: Colors.green,),);
              Get.back();

            } else {
              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${resData["message"]}"),
                backgroundColor: Colors.redAccent,),);
            }


          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("failed! server down."), backgroundColor: Colors.redAccent,),);
          }
        }else{

          var response = await dio.post(Api.BaseUrl + Api.update_participant + id, data: formData);
          if (response.statusCode == 200) {
            var resData = response.data;
            if (resData["status"] == "success") {
              data.status = "1";

              await DatabaseHelper.instance.updateData(data.toMap(), id);

              await getAllFamily(selectedVillage.value);
              await getOneFamily(id);
              clearValue();
              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${resData["message"]}"),
                backgroundColor: Colors.green,),);
              Get.back();

            } else {
              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${resData["message"]}"),
                backgroundColor: Colors.redAccent,),);
            }

          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("failed! server down."), backgroundColor: Colors.redAccent,),);
          }

        }


      }else{
        if(type!="edit") {
          String uId=generateUId();
          data.p_id = uId;
          int res = await DatabaseHelper.instance.insertData(
              data.toMap(), 'participant');
          if (res > 0) {
            await getAllFamily(selectedVillage.value);
            await getOneFamily(id);
            clearValue();
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Participant Added Successfully"),
              backgroundColor: Colors.green,),);
            Get.back();
          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Participant Added Failed"),
              backgroundColor: Colors.redAccent,),);
          }
        }else{
          if(id.contains("/")) {
            data.status = "0";
          }else{
            data.status = "2";
          }
          await DatabaseHelper.instance.updateData(data.toMap(), id);
          await getAllFamily(selectedVillage.value);
          await getOneFamily(id);
          clearValue();
          SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Participant Updated Successfully"),
            backgroundColor: Colors.green,),);
          Get.back();
        }
      }


    }
    catch(e){
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent,),);
      print(e);
    }
    }


  }
// Required imports (अगर पहले से नहीं हैं तो जोड़ें)
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

  bool validateForm(bool isValid ) {
     isValid = true;
     int total = int.tryParse(total_family_mem.text) ?? 0;
     int adults = int.tryParse(abled_person_adult.text) ?? 0;
     int childrend = int.tryParse(abled_person_children.text) ?? 0;

    // Participant fields
    if (pidController.text.trim().isEmpty) {
      pidError.value = "Participant Id is required";
      isValid = false;
    } else {
      pidError.value = "";
    }

    if (nameController.text.trim().isEmpty) {
      nameError.value = "Participant name is required";
      isValid = false;
    } else {
      nameError.value = "";
    }

    if (fahernameController.text.trim().isEmpty) {
      fathernameError.value = "Participant father name is required";
      isValid = false;
    } else {
      fathernameError.value = "";
    }

    if (ageController.text.trim().isEmpty) {
      ageError.value = "Participant age is required";
      isValid = false;
    } else {
      ageError.value = "";
    }

    // Location / selection fields
    if (selectedPanchayet.value.isEmpty) {
      selectedpunchError.value = "Panchayat name is Required";
      isValid = false;
    } else {
      selectedpunchError.value = "";
    }

    if (selectedVillage.value.isEmpty) {
      selectedvillError.value = "Village name is Required";
      isValid = false;
    } else {
      selectedvillError.value = "";
    }

    if (tolaController.text.trim().isEmpty) {
      tolaError.value = "Participant tola/para is required";
      isValid = false;
    } else {
      tolaError.value = "";
    }

    if (selectedclf.value == null) {
      clfError.value = "Community Institution is required";
      isValid = false;
    } else {
      clfError.value = "";
    }

    if (dateController.text.trim().isEmpty) {
      dateError.value = "Year of selection is required";
      isValid = false;
    } else {
      dateError.value = "";
    }

    // Marital status + "other" case
    if (marriage.value == null || marriage.value!.trim().isEmpty) {
      marrigeError.value = "Marital status is required";
      isValid = false;
    } else {
      marrigeError.value = "";
      if (marriage.value == "p_other".tr) {
        if (otherMarriageController.text.trim().isEmpty) {
          SmartDialog.showToast("Please specify other marital status");
          isValid = false;
        }
      }
    }

    // Contact number: only validate length if not empty
    if (contectController.text.trim().isNotEmpty) {
      if (contectController.text.trim().length != 10) {
        contectError.value = "Please enter a valid 10-digit mobile number";
        isValid = false;
      } else {
        contectError.value = "";
      }
    } else {
      // if you want contact to be required, remove this else and use the length check above as required
      contectError.value = "";
    }

    // Family members / education / head / literate
    if (total_family_mem.text.trim().isEmpty) {
      totalfmlyError.value = "Total family member is required";
      isValid = false;
    } else {
      totalfmlyError.value = "";
    }

     if (adults + childrend > total) {
       SmartDialog.showToast("Differently abled count cannot exceed total family members.",
       );
       isValid = false;
     } else {
       adultsError.value = "";
       isValid = true;
     }
    if (selectedquali.value == null || selectedquali.value!.trim().isEmpty) {
      educationError.value = "Level of education is required";
      isValid = false;
    } else {
      educationError.value = "";
    }

    if (fmlyheadController.text.trim().isEmpty) {
      headError.value = "Name of the head is required";
      isValid = false;
    } else {
      headError.value = "";
    }

    if (lightrate.value == null || lightrate.value!.trim().isEmpty) {
      lightrateError.value = "Literate is required";
      isValid = false;
    } else {
      lightrateError.value = "";
    }

    // Abled person family logic (single, non-duplicate check)
    String familyValue = abled_person_family.value ?? "";
    if (familyValue.trim().isEmpty) {
      diffabledfmlyyError.value = "Abled person is required";
      isValid = false;
    } else {
      diffabledfmlyyError.value = "";
      if (familyValue == "Yes") {
        if (abled_person_adult.text.trim().isEmpty ||
            abled_person_children.text.trim().isEmpty) {
          SmartDialog.showToast("Both Adult and Children fields are required",
          );
          isValid = false;
        }
      }
    }

    // SHG related
    if (mem_of_shg.value == null || mem_of_shg.value!.trim().isEmpty) {
      memofshgError.value = "Member of SHG is required";
      isValid = false;
    } else {
      memofshgError.value = "";
      if (mem_of_shg.value == "Yes") {
        if (attendshg.value == null || attendshg.value!.trim().isEmpty) {
          attendShgError.value = "This field is required";
          isValid = false;
        } else {
          attendShgError.value = "";
        }
      } else if (mem_of_shg.value == "No") {
        if (wantshg.value == null || wantshg.value!.trim().isEmpty) {
          wantShgError.value = "This field is required";
          isValid = false;
        } else {
          wantShgError.value = "";
        }
      }
    }

    // HH visit day
    if (selected_hh.value == null || selected_hh.value!.trim().isEmpty) {
      hhError.value = "HH visit day is required";
      isValid = false;
    } else {
      hhError.value = "";
    }

    // Coach info
    if (coachnameController.text.trim().isEmpty) {
      coachnameError.value = "Coach name is required";
      isValid = false;
    } else {
      coachnameError.value = "";
    }

    if (contectcoachController.text.trim().isEmpty) {
      coachcontectError.value = "Coach contact number is Required";
      isValid = false;
    } else {
      coachcontectError.value = "";
    }

    // Image requirement (either local image or network URL should exist)
    if (profileImage.value == null &&
        (networkUrl.value == null || networkUrl.value!.isEmpty)) {
      imageError.value = "This field is Required";
      isValid = false;
    } else {
      imageError.value = "";
    }

    // Final: if invalid, return false so caller can abort submit
    return isValid;
  }


  void validateFamilyCount() {
    int total = int.tryParse(total_family_mem.text) ?? 0;
    int adults = int.tryParse(tadult_mem.text) ?? 0;
    int children = int.tryParse(tchildren_mem.text) ?? 0;
    int adultd = int.tryParse(abled_person_adult.text) ?? 0;
    int childrend = int.tryParse(abled_person_children.text) ?? 0;

    if ((adults + children) != total) {
      totalfmlyError.value = "Total family members do not match!";
    }
    // else if((adultd + childrend) > total) {
    //
    //   adultsError.value = "Adults cannot be greater than total members";
    // }
    else {
      totalfmlyError.value = ""; // Clear error
    }

    if (total > 0 && (adultd + childrend) > total) {
      diffabledfmlyyError.value = "Differently abled count cannot exceed total family members!";
    } else {
      diffabledfmlyyError.value = "";
    }
  }

  void clearValue(){
    nameController.text = "";
    fahernameController.text = "";
    pidController.text = "";
    ageController.text = "";
    tolaController.text = "";
    selectedclf.value = "";
    dateController.text = "";
    contectController.text = "";
    selectedquali.value = "";
    total_family_mem.text = "";
    tadult_mem.text = "";
    tchildren_mem.text = "";
    fmlyheadController.text = "";
    coachnameController.text = "";
    contectcoachController.text = "";
    selected_hh.value = "";
    selectedPanchayet.value = "";
    marriage.value = "";
    mem_of_shg.value = "";
    attendshg.value = "";
    wantshg.value = "";
    lightrate.value = "";
    abled_person_family.value = "";
    abled_person_adult.text = "";
    abled_person_children.text = "";
    profileImage.value = null;
    selectedVillage.value = "";
    otherMarriageController.text = "";
    reasonController.text = "";
  }


  void clearValidationErrors() {
    pidError.value = "";
    nameError.value = "";
    fathernameError.value = "";
    ageError.value = "";
    selectedpunchError.value = "";
    selectedvillError.value = "";
    tolaError.value = "";
    clfError.value = "";
    dateError.value = "";
    marrigeError.value = "";
    contectError.value = "";
    totalfmlyError.value = "";
    educationError.value = "";
    headError.value = "";
    lightrateError.value = "";
    diffabledfmlyyError.value = "";
    memofshgError.value = "";
    attendShgError.value = "";
    wantShgError.value = "";
    hhError.value = "";
    coachnameError.value = "";
    coachcontectError.value = "";
    imageError.value = "";
  }

// Edit And Add manage
  Future<void> getopration() async{
    id = await SharedPreferHelper.getPrefString('id', '');
    type = await SharedPreferHelper.getPrefString('type', '');
    state_lgd_code = await SharedPreferHelper.getPrefString('state_lgd_code', '');
    district_lgd_code = await SharedPreferHelper.getPrefString('district_lgd_code', '');
    block_lgd_code = await SharedPreferHelper.getPrefString('block_lgd_code', '');
    coach_id = await SharedPreferHelper.getPrefString('userId', '');
    print("id is $id");
    print("id is $type");

    if(id.isNotEmpty){
      String query = "Select * from Participant where p_id = '$id'";
      final familyList = await DatabaseHelper.instance.SelectData(query,(map) => Participant.fromMap(map),);
      if (familyList.isNotEmpty) {
        final family = familyList.first;
        upd_list_data.clear();
        upd_list_data.add(family);
        if (family.participant_photo != null && family.participant_photo!.isNotEmpty) {
          if (family.participant_photo!.startsWith("/data/") ||
              family.participant_photo!.startsWith("/storage/")) {

            addfmly.profileImage.value = File(family.participant_photo!);
          } else {
            // Api.BaseUrl + Api.imageParticipantPath + addfmly.networkUrl.value;
            addfmly.profileImage.value = null;
          }
        }
        nameController.text = family.name_participant ?? "";
        fahernameController.text = family.father_name ?? "";
        pidController.text = family.participant_id ?? "";
        ageController.text = family.participant_age ?? "";
        addfmly.selectedPanchayet.value = family.gram_panchayat_lgd_code ?? "";
        addfmly.selectedVillage.value = family.village_lgd_code ?? "";
        tolaController.text = family.tola_para ?? "";
        addfmly.selectedclf.value = family.community_institution ?? "";
        dateController.text = family.selection_year ?? "";
        marriage.value = family.marital_status  ?? "";
        contectController.text = family.mobile_no ?? "";
        selectedquali.value = family.level_of_education ?? "";
        total_family_mem.text = family.total_family_members ?? "";
        tadult_mem.text = family.number_adults_member ?? "";
        tchildren_mem.text = family.number_children_member ?? "";
        fmlyheadController.text = family.head_of_family ?? "";
        lightrate.value = family.signature_literate ?? "";
        abled_person_family.value = family.any_differently_abled_person_family ?? "";
        abled_person_adult.text = family.total_differently_adults_member ?? "";
        abled_person_children.text = family.total_differently_children_member ?? "";
        mem_of_shg.value = family.are_you_member_of_shg ?? "";
        attendshg.value = family.do_you_attend_any_shg_meeting ?? "";
        wantshg.value = family.would_you_want_shg_member ?? "";
        coachnameController.text = family.coach_name ?? "";
        contectcoachController.text = family.coach_contact_number ?? "";
        selected_hh.value = family.hh_visit_day ?? "";
        otherMarriageController.text = family.martial_status_other ?? "";
        reasonController.text = family.any_diffrent_abled_reason ?? "";

      }
    }else{
      upd_list_data.clear();
      otherMarriageController.text = "";
      reasonController.text = "";
      nameController.text = "";
      fahernameController.text = "";
      ageController.text = "";
      selectedPanchayet.value = "";
      selectedVillage.value = "";
      tolaController.text = "";
      selectedclf.value = "";
      dateController.text = "";
      marriage.value = "";
      contectController.text = "";
      selectedquali.value = "";
      total_family_mem.text = "";
      tadult_mem.text = "";
      tchildren_mem.text = "";
      fmlyheadController.text = "";
      lightrate.value = "";
      abled_person_family.value = "";
      abled_person_adult.text = "";
      abled_person_children.text = "";
      mem_of_shg.value = "";
      attendshg.value = "";
      wantshg.value = "";
      coachnameController.text = "";
      contectcoachController.text = "";
      selected_hh.value = "";
      addfmly.networkUrl.value = null;
      addfmly.profileImage.value = null;
    }
  }
//   View family Code

  List<Map<String, dynamic>> familyData = [];
  Future<void> getOneFamily(String id) async {
    try {
        // SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
        String qry = "Select * from participant where p_id = '$id'";
        final data = await DatabaseHelper.instance.SelectData(qry,(map) => Participant.fromMap(map),);
        if (data.isNotEmpty) {
          familyData.assignAll(data.map((e) => e.toMap()).toList());
        } else {
          familyData.clear();
        }
    }catch(e){
      print(e);
    }finally{
      // SmartDialog.dismiss();
      update();
    }
  }

  // Family List Code
  List<Map<String, dynamic>> familylist = [];
  Future<void> getAllFamily(String villcode) async {
    try {
        SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
        String qry = "Select * from participant where village_lgd_code = $villcode  AND (participant_active_inactive IS NULL OR participant_active_inactive = '1') ORDER BY local_id DESC";
        List<Participant> families = await DatabaseHelper.instance.SelectData(qry, (map) => Participant.fromMap(map),);
        list_data.assignAll(families);
        filteredList.assignAll(families);
        update();
    }catch(e){
      print(e);
    }finally{
      SmartDialog.dismiss();
      update();
    }
  }
//   Future<void> getAllFamilyNoFeedback(bool fromDashboard) async {
//     try {
//         SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
//         String qry = '''SELECT
//     p.*
// FROM participant p
// JOIN aspiration a
//         ON p.p_id = a.participant_id
// LEFT JOIN feedback f
//         ON a.asp_details_id = f.aspiration_id
// GROUP BY p.p_id
// HAVING COUNT(f.feedback_id) = 0
// ORDER BY p.local_id DESC''';
//
//         List<Participant> families = await DatabaseHelper.instance.SelectData(qry, (map) => Participant.fromMap(map),);
//         list_data.assignAll(families);
//         filteredList.assignAll(families);
//         update();
//     }catch(e){
//       print(e);
//     }finally{
//       SmartDialog.dismiss();
//       update();
//     }
//   }
  Future<void> getAllFamilyOrFeedback(bool fromDashboard , String villageCode,
  ) async {
    try {
      SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);

      // Get participants who have at least 1 aspiration but no feedback
      String qry = '''
            SELECT DISTINCT p.*
      FROM participant p
      JOIN aspiration a 
        ON p.p_id = a.participant_id
         
    ''';
      if (villageCode.isNotEmpty) {
        qry += " WHERE p.village_lgd_code = '$villageCode' ";
      }

      qry += " ORDER BY p.local_id DESC ";
      List<Participant> families = await DatabaseHelper.instance.SelectData(
        qry,
            (map) => Participant.fromMap(map),
      );

      list_data.assignAll(families);
      filteredList.assignAll(families);
      update();
    } catch (e) {
      print("❌ Error in getAllFamilyOrFeedback: $e");
    } finally {
      SmartDialog.dismiss();
      update();
    }
  }


  Future<void> getAllFamilyFeedback(bool fromDashboard, String villageCode,
  ) async {
    try {
        SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
        String qry = '''SELECT DISTINCT p.*
FROM participant p
JOIN aspiration a 
        ON p.p_id = a.participant_id
LEFT JOIN feedback f 
        ON a.asp_details_id = f.aspiration_id

''';
        if (villageCode.isNotEmpty) {
          qry += " WHERE p.village_lgd_code = '$villageCode' ";
        }

        qry += '''
    GROUP BY p.p_id
    HAVING COUNT(f.feedback_id) >= 1
    ORDER BY p.local_id DESC
    ''';


        List<Participant> families = await DatabaseHelper.instance.SelectData(qry, (map) => Participant.fromMap(map),);
        list_data.assignAll(families);
        filteredList.assignAll(families);
        update();
    }catch(e){
      print(e);
    }finally{
      SmartDialog.dismiss();
      update();
    }
  }
  Future<void> getAllFamilyPending(bool fromDashboard, String villageCode,) async {
    try {
        SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
        String qry = '''SELECT p.*
FROM participant p
LEFT JOIN aspiration a 
       ON p.p_id = a.participant_id
LEFT JOIN feedback f
       ON p.p_id = f.participant_id
WHERE a.participant_id IS NULL
  AND f.participant_id IS NULL
''';
        if (villageCode.isNotEmpty) {
          qry += " AND p.village_lgd_code = '$villageCode' ";
        }

        qry += " ORDER BY p.local_id DESC ";
        List<Participant> families = await DatabaseHelper.instance.SelectData(qry, (map) => Participant.fromMap(map),);
        list_data.assignAll(families);
        filteredList.assignAll(families);
        update();
    }catch(e){
      print(e);
    }finally{
      SmartDialog.dismiss();
      update();
    }
  }
  Future<void> getAllParticipant() async {
    try {
      String qry = "Select * from participant";
      List<Participant> families = await DatabaseHelper.instance.SelectData(qry, (map) => Participant.fromMap(map),);
      participantListDashboard.assignAll(families);
      update();
    }catch(e){
      print(e);
    }finally{
      update();
    }
  }

  // family filter
  void filterFamily(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(list_data);
    } else {
      filteredList.assignAll(
          list_data.where((f) =>
              f.name_participant!.toLowerCase().contains(query.toLowerCase())
          ).toList()
      );
    }
  }

  // Panchayat List Code
  List<PanchayatList> punch = [];
  Future<void> getAllPunch() async {
    bool result = await InternetConnectionChecker().hasConnection;
    try {
      SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
      String qry = "Select * from panchayat_list";
      List<PanchayatList> pncht = await DatabaseHelper.instance.SelectData(qry, (map) => PanchayatList.fromMap(map),);
      punch.assignAll(pncht);
      update();
    }catch(e){
      print(e);
    }finally{
      SmartDialog.dismiss();
      update();
    }
  }

  // select panch list for add form
  Future<void> getselectpunch() async {
    String languageId=await SharedPreferHelper.getPrefString("languageId","");
    print('languageId $languageId');
    String qry = "Select * from panchayat_list";

    List<PanchayatList> res = await DatabaseHelper.instance.SelectData(qry, (map) => PanchayatList.fromMap(map),);
    selpanch.assignAll(res);
    update();
  }
  Future<void> getselectvill(String gpCode) async {

    String languageId =
    await SharedPreferHelper.getPrefString("languageId", "");

    // String qry =
    //     "Select * from village_list where lang_id=$languageId AND gp_lgd_code='$gpCode'";
    String qry =
        "Select * from village_list where gp_lgd_code='$gpCode'";

    List<VillageList> res = await DatabaseHelper.instance.SelectData(
      qry,
          (map) => VillageList.fromMap(map),
    );

    selvill.assignAll(res);
    update();
  }
  // select vill list for add form
  // Future<void> getselectvill() async {
  //   String languageId=await SharedPreferHelper.getPrefString("languageId","");
  //   String qry = "Select * from village_list where lang_id=$languageId";
  //   List<VillageList> res = await DatabaseHelper.instance.SelectData(qry, (map)=> VillageList.fromMap(map));
  //   selvill.assignAll(res);
  //   update();
  // }

  // select clf for add form
  Future<void> getselectclf() async {
    String languageId=await SharedPreferHelper.getPrefString("languageId","");
    // String qry = "Select * from clf_master where block_lgd_code=$block_lgd_code and lang_id = $languageId";
    String qry = "Select * from clf_master where block_lgd_code=$block_lgd_code";
    List<ClfMaster> res = await DatabaseHelper.instance.SelectData(qry, (map)=> ClfMaster.fromMap(map));
    selclf.assignAll(res);
    update();
  }

  // Image selection
  // Future<void> pickImage() async {
  //   final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     profileImage.value = File(picked.path);
  //     update();// update observable
  //   }
  // }
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final originalFile = File(picked.path);

      // 🧮 Get original file size
      final originalSize = await originalFile.length();
      print("Original Image Size: ${(originalSize / 1024).toStringAsFixed(2)} KB");

      // Temporary directory for compressed image
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, "compressed_${path.basename(picked.path)}");

      // 🔽 Compress the image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        picked.path,
        targetPath,
          quality: 70,        // Adjust for more compression
          minWidth: 1280,     // Reduce resolution
          minHeight: 720,  // between 0-100
      );

      if (compressedFile != null) {
        final compressedSize = await compressedFile.length();
        print("Compressed Image Size: ${(compressedSize / 1024).toStringAsFixed(2)} KB");

        // 🔍 Check if compression worked
        if (compressedSize < originalSize) {
          print("✅ Compression successful!");
        } else {
          print("⚠️ Compression not effective!");
        }

        profileImage.value = File(compressedFile.path);
        update(); // refresh observable
      }
    }
  }

  // Camara image selection
  // Future<void> pickCamera() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     profileImage.value = File(image.path);
  //     update();
  //   }
  // }
  Future<void> pickCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final originalFile = File(image.path);
      final originalSize = await originalFile.length();
      print("Original Camera Image Size: ${(originalSize / 1024).toStringAsFixed(2)} KB");

      final dir = await getTemporaryDirectory();
      final targetPath = path.join(dir.path, "compressed_camera_${path.basename(image.path)}");

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 70,        // Adjust for more compression
        minWidth: 1280,     // Reduce resolution
        minHeight: 720, // resize height
      );

      if (compressedFile != null) {
        final compressedSize = await compressedFile.length();
        print("Compressed Camera Image Size: ${(compressedSize / 1024).toStringAsFixed(2)} KB");

        if (compressedSize < originalSize) {
          print("✅ Strong compression successful!");
        } else {
          print("⚠️ Compression not effective!");
        }

        profileImage.value = File(compressedFile.path);
        update();
      }
    }
  }




  Future<void> fetchData() async {
    print("call");
    print("call ${familyData[0]['gram_panchayat_lgd_code']}");
    print("call ${familyData}");
    if (familyData.isNotEmpty) {
      String panchName = await getPunchNameById('${familyData[0]['gram_panchayat_lgd_code']}');
      panchayatNameLgd.value = panchName;
      String vlgName = await getVillNameById('${familyData[0]['village_lgd_code']}');
      villageNameLgd.value = vlgName;
      print("name is ${villageNameLgd.value}");
    }
  }
  // Get name by key
  Future<String> getPunchNameById(String id) async{
    String languageId=await SharedPreferHelper.getPrefString("languageId","");
    try {
       // String query = "select gp_name from panchayat_list where gp_lgd_code = $id and lang_id = $languageId";
       String query = "select gp_name from panchayat_list where gp_lgd_code = $id";
      List<PanchayatList> asp = await DatabaseHelper.instance.SelectData(query,(map) => PanchayatList.fromMap(map),);
      // gp_name = asp.map((f) => f.toMap()).toList();
      return asp.isNotEmpty ? (asp.first.gp_name ?? "") : "";
    } catch (e) {
      print("Error running query: $e");
      return "";
    }
  }

  Future<String> getVillNameById(String id) async{
    String languageId=await SharedPreferHelper.getPrefString("languageId","");
    try {
      // String query = "select village_name from village_list where village_lgd_code = $id and lang_id = $languageId";
      String query = "select village_name from village_list where village_lgd_code = $id";
      List<VillageList> asp = await DatabaseHelper.instance.SelectData(query,(map) => VillageList.fromMap(map),);
      // gp_name = asp.map((f) => f.toMap()).toList();
      return asp.isNotEmpty ? (asp.first.village_name ?? "") : "";
    } catch (e) {
      print("Error running query: $e");
      return "";
    }
  }

}