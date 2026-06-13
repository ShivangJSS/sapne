import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../Common/BrandColors.dart';
import '../../Controllers/family_controller.dart';
import '../Manage_Aspirations/feedback.dart';
import '../Manage_Aspirations/remark.dart';
import '../Manage_Family/family_list.dart';
import '../Manage_Family/panchayet_list.dart';
import 'HomeScreen.dart';
import 'dashboardscreen.dart';

class FilterParticipant extends StatefulWidget {
  const FilterParticipant({super.key});

  @override
  State<FilterParticipant> createState() => _FilterParticipantState();
}

class _FilterParticipantState extends State<FilterParticipant> {

  @override
  void initState() {
    super.initState();
    fmlylistcontroller.filteredList.assignAll(fmlylistcontroller.list_data);
    // fmlylistcontroller.getAllFamily();
  }
  String img = "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg";


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboardscreen()));
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboardscreen()));
                  },
                ),
                const Text(
                  'Participant List',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
                  child: Obx(()=>ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: fmlylistcontroller.filteredList.length,
                    itemBuilder: (context, index) {
                      final family = fmlylistcontroller.filteredList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          // border: Border.all(
                          //   color: BrandColors.apporangeColor, // Thin colored border
                          //   width: 1,
                          // ),
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
                                    backgroundColor: BrandColors.appColor
                                        .withOpacity(0.2),
                                    backgroundImage: img != null &&
                                        img!.isNotEmpty
                                        ? NetworkImage(img!)
                                        : null,
                                    child: img == null ||
                                        img!.isEmpty
                                        ? const Icon(Icons.person,
                                        color: BrandColors.appColor, size: 28)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "sdfgh",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  //  3-dot action menu
                                  PopupMenuButton<String>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    color: Colors.white,
                                    elevation: 8,
                                    splashRadius: 28,
                                    onSelected: (value) {
                                      switch (value) {
                                        case "feedback":
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) =>
                                                FeedbackPage(),),);
                                          break;
                                        case "remarks":
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => Remark(),),);
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(
                                        value: "view",
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(
                                                    0.15),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              // thoda zyada padding
                                              child: const Icon(Icons.visibility,
                                                  color: Colors.blue,
                                                  size: 24), // bada icon
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              "View Participant",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "feedback",
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(
                                                    0.15),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: const Icon(Icons.feedback,
                                                  color: Colors.green, size: 24),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              "Feedback",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: "remarks",
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.purple.withOpacity(
                                                    0.15),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: const Icon(Icons.note_add,
                                                  color: Colors.purple, size: 24),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              "Add Remarks",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    icon: const Icon(
                                        Icons.more_vert, color: Colors.black54,
                                        size: 32), // bigger toolbar icon
                                  )
                                ],
                              ),
                              const Divider(height: 20, thickness: 1),
                              _buildDetailRow("Participant Id", family.participant_id ?? ""),
                              _buildDetailRow("Name", "dfghj"),
                              _buildDetailRow("Contact",  "fghjk"),
                              _buildDetailRow("Date of Joining",  "fghrt"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ),
                ),
              ],
            );
          }
          ),
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
