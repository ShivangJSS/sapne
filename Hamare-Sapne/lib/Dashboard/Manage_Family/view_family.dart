import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Dashboard/Manage_Family/add_family.dart';

import '../../Common/BrandColors.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Controllers/family_controller.dart';
import '../HomeScreen/HomeScreen.dart';

familyController controller = Get.find<familyController>();

class ViewFamily extends StatefulWidget {
  final String v_id;
  const ViewFamily({super.key, required this.v_id});
  @override
  State<ViewFamily> createState() => _ViewFamilyState();
}

class _ViewFamilyState extends State<ViewFamily> {
  String village_name = "";
  String panchayat_name = "";
  @override
  void initState() {
    super.initState();
    SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);
    loadFamilyAndFetchNames();
  }

  void loadFamilyAndFetchNames() async {
    await controller.getOneFamily(widget.v_id.toString());
    await controller.fetchData();
    SmartDialog.dismiss();
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
                Navigator.pop(context); // Custom back action
              },
            ),
            Expanded( // ⭐ important
              child: Text(
                "view_appbaartext".tr,
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
      body: GetBuilder<familyController>(builder: (controller) {
        if (controller.familyData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row (Title + Edit Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${controller.familyData[0]['name_participant']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BrandColors.apporangeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        minimumSize: const Size(60, 26),
                      ),
                      onPressed: () async {
                        // print("${widget.v_id}");
                        await SharedPreferHelper.setPrefString('id', "${widget.v_id}");
                        await SharedPreferHelper.setPrefString("profile_photo", "${controller.familyData[0]['participant_photo']}");
                        await SharedPreferHelper.setPrefString("type", "edit");
                        print('iddd ${widget.v_id}');
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Addfamily()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "profile_edit".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.edit, color: Colors.white, size: 20),
                        ],
                      ),
                    )
                  ],
                ),

                const Divider(),
                const SizedBox(height: 16),
                // All Details
                _buildDetailRow("add_participant_id".tr, "${controller.familyData[0]['participant_id']}"),
                _buildDetailRow("husband_or_father_name".tr, "${controller.familyData[0]['father_name']}"),
                _buildDetailRow("age".tr, "${controller.familyData[0]['participant_age']}"),
            Obx(() =>_buildDetailRow("village".tr, controller.villageNameLgd.value.isNotEmpty ? controller.villageNameLgd.value : "Not Available",),),
            Obx(() =>_buildDetailRow("panchayat".tr, controller.panchayatNameLgd.value.isNotEmpty ? controller.panchayatNameLgd.value : "Not Available",),),
                _buildDetailRow("phone_no".tr, "${controller.familyData[0]['mobile_no']}"),
                _buildDetailRow("add_level_of_education".tr, "${controller.familyData[0]['level_of_education']}"),
                _buildDetailRow("marital_status".tr, "${controller.familyData[0]['marital_status']}"),
                _buildDetailRow("sign_literacy".tr, "${controller.familyData[0]['signature_literate']}"),
                _buildDetailRow("total_fmly_mem".tr, "${controller.familyData[0]['total_family_members']}"),
                _buildDetailRow("Adults".tr, "${controller.familyData[0]['number_adults_member']}"),
                _buildDetailRow("Children".tr, "${controller.familyData[0]['number_children_member']}"),
                _buildDetailRow("visit_day".tr, "${controller.familyData[0]['hh_visit_day']}"),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? "-",
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
}
