import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:trikal_up/Login/resetController.dart';
import 'package:trikal_up/Modals/block_master.dart';
import 'package:trikal_up/Modals/district_master.dart';
import 'package:trikal_up/Modals/panchayet_list.dart';
import 'package:trikal_up/Modals/updateCoachProfile.dart';

import '../Common/Api.dart';
import '../Common/BrandColors.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Dashboard/HomeScreen/HomeScreen.dart';
import '../Dashboard/Manage_Family/add_family.dart';

// Resetcontroller rstController = Get.find<Resetcontroller>();

class Updateprofile extends StatefulWidget {
  const Updateprofile({super.key});

  @override
  State<Updateprofile> createState() => _UpdateprofileState();
}

class _UpdateprofileState extends State<Updateprofile> {
  final formKey = GlobalKey<FormState>();
  final Resetcontroller rstController = Get.put(Resetcontroller());
  String fullname = "";
  String coach_id = "";
  @override
  void initState() {
    super.initState();
    // rstController.clear();
    rstController.getselectclf();

    loadusername();
  }

  RxList<UpdateCoachProfile> list_data = <UpdateCoachProfile>[].obs;
  List<PanchayatList> panchayatData =[];
  List<DistrictMaster> districtData =[];
  List<BlockMaster> blockData =[];
  RxString gpName = 'Not Available'.obs;
  RxString districtName = 'Not Available'.obs;
  RxString blockName = 'Not Available'.obs;
// Add this in your State class
  String is_reset = "";
  Future<void> loadusername() async{
    String name = await SharedPreferHelper.getPrefString("full_name");
    is_reset = await SharedPreferHelper.getPrefString('is_resetUpdate', '');
    print('is_reset $is_reset');
    String coachImage = await SharedPreferHelper.getPrefString("coach_image");
   String gpCode = await SharedPreferHelper.getPrefString("gp_lgd_code");
   String DistrictCode = await SharedPreferHelper.getPrefString("district_lgd_code");
   String Block = await SharedPreferHelper.getPrefString("block_lgd_code");
   String langId = await SharedPreferHelper.getPrefString("languageId","");
   print('gpCode $gpCode');
    String queryPanchayat ="Select * from panchayat_list where lang_id = $langId";
    String queryDistrict ="Select * from district_master where lang_id = $langId";
    String queryBlock ="Select * from block_master where lang_id = $langId";
    List<PanchayatList> dataPanchayat = await DatabaseHelper.instance.getPanchayatList(queryPanchayat);
    List<BlockMaster> dataBlock = await DatabaseHelper.instance.getBlockList(queryBlock);
    List<DistrictMaster> dataDistrict = await DatabaseHelper.instance.getDistrict(queryDistrict);

    DownloadListData();
    setState(() {
      fullname = name;
      panchayatData = dataPanchayat;
      blockData = dataBlock;
      districtData = dataDistrict;

      // Set reactive gpName
      final panchayat = panchayatData.firstWhere(
            (element) => element.gp_lgd_code == gpCode,
        orElse: () => PanchayatList(gp_lgd_code: '', gp_name: 'Not Available'),
      );
      gpName.value = panchayat.gp_name ?? 'Not Available';

      final district = districtData.firstWhere(
            (element) => element.district_lgd_code == DistrictCode,
        orElse: () => DistrictMaster(district_lgd_code: '', district_name: 'Not Available'),
      );
      districtName.value = district.district_name ?? 'Not Available';

    final block = blockData.firstWhere(
          (element) => element.block_lgd_code == Block,
      orElse: () => BlockMaster(block_lgd_code: '', block_name: 'Not Available'),
    );
    blockName.value = block.block_name ?? 'Not Available';
    });


}





