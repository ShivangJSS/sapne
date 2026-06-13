import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trikal_up/Common/DatabaseHelper.dart';
import 'package:trikal_up/Controllers/profile_controller.dart';
import 'package:trikal_up/Login/updateprofile.dart';
import 'package:trikal_up/Modals/clf_master.dart';
import 'package:trikal_up/Modals/updateCoachProfile.dart';
import '../../Common/Api.dart';
import '../../Common/BrandColors.dart';
import '../../Common/SharedPreferHelper.dart';
import '../HomeScreen/HomeScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController profile = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    profile.getDataProfile();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


    @override
    Widget build(BuildContext context) {
      return WillPopScope(
          onWillPop:()async {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
            return false;
          },
          child: Scaffold(
            backgroundColor: BrandColors.appbackgroundColor,
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: BrandColors.applightColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 40, bottom: 30, left: 16, right: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'profile'.tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22
                              ),
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async{

                              if (profile.coachId.isEmpty) {
                                profile.coachId.value = await SharedPreferHelper.getPrefString("userId");
                              }

                              // Save coach_id to shared prefs
                              await SharedPreferHelper.setPrefString('coach_id', profile.coachId.value);
                              print('coach_id ${profile.coachId}');
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Updateprofile()),
                              );
                              await profile.getDataProfile();
                              // Check if user returned a value
                            },
                            icon: const Icon(Icons.edit, size: 20, color: Colors.black87),
                            label: Text(
                              "profile_edit".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.16,
                            height: MediaQuery.of(context).size.width * 0.16,
                            child: Obx(() {
                              double size = MediaQuery.of(context).size.width * 0.16;

                              // 1️⃣ Local file check
                              if (profile.coachImage.isNotEmpty &&
                                  profile.coachImage != null &&
                                  profile.coachImage!.isNotEmpty) {
                                String localPath = profile.coachImage!.replaceAll('"', '');
                                File file = File(localPath);
                                if (file.existsSync()) {
                                  print("✅ Local image exists: $localPath");
                                  return ClipOval(
                                    child: Image.file(
                                      file,
                                      fit: BoxFit.cover,
                                      width: size,
                                      height: size,
                                    ),
                                  );
                                }
                              }

                              // 2️⃣ Network image fallback
                              if (profile.coachImage.value.isNotEmpty) {
                                return ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: "${Api.BaseUrl}${Api.imageCoach}${profile.coachImage.value}",
                                    fit: BoxFit.cover,
                                    width: size,
                                    height: size,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                );
                              }

                              // 3️⃣ Default icon
                              return const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 60,
                              );
                            }),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Obx(() {
                              // Show fullname from controller
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                profile.fullname.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                //  Profile Details Card
                Expanded(
                  child: Obx(() {
                    if (profile.data1.isEmpty) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildProfileTile(
                            Icons.phone,
                            "phone_no".tr,
                            "${profile.phone.value}",
                            Colors.red,
                          ),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: profile.data1.length,
                        itemBuilder: (context, index) {
                          final formData = profile.data1[index];
                          String formattedJoiningDate = '';
                          if (formData.joining_date != null && formData.joining_date!.isNotEmpty) {
                            try {
                              final parsedDate = DateFormat('yyyy-MM-dd').parse(formData.joining_date!);
                              formattedJoiningDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                            } catch (e) {
                              formattedJoiningDate = formData.joining_date!;
                            }
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 4,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: BrandColors.appColor, width: 1),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    _buildInfoText("p_CLF".tr, profile.getClfName(formData.clf_id)),
                                    _buildInfoText("p_guardian".tr, formData.name_of_husband_father ?? ''),
                                    _buildInfoText("p_age".tr, formData.coach_dob ?? ''),
                                    _buildInfoText("p_gender".tr, formData.gender ?? ''),
                                    _buildInfoText("p_contact".tr, formData.mobile_no ?? ''),
                                    _buildInfoText("p_joining".tr, formattedJoiningDate),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
                )


              ],
            ),
          ));
    }
  }
  // }


Widget _buildInfoText(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // width: 130,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        Expanded(
          child: Text(
            value?.isNotEmpty == true ? value! : 'Not Available',
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


  Widget _buildProfileTile(IconData icon, String label, String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

