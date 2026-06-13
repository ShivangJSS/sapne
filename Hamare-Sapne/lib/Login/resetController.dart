import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:trikal_up/Common/BrandColors.dart';
import 'package:trikal_up/Dashboard/HomeScreen/HomeScreen.dart';
import 'package:trikal_up/Dashboard/Profile/profile.dart';
import 'package:trikal_up/Login/updateprofile.dart';

import '../Common/Api.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Modals/clf_master.dart';
import '../Modals/updateCoachProfile.dart';

class Resetcontroller extends GetxController {
  String? cId;
  String state_lgd_code = "";
  String district_lgd_code = "";
  String block_lgd_code = "";
  String is_reset = "";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController distController = TextEditingController();
  final TextEditingController contectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController guardianController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController joiningdateController = TextEditingController();
  final TextEditingController banknameController = TextEditingController();
  final TextEditingController name_as_bankController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController accountNoController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  // Dropdown values
  RxString selectedclf = "".obs;
  var selclf = <ClfMaster>[].obs;
  String? selectedGender;
  String? selectedquali;
  String coachImage ="";
  String  name ="";
  // Date Picker
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: BrandColors.apporangeColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      joiningdateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }



  Future<void> pickDateBirth(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: BrandColors.apporangeColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      print("Selected DOB: ${dobController.text}");
    }
  }

  final profileImage = Rxn<File>();
  final passbookImage = Rxn<File>();
  RxString networkProfileImage = ''.obs;
  RxString networkPassbookImage = ''.obs;

  Future<void> pickImage(String type) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (type == "user") {
        profileImage.value = File(picked.path);
      }
      else if (type == "pass") {
        networkPassbookImage.value = '';
                passbookImage.value = File(picked.path);
              }// update observable
    }
  }
  // Camara image selection
  Future<void> pickCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      passbookImage.value = File(image.path);
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  void _loadUserId() async {

    state_lgd_code = await SharedPreferHelper.getPrefString('state_lgd_code', '');
    district_lgd_code = await SharedPreferHelper.getPrefString('district_lgd_code', '');
    block_lgd_code = await SharedPreferHelper.getPrefString('block_lgd_code', '');
    // is_reset = await SharedPreferHelper.getPrefString('is_reset', '');
    print("cId: $cId");

    update();
  }