  Future<void> DownloadListData() async{
    String CID = await SharedPreferHelper.getPrefString("userId");
   print('CID is$CID');
    list_data.assignAll(await DatabaseHelper.instance
        .getList("Select * from coach_profile where c_id =$CID"));


    if(list_data.isNotEmpty){
      if (list_data.isNotEmpty &&
          rstController.selclf.any((item) => item.clf_code.toString() == list_data[0].clf_id.toString())) {
        rstController.selectedclf.value = list_data[0].clf_id.toString();
      } else {
        rstController.selectedclf.value = "";
      }

      print(' selectedGender ${  rstController.selectedGender}');
      rstController.nameController.text= list_data[0].coach_name.toString();
      rstController.guardianController.text= list_data[0].name_of_husband_father.toString();
      rstController.dobController.text= list_data[0].coach_dob.toString();
      rstController.selectedGender= list_data[0].gender.toString();
      rstController.contectController.text= list_data[0].mobile_no.toString();
      rstController.joiningdateController.text= list_data[0].joining_date.toString();
      rstController.banknameController.text= list_data[0].name_of_bank.toString();
      rstController.name_as_bankController.text= list_data[0].name_on_bank_account.toString();
      rstController.branchController.text= list_data[0].branch.toString();
      rstController.ifscController.text= list_data[0].ifsc_code.toString();
      String coachImage = await SharedPreferHelper.getPrefString("coach_image");
      print('coachImage $coachImage');
      String passbookImage = await SharedPreferHelper.getPrefString("passbook_image");
      print('passbookImage $passbookImage');
      if (list_data.isNotEmpty && list_data[0].coach_image != null && list_data[0].coach_image!.isNotEmpty) {

        String localPath = list_data[0].coach_image!.replaceAll('"', ''); // remove quotes
        File file = File(localPath);

        if (file.existsSync()) {
          rstController.profileImage.value = file;
          rstController.networkProfileImage.value = ''; // clear network fallback
        } else {
          // If file does not exist, fallback to network
          rstController.profileImage.value = null;
          rstController.networkProfileImage.value = coachImage;
        }

      } else if (coachImage.isNotEmpty) {
        rstController.networkProfileImage.value = coachImage;
        rstController.profileImage.value = null;
      } else {
        rstController.profileImage.value = null;
        rstController.networkProfileImage.value = '';
      }

      if (list_data.isNotEmpty && list_data[0].passbook_image != null && list_data[0].passbook_image!.isNotEmpty) {

      String localPath1 = list_data[0].passbook_image!.replaceAll('"', ''); // remove quotes
      File file = File(localPath1);

      if (file.existsSync()) {
        rstController.passbookImage.value = file;
        rstController.networkPassbookImage.value = ''; // clear network fallback
      } else {
        print('image is ${rstController.networkPassbookImage.value}');

        // If file does not exist, fallback to network
        String loca1 = list_data[0].passbook_image!;
        print('image is loca1 ${loca1}');
        rstController.passbookImage.value = null;
        rstController.networkPassbookImage.value = passbookImage;
      }

    } else if (passbookImage.isNotEmpty) {
      rstController.networkPassbookImage.value = passbookImage;
      rstController.passbookImage.value = null;
    } else {
      rstController.passbookImage.value = null;
      rstController.networkPassbookImage.value = '';
    }

}
    else{
      rstController.clear();
    }

  }

  final dayOptions = [
    {"key": "Male", "label": "p_male".tr},
    {"key": "Female", "label": "p_female".tr},
    {"key": "Other", "label": "p_other".tr},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BrandColors.appbackgroundColor,
        appBar: AppBar(
          backgroundColor: BrandColors.appColor,
          elevation: 2,
          automaticallyImplyLeading: false, // Default back button hata diya
          leadingWidth: 40,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),

              Expanded( // ⭐ important
                child: Text(
                  "update_profile".tr,
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
        ),
        body: Form(
          key: formKey,
          child: Column(children: [
            //  Static Card (scroll ke bahar)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Obx(() => InkWell(
                        onTap: () => rstController.pickImage("user"),
                        child: Stack(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black54,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: rstController.profileImage.value != null
                                    ? Image.file(
                                  rstController.profileImage.value!,
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 110,
                                )
                                    : rstController.networkProfileImage.value.isNotEmpty
                                    ? CachedNetworkImage(
                                  imageUrl: Api.BaseUrl + Api.imageCoach + rstController.networkProfileImage.value,
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 110,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    "assets/user.png",
                                    fit: BoxFit.cover,
                                    width: 110,
                                    height: 110,
                                  ),
                                )
                                    : Image.asset(
                                  "assets/user.png",
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 110,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black54, width: 2),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$fullname",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "p_district".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Obx(() => Text(
                                          districtName.value,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                      ],
                                    )

                                ),
                              ],
                            ),

