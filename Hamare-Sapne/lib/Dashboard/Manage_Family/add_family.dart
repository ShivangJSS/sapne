import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Controllers/family_controller.dart';
import '../HomeScreen/HomeScreen.dart';

familyController addfmly = Get.find<familyController>();

class Addfamily extends StatefulWidget {
  const Addfamily({super.key});

  @override
  State<Addfamily> createState() => _AddfamilyState();
}

class _AddfamilyState extends State<Addfamily> {
  // String? familyPhoto = participant_photo;
  // List<String> imageUrls = [];
  // String addfmlyctrl = "";
  // String addfmlytype = "";

  @override
  void initState() {
    super.initState();
    getData();
     loadPref();
  }

  Future<void> getData() async {
    addfmly.clearValidationErrors();
    await addfmly.getopration();
    await addfmly.getLocation(context);
    await addfmly.getselectpunch();
    addfmly.getselectvill(addfmly.selectedPanchayet.value);
    await addfmly.getselectclf();

    await loadPref();
    setState(() {

    });
  }

  Future<void> loadPref() async {
    String? value = await SharedPreferHelper.getPrefString("id", '');
    String? type = await SharedPreferHelper.getPrefString("type", '');

    setState(() {
      print('type $type');

      addfmly.addfmlytype.value = type ?? "";
      addfmly.addfmlyctrl.value = value ?? "";
    });

    if (type != "edit") {
      addfmly.pidController.text = addfmly.generateUniqueId();
      addfmly.profileImage.value = null;
    }
    else {
      final profile = await SharedPreferHelper.getPrefString('profile_photo', '');
      addfmly.networkUrl.value = profile.isNotEmpty ? profile : null;

      print("hshdhs ${addfmly.networkUrl.value}");
    }
    addfmly.coachnameController.text = await SharedPreferHelper.getPrefString("full_name", '');
    addfmly.contectcoachController.text = await SharedPreferHelper.getPrefString("mobile_no", '');
  }


  final maritalOptions = [
    {"key": "Single", "label": "a_single".tr},
    {"key": "Married", "label": "a_married".tr},
    {"key": "Widowed", "label": "a_widowed".tr},
    {"key": "Divorced", "label": "a_divorced".tr},
    {"key": "Separated", "label": "a_separated".tr},
    {"key": "Other", "label": "p_other".tr},
  ];

  final dayOptions = [
    {"key": "Sunday", "label": "a_Sunday".tr},
    {"key": "Monday", "label": "a_Monday".tr},
    {"key": "Tuesday", "label": "a_Tuesday".tr},
    {"key": "Wednesday", "label": "a_Wednesday".tr},
    {"key": "Thursday", "label": "a_Thursday".tr},
    {"key": "Friday", "label": "a_Friday".tr},
    {"key": "Saturday", "label": "a_Saturday".tr},
  ];
  final educationOptions = [
    {"key": "No Formal Education", "label": "a_no_formal".tr},
    {"key": "Primary Education (I-VIII)", "label": "a_primary_edu".tr},
    {"key": "Secondary Education (IX-X)", "label": "a_secondary".tr},
    {"key": "Higher Secondary Education (XI-XII)", "label": "a_higher_secondary".tr},
    {"key": "Diploma", "label": "a_diploma".tr},
    {"key": "Other", "label": "p_other".tr},
  ];

