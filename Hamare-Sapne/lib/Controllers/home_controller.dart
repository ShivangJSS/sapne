import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart'hide FormData, MultipartFile;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:trikal_up/Dashboard/Manage_Aspirations/remark.dart';
import 'package:trikal_up/Modals/FeedBackModel.dart';

import '../Common/Api.dart';
import '../Common/BrandColors.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Login/Login.dart';
import '../Modals/AspirationModel.dart';
import '../Modals/add_remark.dart';
import '../Modals/clf_master.dart';
import '../Modals/participant.dart';
import '../Modals/updateCoachProfile.dart';

class HomeController extends GetxController{
  final Dio dio = Dio();
  var syncCount = 0.obs;
  int participantCount=0,aspirationCount=0,feedBackCount=0,participantUpdateCount=0, remarkCount =0;
  var fullname = ''.obs;
  var phone = ''.obs;
  var coachId = ''.obs;
  var coachImage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    countSync();
  }

  Future<void> countSync() async {
    final db = await DatabaseHelper.instance.database;

    // 1. Participant pending count
    final List<Map<String, dynamic>> participantResult = await db.query(
      Participant.tableName,
      where: "${Participant.columnStatus} = ?",
      whereArgs: ["0"],
    );
    int participantCount = participantResult.length;

    //  Update participant
    final List<Map<String, dynamic>> participantUpdResult = await db.query(Participant.tableName, where: "${Participant.columnStatus} = ?", whereArgs: ["2"],);
    participantUpdateCount = participantUpdResult.length;

    // 2. Aspiration pending count
    final List<Map<String, dynamic>> aspirationResult = await db.query(
      AspirationModel.tableName,
      where: "${AspirationModel.columnStatus} = ?",
      whereArgs: ["0"],
    );
    int aspirationCount = aspirationResult.length;

    // 3. Feedback pending count
    final List<Map<String, dynamic>> feedbackResult = await db.query(
      FeedBackModel.tableName,
      where: "${FeedBackModel.columnStatus} = ?",
      whereArgs: ["0"],
    );
    int feedbackCount = feedbackResult.length;


    final List<Map<String, dynamic>> remarkResult = await db.query(
      AddRmk.tableName,
      where: "${AddRmk.columnStatus} = ?",
      whereArgs: ["0"],
    );
    int remarkCount = remarkResult.length;

    // ✅ कुल pending count
    syncCount.value = participantCount + aspirationCount + feedbackCount+participantUpdateCount +remarkCount;

  }

  Future<void> syncPendingData(BuildContext context) async {
    SmartDialog.showLoading(backDismiss: false, clickMaskDismiss: false);

    bool result = await InternetConnectionChecker().hasConnection;
    if (!result) {
      SmartDialog.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your internet connection!"),
          backgroundColor: Colors.redAccent,
        ),
      );

    } else {
      final db = await DatabaseHelper.instance.database;
      //add participant
      final List<Map<String, dynamic>> participantResult = await db.query(
        Participant.tableName,
        where: "${Participant.columnStatus} = ?",
        whereArgs: ["0"],
      );
      participantCount = participantResult.length;

      //  Update participant
      final List<Map<String, dynamic>> participantUpdateResult = await db.query(
        Participant.tableName,
        where: "${Participant.columnStatus} = ?",
        whereArgs: ["2"],
      );
      participantUpdateCount = participantUpdateResult.length;


      // 2. Aspiration pending count
      final List<Map<String, dynamic>> aspirationResult = await db.query(
        AspirationModel.tableName,
        where: "${AspirationModel.columnStatus} = ?",
        whereArgs: ["0"],
      );

      aspirationCount = aspirationResult.length;
      // 3. Feedback pending count
      final List<Map<String, dynamic>> feedbackResult = await db.query(
        FeedBackModel.tableName,
        where: "${FeedBackModel.columnStatus} = ?",
        whereArgs: ["0"],
      );
      feedBackCount = feedbackResult.length;

      final List<Map<String, dynamic>> remarkResult = await db.query(
        AddRmk.tableName,
        where: "${AddRmk.columnStatus} = ?",
        whereArgs: ["0"],
      );
       remarkCount = remarkResult.length;

      if(participantUpdateResult.isNotEmpty){
        await syncUpdatedParticipants();
      }

      if(participantResult.isNotEmpty){
        await syncPendingParticipants();
      }else{

        if(aspirationResult.isNotEmpty) {
          await syncPendingAspiration();
        }else {
          if (feedbackResult.isNotEmpty) {
            await syncPendingFeedback();
          } else {
            if (remarkResult.isNotEmpty) {
              print('count is first ');
              await syncPendingRemark();
            } else {
              await countSync();
              SmartDialog.dismiss();
            }
          }
        }
      }

    }
  }

  Future<void> syncPendingParticipants() async {

    final db = await DatabaseHelper.instance.database;

    try {
      // 1. सारे status=0 participants निकालो
      final List<Map<String, dynamic>> result = await db.query(Participant.tableName, where: "${Participant.columnStatus} = ?", whereArgs: ["0"],);
      // status 2 ke sabhi data
      participantCount=result.length;

      if (result.isEmpty) {
        SmartDialog.dismiss();
        Get.snackbar("Info", "No pending participants to sync");
        return;
      }

      if(result.isNotEmpty) {
        List<Participant> pendingList = result.map((e) =>
            Participant.fromMap(e)).toList();
        for (var p in pendingList) {
          File? imageFile =
          (p.participant_photo != null && p.participant_photo!.isNotEmpty)
              ? File(p.participant_photo!)
              : null;

          // 🔹 Payload तैयार करो
          FormData formData = FormData.fromMap({
            ...p.toJson(),
            if (imageFile != null)
              'participant_photo': await MultipartFile.fromFile(
                imageFile.path,
                filename: imageFile.path
                    .split('/')
                    .last,
              ),
          });

          // 🔹 API call (Online add participant)
          var response = await dio.post(
            Api.BaseUrl + Api.add_participant,
            options: Options(headers: {"Content-Type": "application/json"}),
            data: formData,
          );

          if (response.statusCode == 200) {
            var resData = response.data;
            if (resData["status"] == "success") {
              // server से insert_id मिला तो update कर दो
              String lastId = resData["insert_id"].toString();
              //Aspiration
              await db.update(
                AspirationModel.tableName,
                {
                  AspirationModel.columnParticipantId: lastId,
                },
                where: "${AspirationModel.columnParticipantId} = ?",
                whereArgs: [p.p_id], // 👈 local_id से match करो
              );
              //Feedback
              await db.update(
                FeedBackModel.tableName,
                {
                  FeedBackModel.columnParticipantId: lastId,
                },
                where: "${FeedBackModel.columnParticipantId} = ?",
                whereArgs: [p.p_id], // 👈 local_id से match करो
              );

              p.p_id = resData["insert_id"].toString();

              // Local DB में status = 1 और p_id update
              await db.update(
                Participant.tableName,
                {
                  Participant.columnStatus: "1",
                  Participant.columnPId: p.p_id,
                  // 👈 यहाँ भी insert_id डाल दिया
                },
                where: "${Participant.columnLocalId} = ?",
                whereArgs: [p.local_id],
              );

              participantCount--;
              if (participantCount == 0) {
                if (aspirationCount != 0) {
                  syncPendingAspiration();
                } else {
                  if (feedBackCount != 0) {
                    await syncPendingFeedback();
                  } else {
                  if (remarkCount != 0) {
                    print('count is second ');
                    await syncPendingRemark();
                  } else {
                    await countSync(); // Count refresh
                    SmartDialog.dismiss();
                    Get.snackbar("Success", "Data synced successfully ✅");
                  }
                }
                  }
              }
            }
          }
        }
      }


    } catch (e) {
      SmartDialog.dismiss();
      Get.snackbar("Error", "Sync failed: $e");
    }
  }
  Future<void> syncUpdatedParticipants() async {

    final db = await DatabaseHelper.instance.database;

    try {
      // 1. सारे status=0 participants निकालो
      final List<Map<String, dynamic>> result = await db.query(Participant.tableName, where: "${Participant.columnStatus} = ?", whereArgs: ["2"],);
      // status 2 ke sabhi data
      participantUpdateCount=result.length;

      if (result.isEmpty) {
        SmartDialog.dismiss();
        Get.snackbar("Info", "No pending participants to sync");
        return;
      }

      if(result.isNotEmpty) {
        List<Participant> pendingList = result.map((e) =>
            Participant.fromMap(e)).toList();


        for (var p in pendingList) {

          File? imageFile;
          String? photoPath = p.participant_photo;
          if (photoPath != null && photoPath.isNotEmpty) {
            // ✅ अगर network URL नहीं है (मतलब local file path है)
            if (photoPath.contains('/data/user/0/') || photoPath.contains('/storage/emulated/0/')) {
              imageFile = File(photoPath);
            }
          }
// 🔹 Payload तैयार करो
          FormData formData = FormData.fromMap({
            ...p.toJson(),
          });

// ✅ अब image logic लगाओ
          if (imageFile != null) {
            // अगर local file है तो MultipartFile भेजो
            formData.files.add(
              MapEntry(
                'participant_photo',
                await MultipartFile.fromFile(
                  imageFile.path,
                  filename: imageFile.path.split('/').last,
                ),
              ),
            );
          } else if (photoPath != null && photoPath.isNotEmpty) {
            // अगर network URL या .png file है तो string value भेजो
            formData.fields.add(
              const MapEntry('participant_photo', ""),
            );
          }


          // 🔹 API call (Online add participant)
          var response = await dio.post(Api.BaseUrl + Api.update_participant + p.p_id.toString(), data: formData);
          if (response.statusCode == 200) {
            var resData = response.data;
            if (resData["status"] == "success") {
              await db.update(
                Participant.tableName,
                {
                  Participant.columnStatus: "1",
                },
                where: "${Participant.columnPId} = ?",
                whereArgs: [p.p_id.toString()],
              );

            } else {
              SmartDialog.dismiss();
            }
          } else {
            SmartDialog.dismiss();
          }
        }
      }


    } catch (e) {
      SmartDialog.dismiss();
      Get.snackbar("Error", "Sync failed: $e");
    }
  }

  Future<void> syncPendingAspiration() async {
    final db = await DatabaseHelper.instance.database;

    try {
      // 1️⃣ सारे status=0 aspiration निकालो
      final List<Map<String, dynamic>> result = await db.query(
        AspirationModel.tableName,
        where: "${AspirationModel.columnStatus} = ?",
        whereArgs: ["0"],
      );
      aspirationCount=result.length;
      if (result.isEmpty) {
        await countSync(); // Count refresh
        SmartDialog.dismiss();
        Get.snackbar("Success", "Data synced successfully ✅");
        print("No pending aspirations to sync");
        return;
      }

      List<AspirationModel> pendingList =
      result.map((e) => AspirationModel.fromMap(e)).toList();

      for (var asp in pendingList) {
        // 🔹 Payload तैयार करो
        Map<String, dynamic> payload = asp.toJson();

        // 🔹 API call (Online add aspiration)
        var response = await dio.post(
          Api.BaseUrl + Api.addAspiration,
          options: Options(headers: {"Content-Type": "application/json"}),
          data: payload,
        );

        if (response.statusCode == 200) {
          var resData = response.data;
          if (resData["status"] == "success") {
            // server से insert_id मिला तो update कर दो
            String lastId=resData["insert_id"].toString();
            // Feedback
            await db.update(
              FeedBackModel.tableName,
              {
                FeedBackModel.columnAspirationId: lastId,
              },
              where: "${FeedBackModel.columnAspirationId} = ?",
              whereArgs: [asp.asp_details_id], // 👈 local_id से match करो
            );
            asp.asp_details_id = resData["insert_id"].toString();

            // Local DB में status = 1 update
            await db.update(
              AspirationModel.tableName,
              {
                AspirationModel.columnStatus: "1",
                AspirationModel.columnAspDetailsId: asp.asp_details_id,
              },
              where: "${AspirationModel.columnLocalId} = ?",
              whereArgs: [asp.local_id],
            );
            aspirationCount--;
            if(aspirationCount==0){
              if(feedBackCount!=0){
                await syncPendingFeedback();
              }else {
                await countSync(); // Count refresh
                SmartDialog.dismiss();
                Get.snackbar("Success", "Data synced successfully ✅");
              }
            }
          }
        }
      }

    } catch (e) {
      print("Aspiration sync failed: $e");
    }
  }

  // Future<void> syncPendingFeedback() async {
  //   final db = await DatabaseHelper.instance.database;
  //
  //   // 1. Pending feedback निकालो
  //   final List<Map<String, dynamic>> result = await db.query(
  //     FeedBackModel.tableName,
  //     where: "${FeedBackModel.columnStatus} = ?",
  //     whereArgs: ["0"],
  //   );
  //   feedBackCount=result.length;
  //   if (result.isEmpty) {
  //     print("✅ No pending feedback to sync.");
  //     return;
  //   }
  //
  //   print("📤 Pending Feedback Count: ${result.length}");
  //   List<Map<String, dynamic>> questions = [];
  //   for (var row in result) {
  //
  //
  //
  //       questions.add({
  //         "question_id": row["question_id"],
  //         "option_id": row["option_id"],
  //       });
  //
  //     try {
  //       FeedBackModel fb = FeedBackModel.fromMap(row);
  //       // Map<String, dynamic> payload = fb.toJson();
  //       Map<String, dynamic> payload = {
  //         "coach_id": result.first["coach_id"],
  //         "participant_id": result.first["participant_id"],
  //         "asp_sub_cat_id": result.first["asp_sub_cat_id"],
  //         "asp_cat_id": result.first["asp_cat_id"],
  //         "aspiration_id": result.first["aspiration_id"],
  //         "month": result.first["month"],
  //         "latitude": result.first["latitude"],
  //         "longitude": result.first["longitude"],
  //         "mobile_version": result.first["mobile_version"],
  //         "device_name": result.first["device_name"],
  //         "app_version": result.first["app_version"],
  //         "questions": questions,
  //       };
  //       print("➡️ Sending Feedback Payload: $payload");
  //       var response = await dio.post(
  //         Api.BaseUrl + Api.addFeedback,
  //         options: Options(headers: {"Content-Type": "application/json"}),
  //         data: payload
  //       );
  //       print("Response => ${response.data}");
  //
  //       if (response.statusCode == 200) {
  //         var resData = response.data;
  //         print("statusCode => ${response.statusCode}");
  //         print("statusCode => ${resData["status"].toString()}");
  //
  //         if (resData["status"] == "success") {
  //           List<dynamic> insertedIds = resData["inserted_ids"] ?? [];
  //           print("insertedIds = ${resData["inserted_ids"]}");
  //           if(insertedIds.isNotEmpty){
  //             String newServerId = insertedIds.first.toString();
  //
  //             await db.update(
  //               FeedBackModel.tableName,
  //               {
  //                 FeedBackModel.columnFeedbackId: newServerId,
  //                 FeedBackModel.columnStatus: "1",
  //               },
  //               where: "${FeedBackModel.columnFeedbackId} = ?",
  //               whereArgs: [fb.feedbackId],
  //             );
  //
  //           // 🔹 1. Update local feedback table
  //           // await db.update(
  //           //   FeedBackModel.tableName,
  //           //   {
  //           //     FeedBackModel.columnFeedbackId: newFeedbackId,
  //           //     FeedBackModel.columnStatus: "1",
  //           //   },
  //           //   where: "${FeedBackModel.columnFeedbackId} = ?",
  //           //   whereArgs: [fb.feedbackId], // match local feedback id
  //           // );
  //
  //           // 🔹 2. Update local remarks linked with this feedback
  //           // await db.update(
  //           //   AddRmk.tableName,
  //           //   {
  //           //     AddRmk.columnFeedbackId: newFeedbackId,
  //           //   },
  //           //   where: "${AddRmk.columnFeedbackId} = ?",
  //           //   whereArgs: [fb.feedbackId], // match old local id
  //           // );
  //           await db.update(
  //             AddRmk.tableName,
  //             {
  //               AddRmk.columnFeedbackId: newServerId,
  //             },
  //             where: "${AddRmk.columnFeedbackId} = ?",
  //             whereArgs: [fb.feedbackId],
  //           );
  //
  //           fb.feedbackId = newServerId;
  //         }
  //           // 🔹 3. Update object for next iteration (if reused)
  //
  //
  //           feedBackCount--;
  //           if(feedBackCount==0){
  //             if(remarkCount!=0){
  //               print('count is third ');
  //               await syncPendingRemark();
  //             }
  //             await countSync(); // Count refresh
  //             SmartDialog.dismiss();
  //             Get.snackbar("Success", "Data synced successfully ✅");
  //           }
  //
  //         } else {
  //           SmartDialog.dismiss();
  //         }
  //       } else {
  //         SmartDialog.dismiss();
  //
  //       }
  //     } catch (e) {
  //       SmartDialog.dismiss();
  //     }
  //   }
  // }

  Future<void> syncPendingFeedback() async {
    final db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      FeedBackModel.tableName,
      where: "${FeedBackModel.columnStatus} = ?",
      whereArgs: ["0"],
      orderBy: "local_id ASC",
    );

    if (result.isEmpty) {
      print("✅ No pending feedback to sync.");
      return;
    }

    print("📤 Pending Feedback Count: ${result.length}");

    try {
      // questions array banao
      List<Map<String, dynamic>> questions = [];

      for (var row in result) {
        questions.add({
          "question_id": row["question_id"],
          "option_id": row["option_id"],
        });
      }

      // ek hi payload
      Map<String, dynamic> payload = {
        "coach_id": result.first["coach_id"],
        "participant_id": result.first["participant_id"],
        "asp_sub_cat_id": result.first["asp_sub_cat_id"],
        "asp_cat_id": result.first["asp_cat_id"],
        "aspiration_id": result.first["aspiration_id"],
        "month": result.first["month"],
        "latitude": result.first["latitude"],
        "longitude": result.first["longitude"],
        "mobile_version": result.first["mobile_version"],
        "device_name": result.first["device_name"],
        "app_version": result.first["app_version"],
        "questions": questions,
      };

      print("➡️ Sending Feedback Payload: $payload");

      var response = await dio.post(
        Api.BaseUrl + Api.addFeedback,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
        data: payload,
      );

      print("Response => ${response.data}");

      if (response.statusCode == 200) {
        var resData = response.data;

        if (resData["status"] == "success") {
          List<dynamic> insertedIds = [];

          if ((resData["inserted_ids"] ?? []).isNotEmpty) {
            insertedIds = resData["inserted_ids"];
          } else if ((resData["updated_ids"] ?? []).isNotEmpty) {
            insertedIds = resData["updated_ids"];
          }

          print("Server IDs => $insertedIds");

          // count match hona chahiye
          if (insertedIds.length == result.length) {
            for (int i = 0; i < result.length; i++) {
              String oldLocalFeedbackId =
              result[i]["feedback_id"].toString();

              String newServerId =
              insertedIds[i].toString();

              print(
                  "Updating LocalId: $oldLocalFeedbackId -> ServerId: $newServerId");

              // feedback table update
              await db.update(
                FeedBackModel.tableName,
                {
                  FeedBackModel.columnFeedbackId: newServerId,
                  FeedBackModel.columnStatus: "1",
                },
                where: "${FeedBackModel.columnFeedbackId} = ?",
                whereArgs: [oldLocalFeedbackId],
              );

              // remark table update
              await db.update(
                AddRmk.tableName,
                {
                  AddRmk.columnFeedbackId: newServerId,
                },
                where: "${AddRmk.columnFeedbackId} = ?",
                whereArgs: [oldLocalFeedbackId],
              );
            }
          } else {
            print(
                "⚠️ Count mismatch. Local=${result.length} Server=${insertedIds.length}");
          }

          await countSync();

          if (remarkCount != 0) {
            await syncPendingRemark();
          }

          SmartDialog.dismiss();
          Get.snackbar(
            "Success",
            "Data synced successfully ✅",
          );
        }
      }
    } catch (e) {
      SmartDialog.dismiss();
      print("❌ Sync Error: $e");
    }
  }

    Future<void> syncPendingRemark() async {
      final db = await DatabaseHelper.instance.database;

      // 1. Pending remark निकालो
      final List<Map<String, dynamic>> result = await db.query(
        AddRmk.tableName,
        where: "${AddRmk.columnStatus} = ?",
        whereArgs: ["0"],
      );
      remarkCount=result.length;
      if (result.isEmpty) {
        print("✅ No pending remark to sync.");
        return;
      }

      print("📤 Pending remark Count: ${result.length}");

      for (var row in result) {
        try {
          AddRmk remark = AddRmk.fromMap(row);
          Map<String, dynamic> payload = remark.toJson();

          print("➡️ Sending remark Payload: $payload");
          var response = await dio.post(
            Api.BaseUrl + Api.AddRemark,
            data:  remark.toJson(),
          );
    print('res $response');
          if (response.statusCode == 200) {
            final res = response.data;

            if (res["status"] == "success") {
              // ✅ Update feedback as synced
              await db.update(
                AddRmk.tableName,
                {
                  AddRmk.columnStatus: "1",
                },
                where: "${AddRmk.columnLocalId} = ?",
                whereArgs: [remark.local_id],
              );
              remarkCount--;
              if(remarkCount==0){
                await countSync(); // Count refresh
                SmartDialog.dismiss();
                Get.snackbar("Success", "Data synced successfully ✅");
              }

            } else {
              SmartDialog.dismiss();
            }
          } else {
            SmartDialog.dismiss();

          }
        } catch (e) {
          print('Error $e');
          SmartDialog.dismiss();
        }
      }
    }


    Widget buildMenuBox({required String title, required Widget icon, int? count, VoidCallback? onTap,}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              constraints: const BoxConstraints(
                minWidth: 150,
                maxWidth: 150,
                minHeight: 160,
                maxHeight: 160,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E5EC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-6, -6),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Color(0xFFA3B1C6),
                    offset: Offset(6, 6),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      icon,
                      if (count != null && count > 0)
                        Positioned(
                          right: -26,
                          top: -26,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBottomButton(String emoji, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 35), // emoji size
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Future<void> showLogoutPopup(BuildContext context) async {
    // Show actual logout dialog if no pending sync
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.power_settings_new, size: 40, color: Colors.red),
                SizedBox(height: 10),
                Text('logout_text'.tr,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(height: 8),
                Text('are_you_sure_you_want_to_logout'.tr,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    textAlign: TextAlign.center),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey[300],
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('cancel'.tr),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await SharedPreferHelper.setPrefString("isLogin", "");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                              (Route<dynamic> route) =>
                          false, // Remove all old routes
                        );
                      },
                      child:  Text('logout_text'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> syncPopup(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.info, size: 40, color: BrandColors.apporangeColor),
                SizedBox(height: 10),
                Text(
                  'sync_your_data_to_logout'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child:  Text('ok'.tr),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  var data1 = <UpdateCoachProfile>[].obs;
  List<ClfMaster> clfData =[];

  Future<void> getDataHome() async {
    String name = await SharedPreferHelper.getPrefString("full_name");
    String ph = await SharedPreferHelper.getPrefString("mobile_no");
    String id = await SharedPreferHelper.getPrefString("userId");
    String image = await SharedPreferHelper.getPrefString("coach_image");
    print('name $name');

    fullname.value = name;

    phone.value = ph;
    coachId.value = id;
    coachImage.value = image;
    print('fullname ${coachImage.value }');
    await initializeData();
    update(); // Notify UI
  }

  String getClfName(String? clfId) {
    if (clfId == null || clfId.isEmpty) return 'Not Available';

    final clf = clfData.firstWhere(
          (element) => element.clf_code == clfId,
      orElse: () => ClfMaster(clf_code: '', clf_name: 'Not Available'),
    );
    return clf.clf_name ?? 'Not Available';
  }

  Future<void> initializeData() async {
   String cId = await SharedPreferHelper.getPrefString("userId");
   print('CID is home$cId');
    String query = "Select * from coach_profile where c_id = $cId";
    String query1 = "Select * from clf_master";

    List<UpdateCoachProfile> data = await DatabaseHelper.instance.getList(query);
    List<ClfMaster> dataCLF = await DatabaseHelper.instance.getCLFList(query1);

    data1.assignAll(data);
    clfData.assignAll(dataCLF);

    update(); // Notify listeners
  }

}