                            SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "p_block".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Obx(() => Text(
                                          blockName.value,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                      ],
                                    )

                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        "p_panchayat".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Obx(() => Text(
                                        gpName.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                    ],
                                  )

                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label above dropdown
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4, left: 4),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "add_endorsing_community".tr + " ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              TextSpan(
                                text: "*",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Dropdown field (no fixed height)

            Obx(() {
              // Check if selected value exists in the dropdown items
              final isValueInItems = rstController.selclf.any(
                    (r) => r.clf_code != null && r.clf_code == rstController.selectedclf.value,
              );

              return DropdownButtonFormField<String>(
                value: isValueInItems ? rstController.selectedclf.value : null,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  hintText: "add_endorsing_community_hint".tr,
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: BrandColors.apporangeColor,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: rstController.selclf
                    .where((r) => r.clf_code != null && r.clf_code!.isNotEmpty)
                    .map((r) => DropdownMenuItem<String>(
                  value: r.clf_code!,
                  child: SizedBox(
                    width: 220,
                    child: Text(
                      r.clf_name ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) rstController.selectedclf.value = value;
                },
              );
            })
          // Obx(() => DropdownButtonFormField<String>(
                      //     value: rstController.selectedclf.isNotEmpty
                      //         ? rstController.selectedclf.value
                      //         : null,
                      //     dropdownColor: Colors.white,
                      //     decoration: InputDecoration(
                      //       hintText: "add_endorsing_community_hint".tr,
                      //       filled: true,
                      //       fillColor: Colors.white,
                      //       hintStyle: TextStyle(
                      //         color: Colors.grey.shade500,
                      //         fontSize: 14,
                      //       ),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(14),
                      //         borderSide: BorderSide.none,
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(14),
                      //         borderSide: const BorderSide(
                      //           color: BrandColors.apporangeColor,
                      //           width: 1.5,
                      //         ),
                      //       ),
                      //       contentPadding: const EdgeInsets.symmetric(
                      //         horizontal: 16,
                      //         vertical: 12,
                      //       ),
                      //       // errorText: (addfmly.clfError.value != '') ? addfmly.clfError.value : null,
                      //       // errorStyle: TextStyle(fontSize: 10, color: Colors.red, height: addfmly.clfError.value != '' ? 1.2 : 0,
                      //       // ),
                      //     ),
                      //
                      //
                      //   items: rstController.selclf
                      //       .where((r) => r.clf_code != null && r.clf_code!.isNotEmpty)
                      //       .map((r) => DropdownMenuItem<String>(
                      //     value: r.clf_code!.toString(),
                      //     child: SizedBox(
                      //       width: 220,
                      //       child: Text(
                      //         r.clf_name ?? "",
                      //         overflow: TextOverflow.ellipsis,
                      //         maxLines: 1,
                      //         style: const TextStyle(fontSize: 14),
                      //       ),
                      //     ),
                      //   ))
                      //       .toList(),
                      //
                      //   onChanged: (value) {
                      //       if (value != null)
                      //         rstController.selectedclf.value = value ?? "";
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  // buildSelectField("Endorsing Community Institution", "Select ECI", items: ["Narmada CLF", "Tulsi CLF", "Shivani CLF", "Laxmi CLF", "Durga CLF"], value: rstController.selectedCLF, onChanged: (val) {setState(() {rstController.selectedCLF = val;});},),
                  // Full Name
                  SizedBox(height: 12,),
                  buildProfileField("p_coach_name".tr, "p_enter_coach_name".tr, controller: rstController.nameController,requiredField: true),
                  SizedBox(height: 12,),
                  buildProfileField("husband_or_father_name".tr, "p_e_f_h_name".tr, controller: rstController.guardianController,requiredField: true),

                  // buildProfileField("p_Age".tr, "p_enter_age".tr, controller: rstController.ageController,requiredField: true,isNumber: true,minLength: 1,maxLength: 3),
                  SizedBox(height: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label above field
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children:  [
                            Text(
                              "dob".tr,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                       TextFormField(
                          controller: rstController.dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "select_date".tr,
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: BrandColors.apporangeColor,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today, color: BrandColors.apporangeColor),
                              onPressed:()=> rstController.pickDateBirth(context),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "p_select_date".tr : null,
                        ),

                    ],
                  ),

                  SizedBox(height: 12,),
                  buildSelectField("p_sex".tr, "p_select_sex".tr, items: [
                    {"value": "Male", "label": "p_male".tr},
                    {"value": "Female", "label": "p_female".tr},
                    {"value": "Other", "label": "p_other".tr},
                  ]
                    , value: rstController.selectedGender, onChanged: (val) {setState(() {rstController.selectedGender = val;});},),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(bottom: 6, left: 4),
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             "p_sex".tr,
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w500,
                  //               color: Colors.black87,
                  //             ),
                  //           ),
                  //           SizedBox(width: 4),
                  //           Text(
                  //             "*",
                  //             style: TextStyle(
                  //               color: Colors.red,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //
                  //     Obx(() => DropdownButtonFormField<String>(
                  //       value: dayOptions.any((e) => e["key"] == rstController.selectedGender)
                  //           ?  rstController.selectedGender
                  //           : null,
                  //       dropdownColor: Colors.white,
                  //       decoration: InputDecoration(
                  //         hintText: "p_select_sex".tr,
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //         hintStyle: TextStyle(
                  //           color: Colors.grey[500],
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //         contentPadding: const EdgeInsets.symmetric(
                  //           horizontal: 16,
                  //           vertical: 12,
                  //         ),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(14),
                  //           borderSide: BorderSide.none,
                  //         ),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(14),
                  //           borderSide: BorderSide.none,
                  //         ),
                  //         focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(14),
                  //           borderSide: BorderSide(
                  //             color: BrandColors.apporangeColor,
                  //             width: 1.5,
                  //           ),
                  //         ),
                  //       ),
                  //
                  //       items: dayOptions.map((e) => DropdownMenuItem(
                  //         value: e["key"],
                  //         child: Text(e["label"]!),
                  //       )).toList(),
                  //       onChanged: (value) {
                  //         setState(() {
                  //           rstController.selectedGender = value ?? "";
                  //         });
                  //       },
                  //     )),
                  //   ],
                  // ),
                  SizedBox(height: 12,),
                  buildProfileField("p_mobile".tr, "p_enter_mobile".tr, controller: rstController.contectController,requiredField: true,isNumber: true,minLength: 10,maxLength: 10),

                  // buildProfileField("p_Email".tr, "p_enter_email".tr, controller: rstController.emailController),

                  SizedBox(height: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label above field
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children:  [
                            Text(
                              "joining_date".tr,
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        child: TextFormField(
                          controller: rstController.joiningdateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "select_date".tr,
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: BrandColors.apporangeColor,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today, color: BrandColors.apporangeColor),
                              onPressed:()=> rstController.pickDate(context),
                            ),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? "p_select_date".tr : null,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12,),
                  // Bank Information
                  Row(
                    children: [
                      Text(
                        "p_bank_infor".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),

                  buildProfileField("p_name_bank".tr, "p_enter_name_bank".tr, controller: rstController.banknameController,readOnly: list_data.isNotEmpty, ),
                  SizedBox(height: 12,),
                  buildProfileField("p_name_on_bank_account".tr, "p_enter_name_As_per".tr, controller: rstController.name_as_bankController, readOnly: list_data.isNotEmpty, ),
                  SizedBox(height: 12,),
                  buildProfileField("p_branch".tr, "p_enter_branch_name".tr, controller: rstController.branchController,readOnly: list_data.isNotEmpty, ),
                  SizedBox(height: 12,),
                  buildProfileField("p_ifsc_code".tr, "p_enter_ifsc".tr, controller: rstController.ifscController,readOnly: list_data.isNotEmpty, ),
                  // buildProfileField("p_account_number".tr, "p_enter_account".tr, controller: rstController.accountNoController,isNumber: true),
                  SizedBox(height: 12,),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                       padding: const EdgeInsets.only(bottom: 0, left: 4),
                       child: Text(
                        "p_upload_passbook".tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                                           ),
                     ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: BrandColors.apporangeColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Gallery button
                          InkWell(
                            onTap: () => rstController.pickImage("pass"),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: BrandColors.applightColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: BrandColors.appgreenColor,
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.image,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          // Camara Button
                          InkWell(
                            onTap: () {
                              rstController.pickCamera();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: BrandColors.applightColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: BrandColors.appgreenColor,
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Obx(() {
                              final file = rstController.passbookImage.value;
                              final networkImage = rstController.networkPassbookImage.value;

                              // 🟩 CASE 1: Local image selected (show file)
                              if (file != null) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        file,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 100,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          rstController.passbookImage.value = null; // Remove local image
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else if (networkImage.isNotEmpty) {
                                return Stack(
                                    children:[
                                      ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: Api.BaseUrl + Api.imagePassbook + networkImage,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 100,
                                    placeholder: (context, url) =>
                                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      rstController.networkPassbookImage.value = ''; // Remove local image
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                                );
                              }
                              else {
                                return const SizedBox(height: 100);
                              }
                            }),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 30),
                  // Buttons
                  SafeArea(child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // button ka background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // corner rounded
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                          child:  Text(
                            "p_skip".tr,
                            style: TextStyle(
                              color: Colors.white, // text color
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            backgroundColor: BrandColors.apporangeColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11)),
                          ),
                          onPressed: () async{

                            if (rstController.selectedclf.value == null || rstController.selectedclf.value.isEmpty) {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                               return;
                            }else if (rstController.nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }else if (rstController.guardianController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }else if (rstController.dobController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }else if (rstController.selectedGender == null || rstController.selectedGender == '') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }else if (rstController.contectController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }else if (rstController.contectController.text.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }else if (rstController.joiningdateController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                              return;
                            }
                            // else if (rstController.selectedquali == '' || rstController.selectedquali == null) {
                            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("p_please_enter".tr), backgroundColor: Colors.red,),);
                            //   return;
                            // }
                            else{
                        bool result = await InternetConnectionChecker().hasConnection;
                        if(result) {
                              rstController.updateCoachProfile(context);
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please check your internet connection and try again"),
                                  backgroundColor: Colors.red, // optional: error highlight
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                            }
                          },
                          child: Text(
                            "p_save".tr,
                            style: TextStyle(
                              color: Colors.white, // text color
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ]),
        ));
  }

// Reusable Profile Field Widget
  Widget buildProfileField(
      String label,
      String hint, {
        required TextEditingController controller,
        IconData? suffix,
        bool requiredField = false,
        bool isNumber = false,
        int? minLength,
        int? maxLength,
        bool readOnly = false, // new
      }) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label with optional star
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                if (requiredField) ...[
                  const SizedBox(width: 4),
                  const Text(
                    "*",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              ],
            ),
          ),

          TextFormField(
            controller: controller,
              readOnly: is_reset != "2" ? readOnly : true,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLength: maxLength,
            decoration: InputDecoration(
              counterText: "",
              hintText: hint,
              suffixIcon: suffix != null
                  ? Icon(suffix, color: const Color(0xFF5e50a1))
                  : null,
              filled: true,
              fillColor: readOnly ? Colors.grey.shade100 : Colors.white, // grey if read-only
              hintStyle: TextStyle(
                color: readOnly ? Colors.grey.shade600 : Colors.grey.shade500,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: BrandColors.apporangeColor,
                  width: 1.5,
                ),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            validator: (value) {
              if (requiredField && (value == null || value.isEmpty)) {
                return "Please enter $label";
              }
              if (minLength != null && (value?.length ?? 0) < minLength) {
                return "$label must be at least $minLength characters";
              }
              if (maxLength != null && (value?.length ?? 0) > maxLength) {
                return "$label must be at most $maxLength characters";
              }
              return null;
            },
          ),
        ],
    );
  }


  // Select Field Widget
  Widget buildSelectField(
      String label,
      String hint, {
        required List<Map<String, String>> items,
        String? value,
        required Function(String?) onChanged,
      }) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  "*",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: BrandColors.apporangeColor,
                  width: 1.5,
                ),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                value: item["value"],
                child: Text(item["label"]!),
              ),
            )
                .toList(),
            onChanged: onChanged,
          ),
        ],

    );
  }

  //
  // Widget buildSelectField(String label, String hint,
  //     {required List<String> items,
  //     String? value,
  //     required Function(String?) onChanged}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 8.0),
  //           child: Row(
  //             children: [
  //               Text(
  //                 label,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 14,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //               const SizedBox(width: 4),
  //               const Text(
  //                 "*",
  //                 style: TextStyle(
  //                   color: Colors.red,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 6),
  //         DropdownButtonFormField<String>(
  //           value: value,
  //           dropdownColor: Colors.white,
  //           decoration: InputDecoration(
  //             hintText: hint,
  //             filled: true,
  //             fillColor: Colors.white,
  //             hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(14),
  //               borderSide: BorderSide.none,
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(14),
  //               borderSide: const BorderSide(
  //                 color: BrandColors.apporangeColor,
  //                 width: 1.5,
  //               ),
  //             ),
  //             contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           ),
  //           items: items
  //               .map((item) => DropdownMenuItem(
  //             value: item,
  //             child: Text(item),
  //           ))
  //               .toList(),
  //           onChanged: onChanged,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
