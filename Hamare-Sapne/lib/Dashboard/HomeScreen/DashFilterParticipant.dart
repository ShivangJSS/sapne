import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Controllers/family_controller.dart';
import '../Manage_Aspirations/aspiration_monotoring.dart';
import '../Manage_Aspirations/feedback.dart';
import '../Manage_Aspirations/remark.dart';
import '../Manage_Family/family_list.dart';
import '../Manage_Family/view_family.dart';
import 'HomeScreen.dart';
import 'dashboardscreen.dart';

class Dashfilterparticipant extends StatefulWidget {
  const Dashfilterparticipant({super.key});

  @override
  State<Dashfilterparticipant> createState() => _DashfilterparticipantState();
}

class _DashfilterparticipantState extends State<Dashfilterparticipant> {
  String img = "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fmlylistcontroller.getAllFamily('525101');
    fmlylistcontroller.getFilterData();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.off(()=>HomeScreen());
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
                    Get.offAll(()=>HomeScreen());
                  },
                ),
                Obx(()=> Text(
                  '${fmlylistcontroller.title}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Get.offAll(()=>HomeScreen());
                },
              ),
            ],
          ),
          body: GetBuilder<familyController>(builder: (controller) {
            SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false,);
            if (controller.filteredList.isEmpty) {
              SmartDialog.dismiss();
              return Center(child: Text("You have not any Participant!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),);
            }
            SmartDialog.dismiss();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: (value) {
                      // fmlylistcontroller.filterFamily(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Head Name...',
                      prefixIcon: const Icon(Icons.search, color: BrandColors.apporangeColor),
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
                  child: Obx(() =>
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
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: BrandColors.appColor.withOpacity(0.2),
                                        backgroundImage: (family.participant_photo != null && family.participant_photo!.isNotEmpty)
                                            ? (family.participant_photo!.startsWith('/data/') || family.participant_photo!.startsWith('/storage/')
                                            ? FileImage(File(family.participant_photo!)) as ImageProvider
                                            : null) // We'll use CachedNetworkImage for network
                                            : null,
                                        child: (family.participant_photo != null && family.participant_photo!.isNotEmpty)
                                            ? (family.participant_photo!.startsWith('/data/') || family.participant_photo!.startsWith('/storage/')
                                            ? null
                                            : ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: Api.BaseUrl + Api.imageParticipantPath + family.participant_photo!,
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                                          ),
                                        ))
                                            : const Icon(Icons.person, color: BrandColors.appColor, size: 28),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          "${family.name_participant}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      // View Button (always icon + text)
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.blue.withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (family.p_id != null && family.p_id.toString().isNotEmpty) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ViewFamily(
                                                  v_id: family.p_id.toString(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            SmartDialog.showToast("id_not_found".tr);

                                          }                                },
                                        icon: const Icon(Icons.visibility, color: Colors.blue, size: 20),
                                        label: Text(
                                          "view".tr,
                                          style: TextStyle(
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
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) => FeedBackNew(),
                                            //   ),
                                            // );
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

                                      // Remarks Button
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.purple.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await SharedPreferHelper.setPrefString("participantId",family.p_id.toString());
                                            await SharedPreferHelper.setPrefString("participantName", family.name_participant.toString());
                                            await SharedPreferHelper.setPrefString("participantFatherName",family.father_name.toString());
                                            await SharedPreferHelper.setPrefString("ProfileImage",family.participant_photo.toString());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Remark(),
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
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ],
            );
          }
          ),
        )
    );
  }
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