void clear(){
    print('ggg');
  nameController.clear();
  distController.clear();
  contectController.clear();
  emailController.clear();
  guardianController.clear();
  ageController.clear();
  joiningdateController.clear();
  banknameController.clear();
  name_as_bankController.clear();
  branchController.clear();
  ifscController.clear();
  accountNoController.clear();
  // profileImage.value = null;
  // selectedclf.value="";
  selectedGender=null;
  selectedquali=null;
}
  final TextEditingController passController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController cpassController = TextEditingController();

  Future<void> changePassword(BuildContext context) async {
    SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
    try {
      cId = await SharedPreferHelper.getPrefString("userId");
      var response = await Dio().post(
        "${Api.BaseUrl}${Api.resetpass_url}",
        options: Options(headers: {"Content-Type": "application/json"}),

        data: {
            "c_id" : cId,
            "current_password" : passController.text.trim(),
            "new_password" : newController.text.trim(),
            "confirm_password" : cpassController.text.trim()
        },


      );
      print('data of reset $cId');
      Map<String, dynamic> resData = response.data;
      if (response.statusCode == 200) {
        print('data iss $resData');
        await SmartDialog.dismiss();
        if (resData['status'].toString() == "true") {
          await SharedPreferHelper.setPrefString("isReset", "Yes");

          if (resData['is_reset'].toString() == '1') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${resData['message']}"),
              backgroundColor: Colors.green,),);
            await SharedPreferHelper.setPrefString(
              "is_resetUpdate",
              resData['is_reset'].toString(),
            );            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Updateprofile(),),);
          }
        }else if (resData['status'].toString() == "false"){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData['message']}"), backgroundColor: Colors.red,),);
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong!'), backgroundColor: Colors.red,),);
        }
      }
      // Clear fields
      // userController.clear();
      passController.clear();
      newController.clear();
      cpassController.clear();

    } catch (e) {
      SmartDialog.dismiss();
        print(e);
    }
  }

  Future<void>updateCoachProfile(BuildContext context)async{

    SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
    try {
      // suppose tum dobController me 22-05-2001 likh rahe ho
      String inputDate = dobController.text.trim(); // example: "22-05-2001"
      String formattedDate = ""; // final variable for API

      try {
        DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(inputDate);
        formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
      } catch (e) {
        print("Invalid date format: $e");
      }

      final data = UpdateCoachProfile(
        c_id: cId,
        coach_name: nameController.text.trim().toString(),
        name_of_husband_father: guardianController.text.trim().toString(),
        gender: selectedGender.toString(),
        coach_dob: dobController.text.trim().toString(),
        joining_date: joiningdateController.text.trim().toString(),
        mobile_no: contectController.text.trim().toString(),
        clf_id: selectedclf.value,
        name_of_bank: banknameController.text.trim().toString(),
        name_on_bank_account: name_as_bankController.text.trim().toString(),
        branch: branchController.text.trim().toString(),
        ifsc_code: ifscController.text.trim().toString(),
      );
      File? image = profileImage.value;
      File? image2 = passbookImage.value;
      if(image!=null) {
        data.coach_image = image.path;
      }
      if(image2!=null) {
        data.passbook_image = image2.path;
      }

      FormData formData = FormData.fromMap({
        ...data.toJson(),
      });

      if (image != null) {
        formData.files.add(
          MapEntry(
            'coach_image',
            await MultipartFile.fromFile(
              image!.path,
              filename: image!.path.split('/').last,
            ),
          ),
        );
      }

      if (image2 != null) {
        formData.files.add(
          MapEntry(
            'passbook_image',
            await MultipartFile.fromFile(
              image2!.path,
              filename: image2!.path.split('/').last,
            ),
          ),
        );
      }

      print('DOB: ${data.coach_dob}');
      cId = await SharedPreferHelper.getPrefString("userId");
      final Dio dio = Dio();
      final uploadUrl = Api.BaseUrl + Api.UpdateCoachProfile + cId!;
      print('upload $uploadUrl');
        var response = await dio.post(uploadUrl, data: formData);
        if (response.statusCode == 200) {
          var resData = response.data;
          print('data iss $resData');

          if (resData["status"] == "success") {
            await SharedPreferHelper.setPrefString("isUpdate","Yes");
            is_reset = await SharedPreferHelper.getPrefString("is_resetUpdate","");
            print("is_reset: $is_reset");

            if(is_reset == '1') {
              String? imagePath;
              String? imagePath1;
              if (profileImage.value != null) {
                imagePath = profileImage.value!.path; // directly access .value
                print("Selected image path: $imagePath");
              }
              if (passbookImage.value != null) {
                imagePath1 = passbookImage.value!.path; // directly access .value
                print("Selected image path: $imagePath1");
              }
              SmartDialog.dismiss();
              final data1 = UpdateCoachProfile(
                c_id: cId,
              coach_name: nameController.text.trim().toString(),
              name_of_husband_father: guardianController.text.trim().toString(),
              gender: selectedGender.toString(),
              coach_dob: dobController.text.trim().toString(),
              joining_date: joiningdateController.text.trim().toString(),
              mobile_no: contectController.text.trim().toString(),
              clf_id: selectedclf.value,
              name_of_bank: banknameController.text.trim().toString(),
              name_on_bank_account: name_as_bankController.text.trim().toString(),
              branch: branchController.text.trim().toString(),
              ifsc_code: ifscController.text.trim().toString(),
                      coach_image: jsonEncode(imagePath),
                      passbook_image: jsonEncode(imagePath1),
              );
              final existing = await DatabaseHelper.instance.getDataByCoachId(data1.c_id!);
              SharedPreferHelper.setPrefString(
                "full_name",
                data1.coach_name != null ? data1.coach_name! : "");
              if(imagePath!= null) {
                SharedPreferHelper.setPrefString(
                    "coach_image",
                    data1.coach_image != null ? data1.coach_image! : "");
              }
              if(imagePath1!= null) {
                SharedPreferHelper.setPrefString(
                    "passbook_image",
                    data1.passbook_image != null ? data1.passbook_image! : "");
              }
              if (existing.isNotEmpty) {
                await DatabaseHelper.instance.updateProfile(data1.toMap(), data1.c_id!);

              } else {
                await DatabaseHelper.instance.insertData(data1.toMap(), 'coach_profile');

              }

              // await DatabaseHelper.instance.updateData(
              //     data.toMap(),  cId!);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData['message']}"), backgroundColor: Colors.green,),);
              SmartDialog.dismiss();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),),);
            }
            else if(is_reset == '2') {
              // await DatabaseHelper.instance.insertData(
              //     data.toMap(), 'coach_profile');
              String? imagePath;
              String? imagePath1;
              if (profileImage.value != null) {
                imagePath = profileImage.value!.path; // directly access .value
                print("Selected image path: $imagePath");
              }
              if (passbookImage.value != null) {
                imagePath1 = passbookImage.value!.path; // directly access .value
                print("Selected image path: $imagePath1");
              }
              final data1 = UpdateCoachProfile(
                c_id: cId,
                coach_name: nameController.text.trim().toString(),
                name_of_husband_father: guardianController.text.trim().toString(),
                gender: selectedGender.toString(),
                coach_dob: dobController.text.trim().toString(),
                joining_date: joiningdateController.text.trim().toString(),
                mobile_no: contectController.text.trim().toString(),
                clf_id: selectedclf.value,
                name_of_bank: banknameController.text.trim().toString(),
                name_on_bank_account: name_as_bankController.text.trim().toString(),
                branch: branchController.text.trim().toString(),
                ifsc_code: ifscController.text.trim().toString(),
                coach_image: jsonEncode(imagePath),
                passbook_image: jsonEncode(imagePath1),
              );

              print('DOB: ${data1.coach_dob}');

              SharedPreferHelper.setPrefString(
                  "full_name",
                  data1.coach_name != null ? data1.coach_name! : "");
              if(imagePath1!= null) {
                SharedPreferHelper.setPrefString(
                    "passbook_image",
                    data1.passbook_image != null ? data1.passbook_image! : "");
                print('image passbook_image${ data1.passbook_image}');
              }
              if(imagePath!= null) {
                SharedPreferHelper.setPrefString(
                    "coach_image",
                    data1.coach_image != null ? data1.coach_image! : "");
                print('image coach${ data1.coach_image}');
              }



              final existing = await DatabaseHelper.instance.getDataByCoachId(data1.c_id!);

              if (existing.isNotEmpty) {
                await DatabaseHelper.instance.updateProfile(data1.toMap(), data1.c_id!);

              } else {
                await DatabaseHelper.instance.insertData(data1.toMap(), 'coach_profile');

              }

              SmartDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${resData["message"]}"),
                backgroundColor: Colors.green,),);
              // await SharedPreferHelper.setPrefString(
              //     data.coach_image ?? '', "coach_image");
              // print('name Is ${data.coach_name}');
              // await SharedPreferHelper.setPrefString(
              //     data.coach_name ?? '', "full_name");
              Navigator.pop(context, 'updated');

            }
            else{
              SmartDialog.dismiss();
            }
          } else {
            SmartDialog.dismiss();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData["message"]}"),backgroundColor: Colors.redAccent,),);
          }
        }
        else {
          SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("failed! server down."), backgroundColor: Colors.redAccent,),);
        }
      }
    catch(e){
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error"), backgroundColor: Colors.redAccent,),);
    }
  }

  // select clf for add form
  Future<void> getselectclf() async {
    String languageId=await SharedPreferHelper.getPrefString("languageId","");
    print("languageId $languageId");
    block_lgd_code = await SharedPreferHelper.getPrefString('block_lgd_code', '');
    // String qry = "Select * from clf_master where block_lgd_code=$block_lgd_code and lang_id = $languageId";
    String qry = "Select * from clf_master where block_lgd_code=$block_lgd_code";
    List<ClfMaster> res = await DatabaseHelper.instance.SelectData(qry, (map)=> ClfMaster.fromMap(map));
    selclf.assignAll(res);
    update();
  }
}