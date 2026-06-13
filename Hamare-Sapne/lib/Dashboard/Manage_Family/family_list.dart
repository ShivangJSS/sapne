import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/Api.dart';
import 'package:trikal_up/Controllers/family_controller.dart';
import 'package:trikal_up/Dashboard/Manage_Family/panchayet_list.dart';
import 'package:trikal_up/Dashboard/Manage_Family/view_family.dart';
import '../../Common/BrandColors.dart';
import '../../Common/DatabaseHelper.dart';
import '../../Common/SharedPreferHelper.dart';
import '../HomeScreen/HomeScreen.dart';
import '../Manage_Aspirations/aspiration_monotoring.dart';
import '../Manage_Aspirations/remark.dart';
import 'add_family.dart';

familyController fmlylistcontroller = Get.find<familyController>();

class FamilyList extends StatefulWidget {
  final String villLgdCode;
  final bool fromDashboard;
  final bool isAspirNotFeed;
  final bool Feed;
  final bool pending;
  FamilyList({required this.villLgdCode, this.fromDashboard = false, this.isAspirNotFeed = false,this.pending =false, this.Feed =  false, super.key}); // default false

  @override
  State<FamilyList> createState() => _FamilyListState();
}

class _FamilyListState extends State<FamilyList> {

  @override
  void initState() {
    super.initState();
    fmlylistcontroller.filteredList.assignAll(fmlylistcontroller.list_data);
    if (widget.isAspirNotFeed) {
      print('hhh');
      print('${widget.villLgdCode}');
      fmlylistcontroller.getAllFamilyOrFeedback(
        widget.fromDashboard,
        widget.villLgdCode,

      );
    }else if (widget.Feed) {
      print('feed');
      print('${widget.villLgdCode}');
      fmlylistcontroller.getAllFamilyFeedback(
        widget.fromDashboard,
        widget.villLgdCode,

      );
    }else if (widget.pending) {
      print('pending');
      fmlylistcontroller.getAllFamilyPending(
        widget.fromDashboard,
        widget.villLgdCode,

      );
    } else {
      fmlylistcontroller.getAllFamily(widget.villLgdCode);
      print('${widget.villLgdCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      if (widget.fromDashboard) {
        Navigator.pop(context); // Normal back
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PanchayetList(),
          ),
        );
      }
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
                    if (widget.fromDashboard) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PanchayetList(),
                        ),
                      );
                    }
                  },
                ),

                Expanded(
                  child: Text(
                    widget.isAspirNotFeed
                        ? 'p_aspir'.tr
                        : widget.Feed
                        ? 'p_feed'.tr
                        : widget.pending
                        ? 'p_actions'.tr
                        : 'puch_apptext'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis
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
          body: GetBuilder<familyController>(builder: (controller) {
            SmartDialog.showLoading(
              backDismiss: false,
              clickMaskDismiss: false,
            );
            if (controller.filteredList.isEmpty) {
              SmartDialog.dismiss();
              return Center(
                child: Text(
                  "empty_msg".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }
            SmartDialog.dismiss();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: (value) {
                      fmlylistcontroller.filterFamily(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'search_msg'.tr,
                      prefixIcon: const Icon(Icons.search,
                          color: BrandColors.apporangeColor),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: BrandColors.apporangeColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: BrandColors.apporangeColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
            child: SafeArea (child: Obx(() =>
                      ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: fmlylistcontroller.filteredList.length,
                        itemBuilder: (context, index) {
                          final family = fmlylistcontroller.filteredList[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // 🖼 Profile Picture (Circular + Cute Shadow)
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 28,
                                          backgroundColor: Colors.grey.shade100,
                                          backgroundImage: (family.participant_photo != null && family.participant_photo!.isNotEmpty)
                                              ? (family.participant_photo!.startsWith('/data/') ||
                                              family.participant_photo!.startsWith('/storage/')
                                              ? FileImage(File(family.participant_photo!)) as ImageProvider
                                              : null)
                                              : null,
                                          child: (family.participant_photo != null && family.participant_photo!.isNotEmpty)
                                              ? (family.participant_photo!.startsWith('/data/') ||
                                              family.participant_photo!.startsWith('/storage/')
                                              ? null
                                              : ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: Api.BaseUrl + Api.imageParticipantPath + family.participant_photo!,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const Padding(
                                                padding: EdgeInsets.all(12),
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(
                                                Icons.person,
                                                color: BrandColors.appColor,
                                                size: 28,
                                              ),
                                            ),
                                          ))
                                              : const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      // 👤 Participant Name
                                      Expanded(
                                        child: Text(
                                          "${family.name_participant}",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ),

                                      // 👁 View Button — modern + cute
                                    TextButton.icon(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          backgroundColor: Colors.blue.withOpacity(0.08),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (family.p_id != null && family.p_id.toString().isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ViewFamily(v_id: family.p_id.toString()),
                                              ),
                                            );
                                          } else {
                                            SmartDialog.showToast("id_not_found".tr);
                                          }
                                        },
                                        icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                                        label: Text(
                                          "view".tr,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Divider(height: 20, thickness: 1),

                                  _buildDetailRow("participant_id".tr,
                                      "${family.participant_id}"),
                                  _buildDetailRow(
                                      "father_name".tr, "${family.father_name}"),
                                  _buildDetailRow("date_of_joining".tr,
                                      "${family.selection_year}"),

                                  const SizedBox(height: 12),

                                  // Bottom Row: Action Buttons (Icon + Text fix)
                          Row(

                                    children: [
                                      // Aspirations Button
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.orange.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await SharedPreferHelper.setPrefString("type", "");
                                            await SharedPreferHelper.setPrefString("typeGone", "No");
                                            await SharedPreferHelper.setPrefString("participantName", family.name_participant.toString());
                                            await SharedPreferHelper.setPrefString("participantFatherName",family.father_name.toString());
                                            await SharedPreferHelper.setPrefString("participantFatherName",family.father_name.toString());
                                            await SharedPreferHelper.setPrefString("ProfileImage",family.participant_photo.toString());
                                            await SharedPreferHelper.setPrefString("participantId", family.p_id.toString());

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AspirationMonotoring(
                                                  p_id: "${family.p_id}",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "aspiration".tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Feedback Button
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.green.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await SharedPreferHelper.setPrefString("type", "");
                                            await SharedPreferHelper.setPrefString("typeGone", "Yes");
                                            await SharedPreferHelper.setPrefString("participantId",family.p_id.toString());
                                            await SharedPreferHelper.setPrefString("participantName", family.name_participant.toString());
                                            await SharedPreferHelper.setPrefString("participantFatherName",family.father_name.toString());
                                            await SharedPreferHelper.setPrefString("ProfileImage",family.participant_photo.toString());


                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => AspirationMonotoring(
                                                  p_id: "${family.p_id}",
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "feedback".tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),


                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.purple.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            var db = await DatabaseHelper.instance.database;

                                            // 🔹 Fetch all feedback records for this participant
                                            List<Map<String, dynamic>> feedbackData = await db.query(
                                              'feedback',
                                              where: 'participant_id = ?',
                                              whereArgs: [family.p_id],
                                            );

                                            print("📦 Feedback fetched from DB: $feedbackData");

                                            if (feedbackData.isEmpty) {
                                              await SharedPreferHelper.setPrefString("participant_feedback_ids", "");
                                              Get.snackbar('remarks'.tr, 'submit_remark'.tr,backgroundColor: Colors.purple.shade50,
                                                colorText: Colors.purple,);
                                            return;
                                            }

                                            // 🔹 Extract all feedback IDs for this participant
                                            List<String> feedbackIds = feedbackData
                                                .map((e) => e['feedback_id'].toString())
                                                .toList();

                                            await SharedPreferHelper.setPrefString(
                                              "participant_feedback_ids",
                                              feedbackIds.join(','), // Save all IDs as comma-separated
                                            );

                                            // 🔹 Save each feedback detail separately
                                            for (var feedback in feedbackData) {
                                              String feedbackId = feedback['feedback_id'].toString();
                                              String optionId = feedback['option_id'].toString();
                                              String aspCatId = feedback['asp_sub_cat_id'].toString();
                                              String questionId = feedback['question_id'].toString();
                                              String aspId = feedback['aspiration_id'].toString();


                                              // Optional: Fetch related aspiration data if needed
                                              List<Map<String, dynamic>> aspirationData = await db.query(
                                                'aspiration',
                                                where: 'asp_details_id = ? AND participant_id = ?',
                                                whereArgs: [aspId, family.p_id],
                                              );
                                              String remark = "";
                                              if (aspirationData.isNotEmpty) {
                                                remark = aspirationData.first['remarks']?.toString() ?? "";
                                              }
                                              // Save all in Shared Preferences
                                              await SharedPreferHelper.setPrefString("Remark_$feedbackId", remark);
                                              await SharedPreferHelper.setPrefString("OptionIds_$feedbackId", optionId);
                                              await SharedPreferHelper.setPrefString("SubCategory_$feedbackId", aspCatId);
                                              await SharedPreferHelper.setPrefString("SubCategoryImages_$feedbackId", aspCatId);
                                              await SharedPreferHelper.setPrefString("QuetionId_$feedbackId", questionId);
                                            }

                                            // 🔹 Save participant details
                                            await SharedPreferHelper.setPrefString("participantId", family.p_id.toString());
                                            await SharedPreferHelper.setPrefString("participantName", family.name_participant.toString());
                                            await SharedPreferHelper.setPrefString("participantFatherName", family.father_name.toString());
                                            await SharedPreferHelper.setPrefString("ProfileImage", family.participant_photo.toString());

                                            print('👨‍👩‍👦 Participant: ${family.name_participant} (${family.p_id})');
                                            print('✅ Saved all feedbacks: ${feedbackIds.join(', ')}');

                                            // 🔹 Navigate to remark screen (where you’ll list all)
                                            await SharedPreferHelper.setPrefBool("cameFromFeedback", false);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Remark(fromFeedback: true),
                                              ),
                                            );

                                          },
                                          child: Text(
                                            "remarks".tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )),)
                ),
              ],
            );
          }),
          floatingActionButton:  FloatingActionButton(
            backgroundColor: BrandColors.apporangeColor,
            onPressed: () async {
              await SharedPreferHelper.setPrefString('id', '');
              await SharedPreferHelper.setPrefString("type", "");
              print('add');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Addfamily()));
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(dynamic family) {
    String? familyPhoto = family.participant_photo;
    List<String> imageUrls = [];

    if (familyPhoto != null && familyPhoto.isNotEmpty) {
      // List<String> images = familyPhoto.contains(',')
      //     ? familyPhoto.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',')
      //     : [familyPhoto.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '')];

      String url = familyPhoto.trim();
      // for (var url in images) {
        String lowerUrl = url.trim().toLowerCase();
      if (lowerUrl.endsWith('.jpg') ||
          lowerUrl.endsWith('.jpeg') ||
          lowerUrl.endsWith('.png') ||
          lowerUrl.endsWith('.gif')) {

        if (url.startsWith("/data/")) {
          // Local file path
          imageUrls.add(url);
          print("Added local image: $url");
        }  else {
            imageUrls.add("https://stage-trickleup.indevconsultancy.in/public/assets/images/participant-images/" + url.trim());
          }
        }
      }
    // }

    // Always return a Widget
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: BrandColors.appColor.withOpacity(0.2),
          backgroundImage: imageUrls.isNotEmpty
              ? (imageUrls.first.startsWith("/data/")
              ? FileImage(File(imageUrls.first)) as ImageProvider
              : NetworkImage(imageUrls.first))
              : null,
          child: imageUrls.isEmpty
              ? const Icon(Icons.person, color: BrandColors.appColor, size: 28)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "${family.name_participant}",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

}