  // Date Picker
  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: BrandColors.apporangeColor, // header & selected date
              onPrimary: Colors.white, // text on selected date
              onSurface: Colors.black, // default text color
            ),
            dialogBackgroundColor: Colors.white, // background of date picker
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
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

            Expanded(
              child: Obx(() {
                bool isAdd = addfmly.addfmlytype.value != "edit";

                return Text(
                  isAdd ? 'add_apptext'.tr : 'upd_apptext'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                );
              }),
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: addfmly.formKey,
          child: ListView(
            children: [
              // Obx(()=>buildTextField("Participant ID", "Unique Id",addfmly.pidError.value, addfmly.pidController, inputType: TextInputType.phone, isRequired: true, isPhone: true, minLength: 10, maxLength: 10)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "add_participant_id".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextFormField(
                controller: addfmly.pidController,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "add_participant_id_hint".tr,
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => buildTextField(
                "add_participant_name".tr,
                "add_participant_name_hint".tr,
                addfmly.nameError.value,
                addfmly.nameController,
                isRequired: true,
              )),
              const SizedBox(height: 12),
              Obx(() => buildTextField(
                "add_participant_father_name".tr,
                "add_participant_father_name_hint".tr,
                addfmly.fathernameError.value,
                addfmly.fahernameController,
                isRequired: true,
              )),
              const SizedBox(height: 12),
              Obx(() => buildTextField(
                  "add_participant_age".tr,
                  "add_participant_age_hint".tr,
                  addfmly.ageError.value,
                  addfmly.ageController,
                  inputType: TextInputType.number,
                  isRequired: true,
                  minLength: 1,
                  maxLength: 3)),
              const SizedBox(height: 12),
              // Relation Dropdown
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "add_select_panchayat".tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "*",
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        Obx(
                              () => DropdownButtonFormField<String>(
                            isExpanded: true,   // important
                            // value: addfmly.selectedPanchayet.value.isNotEmpty
                            //     ? addfmly.selectedPanchayet.value
                            //     : null,
                                value: addfmly.selpanch.any((e) =>
                                e.gp_lgd_code.toString() == addfmly.selectedPanchayet.value)
                                    ? addfmly.selectedPanchayet.value
                                    : null,
                            dropdownColor: Colors.white,

                            decoration: InputDecoration(
                              hintText: "add_select_panchayat_hint".tr,
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              errorText: addfmly.selectedpunchError.value != ''
                                  ? addfmly.selectedpunchError.value
                                  : null,
                              errorStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                height: addfmly.selectedpunchError.value != '' ? 1.2 : 0,
                              ),
                            ),

                            items: addfmly.selpanch.map((r) {
                              return DropdownMenuItem<String>(
                                value: r.gp_lgd_code?.toString() ?? "",
                                child: Text(r.gp_name ?? ""),
                              );
                            }).toList(),

                                onChanged: (value) {
                                  if (value != null) {
                                    addfmly.selectedPanchayet.value = value;

                                    addfmly.selectedVillage.value = "";

                                    addfmly.getselectvill(value);   // village load by gp
                                  }
                                },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label above dropdown
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "add_select_village".tr,
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
                  // Dropdown field
                  Obx(
                        () => DropdownButtonFormField<String>(
                      // value: addfmly.selectedVillage.value.isEmpty
                      //     ? null
                      //     : addfmly.selectedVillage.value,
                          value: addfmly.selvill.any(
                                  (e) => e.village_lgd_code == addfmly.selectedVillage.value)
                              ? addfmly.selectedVillage.value
                              : null,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "add_select_village_hint".tr,
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: BrandColors.apporangeColor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        errorText: (addfmly.selectedvillError.value != '') ? addfmly.selectedvillError.value : null,
                        errorStyle: TextStyle(fontSize: 10, color: Colors.red, height: addfmly.selectedvillError.value != '' ? 1.2 : 0,),
                      ),
                      items: addfmly.selvill.map((r) {
                        return DropdownMenuItem<String>(
                          value: r.village_lgd_code,
                          child: Text(r.village_name!),
                        );
                      }).toList(),
                      onChanged: (value) =>
                      addfmly.selectedVillage.value = value ?? '',
                      validator: (value) => value == null || value.isEmpty
                          ? "Please select village"
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(
                    () => buildTextField(
                    "add_tola_para".tr,
                    "add_tola_para_hint".tr,
                    addfmly.tolaError.value,
                    addfmly.tolaController,
                    isRequired: true),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label above dropdown
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "add_endorsing_community".tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Dropdown field (no fixed height)
                  Obx(
                        () => DropdownButtonFormField<String>(
                      // value: addfmly.selectedclf.value.isNotEmpty
                      //     ? addfmly.selectedclf.value
                      //     : null,
                          value: addfmly.selclf.any(
                                  (e) => e.clf_code == addfmly.selectedclf.value)
                              ? addfmly.selectedclf.value
                              : null,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "add_endorsing_community_hint".tr,
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        errorText: (addfmly.clfError.value != '') ? addfmly.clfError.value : null,
                        errorStyle: TextStyle(fontSize: 10, color: Colors.red, height: addfmly.clfError.value != '' ? 1.2 : 0,
                        ),
                      ),
                      items: addfmly.selclf.map((r) {
                        return DropdownMenuItem<String>(
                          value: r.clf_code?.toString() ?? "",
                          child: SizedBox(
                            width: 220,
                            child: Text(r.clf_name ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1, // show only 1 line
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null)
                          addfmly.selectedclf.value = value ?? "";
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Date Picker Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label above field
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Wrap(
                      children: [
                        Text(
                          "add_year_of_selection".tr,
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
                  Obx(
                        () => TextFormField(
                      controller: addfmly.dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "add_year_of_selection_hint".tr,
                        errorText: (addfmly.dateError.value != '') ? addfmly.dateError.value : null,
                        errorStyle: TextStyle(fontSize: 10, color: Colors.red, height: addfmly.dateError.value != '' ? 1.2 : 0,),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
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
                          borderSide: const BorderSide(
                              color: BrandColors.apporangeColor, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today,
                              color: BrandColors.apporangeColor),
                          onPressed: () => _pickDate(addfmly.dateController),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
// Dropdown field
              // Obx(() => DropdownButtonFormField<String>(
              //   style: const TextStyle(
              //     fontSize: 12,
              //     color: Colors.black,
              //   ),
              //   value: maritalOptions.any((e) => e["key"] == addfmly.marriage.value)
              //       ? addfmly.marriage.value
              //       : null,
              //   dropdownColor: Colors.white,
              //   decoration: InputDecoration(
              //     hintText: "add_marital_status_hint".tr,
              //     errorText: (addfmly.marrigeError.value != '')
              //         ? addfmly.marrigeError.value
              //         : null,
              //     errorStyle: TextStyle(
              //       fontSize: 10,
              //       color: Colors.red,
              //       height:
              //       addfmly.marrigeError.value != '' ? 1.2 : 0,
              //     ),
              //     filled: true,
              //     fillColor: Colors.white,
              //     hintStyle: TextStyle(
              //       color: Colors.grey[500],
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500,
              //     ),
              //     contentPadding: const EdgeInsets.symmetric(
              //       horizontal: 16,
              //       vertical: 12,
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(14),
              //       borderSide: BorderSide.none,
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(14),
              //       borderSide: BorderSide.none,
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(14),
              //       borderSide: BorderSide(
              //         color: BrandColors.apporangeColor,
              //         width: 1.5,
              //       ),
              //     ),
              //   ),
              //
              //   items: maritalOptions.map((e) => DropdownMenuItem(
              //     value: e["key"],
              //     child: Text(e["label"]!),
              //   )).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       addfmly.marriage.value = value ?? "";
              //       if (value != "Other") {
              //         addfmly.otherMarriageText.value = ""; // clear when not "other"
              //       }
              //     });
              //   },
              // )),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "add_marital_status".tr + " ",
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

                    Obx(() => DropdownButtonFormField<String>(
                      isExpanded: true, // ⭐ important
                      value: maritalOptions.any(
                              (e) => e["label"] == addfmly.marriage.value)
                          ? addfmly.marriage.value
                          : null,
                      dropdownColor: Colors.white,

                      decoration: InputDecoration(
                        hintText: "add_marital_status_hint".tr,
                        errorText: (addfmly.marrigeError.value != '')
                            ? addfmly.marrigeError.value
                            : null,
                        errorStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          height: addfmly.marrigeError.value != '' ? 1.2 : 0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
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
                      ),

                      items: maritalOptions
                          .map((e) => DropdownMenuItem(
                        value: e["label"],
                        child: Text(e["label"]!),
                      ))
                          .toList(),

                      onChanged: (value) {
                        addfmly.marriage.value = value ?? "";
                        if (value != "p_other".tr) {
                          addfmly.otherMarriageText.value = "";
                        }
                      },
                    )),



                    Obx(() {
                      if (addfmly.marriage.value == "p_other".tr) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: const [
                                  Text(
                                    "Other",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
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
                              controller: addfmly.otherMarriageController,
                              onChanged: (val) {
                                addfmly.otherMarriageText.value = val;
                              },
                              decoration: InputDecoration(
                                hintText: "Please specify",
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
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
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                  ],
                ),
              ),
            ],
          ),
              const SizedBox(height: 12),

              Obx(
                    () => buildTextFieldMobile(
                    "add_mobile_number".tr,
                    "add_mobile_number_hint".tr,
                    addfmly.contectError.value,
                    addfmly.contectController,
                    inputType: TextInputType.phone,
                    isRequired: false,
                    isPhone: true,
                    minLength: 10,
                    maxLength: 10),
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed label above dropdown
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "add_level_of_education".tr,
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

      Obx(() => DropdownButtonFormField<String>(
        value: educationOptions.any((e) => e["label"] == addfmly.selectedquali.value)
            ? addfmly.selectedquali.value
            : null,

        items: educationOptions.map((e) => DropdownMenuItem(
          value: e["label"],           // save translated label
          child: Text(e["label"]!),    // translated text for UI
        )).toList(),

        onChanged: (value) {
          addfmly.selectedquali.value = value ?? "";
        },

        decoration: InputDecoration(
          hintText: "add_level_of_education_hint".tr,
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          errorText: (addfmly.educationError.value ?? '').isNotEmpty
              ? addfmly.educationError.value
              : null,
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
        ),
      )),

                ],
              ),
              const SizedBox(height: 12),

              Obx(
                    () => buildTextField(
                    "add_total_fmly_mem".tr,
                    "add_total_fmly_mem_hint".tr,
                    addfmly.totalfmlyError.value,
                    addfmly.total_family_mem,
                    inputType: TextInputType.number,
                    isRequired: true,
                    isPhone: true,
                    minLength: 2,
                    maxLength: 2),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Adults".tr, // label text
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: addfmly.tadult_mem,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => addfmly.validateFamilyCount(),
                          decoration: InputDecoration(
                            hintText: "adults".tr,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12), // space between fields
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Children".tr, // label text
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        TextFormField(
                          controller: addfmly.tchildren_mem,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => addfmly.validateFamilyCount(),
                          decoration: InputDecoration(
                            hintText: "children".tr,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Obx(
                    () => buildTextField(
                    "add_head_fmly_mem".tr,
                    "add_head_fmly_mem_hint".tr,
                    addfmly.headError.value,
                    addfmly.fmlyheadController,
                    isRequired: true),
              ),
              const SizedBox(height: 12),

              // Radio Buttons
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "add_whether_literate".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
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
                    Obx(() => addfmly.lightrateError.value != ""
                        ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        addfmly.lightrateError.value!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    )
                        : const SizedBox())
                  ],
                ),
              ),
              Obx(
                    () => Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      activeColor: BrandColors.apporangeColor,
                      groupValue: addfmly.lightrate.value,
                      onChanged: (value) =>
                          setState(() => addfmly.lightrate.value = value!),
                    ),
                    Text("yes".tr),
                    Radio<String>(
                      value: "No",
                      activeColor: BrandColors.apporangeColor,
                      groupValue: addfmly.lightrate.value,
                      onChanged: (value) =>
                          setState(() => addfmly.lightrate.value = value!),
                    ),
                    Text("no".tr),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Replace this whole block with the provided code
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label + required star
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "add_abled_person_in_family".tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                  ]),),
                    // Error (if any)
                    Obx(
                          () => addfmly.diffabledfmlyyError.value != ""
                          ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          addfmly.diffabledfmlyyError.value!,
                          style: const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),

                    // Yes / No radio buttons
                    Obx(
                          () => Row(
                        children: [
                          Radio<String>(
                            value: "Yes",
                            activeColor: BrandColors.apporangeColor,
                            groupValue: addfmly.abled_person_family.value,
                            onChanged: (value) {
                              addfmly.abled_person_family.value = "Yes";
                              // When Yes is selected, clear reason
                              addfmly.reasonController.clear();
                            },
                          ),
                          Text("yes".tr),

                          Radio<String>(
                            value: "No",
                            activeColor: BrandColors.apporangeColor,
                            groupValue: addfmly.abled_person_family.value,
                            onChanged: (value) {
                              addfmly.abled_person_family.value = "No";
                              // When No is selected, clear numeric fields
                              addfmly.abled_person_adult.clear();
                              addfmly.abled_person_children.clear();
                            },
                          ),
                          Text("no".tr),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Show Adults & Children ONLY when "Yes" is selected
                    Obx(
                          () => addfmly.abled_person_family.value == "Yes"
                          ? Column(
                        children: [
                          Row(
                            children: [
                              // Adults section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Adults".tr,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Text(
                                            " *",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    TextFormField(
                                      controller: addfmly.abled_person_adult,
                                      keyboardType: TextInputType.number,
                    onChanged: (_) => addfmly.validateFamilyCount(),
                                      decoration: InputDecoration(
                                        hintText: "adults".tr,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Children section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Children".tr,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Text(
                                            " *",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    TextFormField(
                                      controller: addfmly.abled_person_children,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => addfmly.validateFamilyCount(),
                                      decoration: InputDecoration(
                                        hintText: "children".tr,
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(14),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),


                  ],
                ),
              ),





              const SizedBox(height: 12),

              // Radio Buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "add_mem_of_shg".tr + " ",
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
                  Obx(
                        () => addfmly.memofshgError.value != ""
                        ? Text(
                      addfmly.memofshgError.value!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
              Obx(
                    () => Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      activeColor: BrandColors.apporangeColor,
                      groupValue: addfmly.mem_of_shg.value,
                      // onChanged: (value) => addfmly.mem_of_shg.value = value!,
                      onChanged: (value) {
                        addfmly.mem_of_shg.value = value!;
                        addfmly.attendshg.value = "";
                        addfmly.wantshg.value = "";
                      }, ),
                    Text("yes".tr),
                    Radio<String>(
                      value: "No",
                      activeColor: BrandColors.apporangeColor,
                      groupValue: addfmly.mem_of_shg.value,
                      onChanged: (value) => addfmly.mem_of_shg.value = value!,
                    ),
                    Text("no".tr),
                  ],
                ),
              ),

              Obx(() {
                if (addfmly.mem_of_shg.value == "yes".tr) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "add_do_you_attend_any_shg".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: "Yes",
                              activeColor: BrandColors.apporangeColor,
                              groupValue: addfmly.attendshg.value,
                              onChanged: (value) =>
                              addfmly.attendshg.value = value!,
                            ),
                            Text("yes".tr),
                            Radio<String>(
                              value: "No",
                              activeColor: BrandColors.apporangeColor,
                              groupValue: addfmly.attendshg.value,
                              onChanged: (value) =>
                              addfmly.attendshg.value = value!,
                            ),
                            Text("no".tr),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (addfmly.mem_of_shg.value == "No") {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          "add_would_you_want_shg".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500,
                          color: Colors.black87),
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: "Yes",
                              activeColor: BrandColors.apporangeColor,
                              groupValue: addfmly.wantshg.value,
                              onChanged: (value) =>
                              addfmly.wantshg.value = value!,
                            ),
                            Text("yes".tr),
                            Radio<String>(
                              value: "No",
                              activeColor: BrandColors.apporangeColor,
                              groupValue: addfmly.wantshg.value,
                              onChanged: (value) =>
                              addfmly.wantshg.value = value!,
                            ),
                            Text("no".tr),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "add_name_of_coach".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextFormField(
                controller: addfmly.coachnameController,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "add_name_of_coach_hint".tr,
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Text(
                      "add_hh_visit_day".tr,
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


      Obx(() => DropdownButtonFormField<String>(
        value: dayOptions.any((e) => e["label"] == addfmly.selected_hh.value)
            ? addfmly.selected_hh.value
            : null,
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          hintText: "add_hh_visit_day_hint".tr,
          errorText: (addfmly.hhError.value != '') ? addfmly.hhError.value : null,
          errorStyle: TextStyle(
            fontSize: 16,
            color: Colors.red,
            height: addfmly.hhError.value != '' ? 1.2 : 0,
          ),
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
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
        ),

        items: dayOptions.map((e) => DropdownMenuItem(
          value: e["label"], // translated label
          child: Text(e["label"]!),
        )).toList(),

        onChanged: (value) {
          setState(() {
            addfmly.selected_hh.value = value ?? "";
          });
        },
      ))
            ],
          ),
          const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "add_coach_contact_number".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextFormField(
                controller: addfmly.contectcoachController,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "add_coach_contact_number_hint".tr,
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
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "add_upload_participant_img".tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87
                    ),
                  ),

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
                          onTap: addfmly.pickImage,
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
                            addfmly.pickCamera();
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
                        // Image preview with cross button
                        Expanded(
                          child: Obx(() {
                            if (addfmly.profileImage.value != null || addfmly.networkUrl.value != null) {
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: addfmly.profileImage.value != null
                                        ? Image.file(
                                      addfmly.profileImage.value!,
                                      width: 108,
                                      height: 108,
                                      fit: BoxFit.cover,
                                    )
                                        : CachedNetworkImage(
                                      imageUrl: Api.BaseUrl + Api.imageParticipantPath + addfmly.networkUrl.value!,
                                      width: 108,
                                      height: 108,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(strokeWidth: 2),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.person,
                                          color: BrandColors.appColor, size: 28),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        addfmly.profileImage.value = null;
                                        addfmly.networkUrl.value = null;
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
                            else {
                              return Container();
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                        () => addfmly.imageError.value != null &&
                        addfmly.imageError.value!.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        addfmly.imageError.value!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 12),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Add Button
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandColors.apporangeColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor:
                    Colors.black.withOpacity(0.3), // optional shadow color
                  ),
                  onPressed: () {
                    // if (addfmly.formKey.currentState!.validate()) {
                    addfmly.insertData(context);
                    // }
                  },
                   child: Obx(() {
                      bool isAdd = addfmly.addfmlytype.value != "edit";

                      return Text(
                        isAdd ? "submit".tr : "update".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      );
                    })

                    // child: Text(
                    // (addfmlyctrl.isEmpty && addfmlytype.isEmpty)
                    //     ? "submit".tr
                    //     : "update".tr,
                    // style: TextStyle(
                    //   color: Colors.white,
                    //   fontWeight: FontWeight.w600,
                    //   fontSize: 16,
                    // ),
                  // ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<List<Map<String, dynamic>>> fetchDataFromApi(String url) async {
  //   try {
  //     final uri = Uri.parse(url);
  //     final response = await http.get(uri);
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       // Ensure 'data' exists and is a List
  //       if (data['data'] != null && data['data'] is List) {
  //         return List<Map<String, dynamic>>.from(data['data']);
  //       } else {
  //         return [];
  //       }
  //     } else {
  //       print("Failed to fetch data. Status code: ${response.statusCode}");
  //       return [];
  //     }
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //     return [];
  //   }
  // }
  Widget buildTextField(
      String label,
      String hint,
      String? errorText,
      TextEditingController controller, {
        TextInputType inputType = TextInputType.text,
        bool isRequired = false,
        bool isPhone = false,
        bool isEmail = false,
        int? minLength,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              if (isRequired) ...[     TextSpan(
                  text: " *",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
        ]
              ],
            ),
          ),
        ),
        // TextFormField
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: [
            if (isPhone) FilteringTextInputFormatter.digitsOnly,
            if (maxLength != null)
              LengthLimitingTextInputFormatter(maxLength), // limit
          ],
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            errorText:
            (errorText != null && errorText.isNotEmpty) ? errorText : null,
            errorStyle: TextStyle(
                height: (errorText != null && errorText.isNotEmpty) ? 1.2 : 0),
          ),
        ),
      ],
    );
  }


  Widget buildTextFieldMobile(
      String label,
      String hint,
      String? errorText,
      TextEditingController controller, {
        TextInputType inputType = TextInputType.text,
        bool isRequired = false,
        bool isPhone = false,
        bool isEmail = false,
        int? minLength,
        int? maxLength,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 4.0), // bottom: 0
          child: Wrap(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // TextFormField
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: [
            if (isPhone) FilteringTextInputFormatter.digitsOnly,
            if (maxLength != null)
              LengthLimitingTextInputFormatter(maxLength), // limit
          ],
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            errorText:
            (errorText != null && errorText.isNotEmpty) ? errorText : null,
            errorStyle: TextStyle(
                height: (errorText != null && errorText.isNotEmpty) ? 1.2 : 0),
          ),
        ),
      ],
    );
  }

}