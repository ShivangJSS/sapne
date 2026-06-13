import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trikal_up/Common/DatabaseHelper.dart';
import 'package:trikal_up/Login/resetpass.dart';
import 'package:trikal_up/Login/updateprofile.dart';
import 'package:trikal_up/Modals/AspirationModel.dart';
import 'package:trikal_up/Modals/FeedBackModel.dart';
import 'package:trikal_up/Modals/asp_option.dart';
import 'package:trikal_up/Modals/block_master.dart';
import 'package:trikal_up/Modals/challenge_cat_master.dart';
import 'package:trikal_up/Modals/challenge_subcat_master.dart';
import 'package:trikal_up/Modals/clf_master.dart';
import 'package:trikal_up/Modals/district_master.dart';
import 'package:trikal_up/Modals/updateCoachProfile.dart';
import 'package:trikal_up/Modals/wayfor_cat_master.dart';
import 'package:trikal_up/Modals/wayfor_subcat_master.dart';
import '../Common/Api.dart';
import 'package:flutter/material.dart';
import '../Common/SharedPreferHelper.dart';
import '../Dashboard/HomeScreen/HomeScreen.dart';
import '../Modals/LanguageModel.dart';
import '../Modals/QuestionModel.dart';
import '../Modals/category_list.dart';
import '../Modals/panchayet_list.dart';
import '../Modals/participant.dart';
import '../Modals/add_remark.dart';
import '../Modals/stateMaster.dart';
import '../Modals/sub_category_list.dart';
import '../Modals/village_list.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart' as dio;

class LoginController extends GetxController{
  bool isFirstLogin = true;
  bool passwordVisible = false;
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    getAndSaveDeviceInfo();
    getAppVersion();
  }

  Future<void> getLogin(BuildContext context) async {
    SmartDialog.showLoading(
      msg: "please_wait_text".tr,
      backDismiss: false,
      clickMaskDismiss: false,
    );


    try {
      final String enteredUsername = usernameController.text.trim();
      final String enteredPassword = passwordController.text.trim();
      dio.Response response  = await Dio().post(
        "${Api.BaseUrl}${Api.login_url}",
        options: Options(headers: {"Content-Type": "application/json"}),
        data: {
          "username": enteredUsername,
          "password": enteredPassword,
        },
      );

      Map<String, dynamic> resData = response.data;
      if (response.statusCode == 200) {
        if (resData['status'].toString() == "true") {
          var userData = resData['data'];
          await participantMaster(userData['c_id']?? "");
          await aspCategoryMaster();
          await subCategoryMaster();
          await downloadCoach(userData['c_id']?? "");
          await panchayatMaster(userData['c_id']?? "");
          await villageMaster(userData['c_id']?? "");
          await downloadQuestion();
          await downloadBlock();
          await downloadDistrict();
          await aspOptionMaster();
          await downloadAspiration(userData['c_id']?? "");
          await downloadFeedback(userData['c_id']?? "");
          await downloadRemark(userData['c_id']?? "");
          await downloadChallengeCategory();
          await downloadChallengeSubCategory();
          await downloadWayforCategory();
          await downloadWayforSubCategory();
          await downloadclfMaster();
          await downloadStateMaster(userData['c_id']?? "");

          // Save required user data
          await SharedPreferHelper.setPrefString("coach_image", userData['coach_image']??"");
          await SharedPreferHelper.setPrefString("full_name", userData['coach_name']??"");
          await SharedPreferHelper.setPrefString("username", userData['user_name']?? "");
          await SharedPreferHelper.setPrefString("mobile_no", userData['mobile_no']?? "");
          await SharedPreferHelper.setPrefString("userId", userData['c_id']?? "");
          await SharedPreferHelper.setPrefString("state_lgd_code", userData['state_lgd_code']?? "");
          await SharedPreferHelper.setPrefString("district_lgd_code", userData['district_lgd_code']?? "");
          await SharedPreferHelper.setPrefString("block_lgd_code", userData['block_lgd_code']?? "");
          await SharedPreferHelper.setPrefString("project_name", userData['project_name']?? "");
          await SharedPreferHelper.setPrefString("gp_lgd_code", userData['gp_lgd_code']?? "");
          await SharedPreferHelper.setPrefString("is_resetUpdate", userData['is_reset']?? "");

          print('userDatais_reset ${userData['is_reset']}');
          print('c_id ${userData['c_id']}');
          await SmartDialog.dismiss();
          await SharedPreferHelper.setPrefString("isLogin","Yes");
          if(userData['is_reset'] == '0') {
            await SharedPreferHelper.setPrefString("isReset", "No");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData['message']}"), backgroundColor: Colors.green,),);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Resetpass(),),);
          }
          else  if(userData['is_reset'] == '1') {
            await SharedPreferHelper.setPrefString("isReset", "Yes");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData['message']}"), backgroundColor: Colors.green,),);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Updateprofile(),),);
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData['message']}"), backgroundColor: Colors.green,),);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),),);
          }
        } else if(resData['status'].toString() == "false"){
          await SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${resData['message']}"), backgroundColor: Colors.redAccent,),);
        }else{
          await SmartDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong!'), backgroundColor: Colors.redAccent,),);
        }
      }

    } catch (e) {
      await SmartDialog.dismiss();
      SmartDialog.showToast('An error occurred. Please try again.');
      print('Login error: $e');
    }
   
  }
  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;       // App name
    String packageName = packageInfo.packageName; // Package name (com.example.app)
    String version = packageInfo.version;       // e.g. 1.0.0
    String buildNumber = packageInfo.buildNumber; // e.g. 1
    await SharedPreferHelper.setPrefString("appVersion", version ?? "");
  }
  Future<void> getAndSaveDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

      // ✅ Values set in SharedPreferences
      await SharedPreferHelper.setPrefString("device_name", androidInfo.model ?? "");
      await SharedPreferHelper.setPrefString("manufacturer", androidInfo.manufacturer ?? "");
      await SharedPreferHelper.setPrefString("os_version", androidInfo.version.release ?? "");

    }
    else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

      // ✅ Values set in SharedPreferences
      await SharedPreferHelper.setPrefString("device_name", iosInfo.utsname.machine ?? "");
      await SharedPreferHelper.setPrefString("manufacturer", "Apple");
      await SharedPreferHelper.setPrefString("os_version", iosInfo.systemVersion ?? "");
    }
  }
  Future<void> participantMaster(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.participant_list,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Table clear karo
          await DatabaseHelper.instance.truncateTable("participant");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                Participant family = Participant.fromMap(item);
                batch.insert(Participant.tableName, family.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table participant: $e");
    }
  }

  Future<void> aspCategoryMaster() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.category_list);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Table clear karo
          await DatabaseHelper.instance.truncateTable("category_list");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                CategoryList catg = CategoryList.fromMap(item);
                batch.insert(CategoryList.tableName, catg.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table category_list: $e");
    }
  }

  Future<void> subCategoryMaster() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.sub_category_list);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Table clear karo
          await DatabaseHelper.instance.truncateTable("sub_category_list");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                SubCategoryList sabcatg = SubCategoryList.fromMap(item);
                batch.insert(SubCategoryList.tableName, sabcatg.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table sub_category_list: $e");
    }
  }


  // Future<void> downloadCoach() async {
  //   try {
  //     var response = await Dio().get(Api.BaseUrl + Api.GetCoachProfile);
  //
  //     if (response.statusCode == 200) {
  //       final responseData =
  //       response.data is String ? jsonDecode(response.data) : response.data;
  //
  //       if (responseData['status'] == "success") {
  //         List<dynamic> datalist = responseData['data'];
  //         print("data is $datalist");
  //
  //         // Table clear karo
  //         await DatabaseHelper.instance.truncateTable("coach_profile");
  //
  //         if (datalist.isNotEmpty) {
  //           Database db = await DatabaseHelper.instance.database;
  //
  //           // Batch insert
  //           await db.transaction((txn) async {
  //             var batch = txn.batch();
  //             for (var item in datalist) {
  //               UpdateCoachProfile sabcatg = UpdateCoachProfile.fromMap(item);
  //               batch.insert(UpdateCoachProfile.tableName, sabcatg.toMap());
  //             }
  //             await batch.commit(noResult: true); // ⚡ Fast insert
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error downloading table sub_category_list: $e");
  //   }
  // }
  Future<void> downloadCoach(String cId) async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.GetCoachProfile);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Clear table
          await DatabaseHelper.instance.truncateTable("coach_profile");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            String? passbookImage; // store only for this c_id

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();

              for (var item in datalist) {
                UpdateCoachProfile coach = UpdateCoachProfile.fromMap(item);
                batch.insert(UpdateCoachProfile.tableName, coach.toMap());

                if (coach.c_id.toString() == cId &&
                    coach.passbook_image != null &&
                    coach.passbook_image!.isNotEmpty) {
                  passbookImage = coach.passbook_image;
                }
              }

              await batch.commit(noResult: true);
            });

            if (passbookImage != null && passbookImage!.isNotEmpty) {
              await SharedPreferHelper.setPrefString(
                  "passbook_image", passbookImage!);
              debugPrint("Stored passbook image for c_id: $cId → $passbookImage");
            } else {
              debugPrint("No passbook image found for c_id $cId");
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table coach_profile: $e");
    }
  }


  Future<void> panchayatMaster(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.panch_list,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Table clear karo
          await DatabaseHelper.instance.truncateTable("panchayat_list");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                PanchayatList panch = PanchayatList.fromMap(item);
                batch.insert(PanchayatList.tableName, panch.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table panchayat_list: $e");
    }
  }

  Future<void> villageMaster(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.vill_list,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Table clear karo
          await DatabaseHelper.instance.truncateTable("village_list");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                VillageList village = VillageList.fromMap(item);
                batch.insert(VillageList.tableName, village.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table village_list: $e");
    }
  }

  Future<void> downloadAspiration(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.getAspiration,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> dataList = responseData['data'];

          // Table clear karo
          await DatabaseHelper.instance.truncateTable("aspiration");

          if (dataList.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in dataList) {
                AspirationModel aspirationModel = AspirationModel.fromMap(item);
                batch.insert(AspirationModel.tableName, aspirationModel.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table aspiration: $e");
    }
  }

  Future<void> downloadFeedback(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.downloadFeedback,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> dataList = responseData['data'];

          // Table clear karo
          await DatabaseHelper.instance.truncateTable(FeedBackModel.tableName);

          if (dataList.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in dataList) {
                FeedBackModel feedBackModel = FeedBackModel.fromMap(item);
                batch.insert(FeedBackModel.tableName, feedBackModel.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table feedback_list: $e");
    }
  }

  Future<void> downloadRemark(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.downloadRemark,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> dataList = responseData['data'];

          // Table clear karo
          await DatabaseHelper.instance.truncateTable(AddRmk.tableName);

          if (dataList.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in dataList) {
                AddRmk rmkModel = AddRmk.fromMap(item);
                batch.insert(AddRmk.tableName, rmkModel.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table remark: $e");
    }
  }

  Future<void> downloadQuestion() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadQuestion);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("Question data is $datalist");

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("question_list");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                QuestionModel question = QuestionModel.fromMap(item);
                batch.insert(
                  QuestionModel.tableName,
                  question.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });

            print("Questions saved in DB successfully.");
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading question_list: $e");
    }
  }

  Future<void> downloadDistrict() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.GetDistrict);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("district_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                DistrictMaster question = DistrictMaster.fromMap(item);
                batch.insert(
                  DistrictMaster.tableName,
                  question.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });

            print("Questions saved in DB successfully.");
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading question_list: $e");
    }
  }

  Future<void> downloadBlock() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.GetBlock);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("block_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                BlockMaster question = BlockMaster.fromMap(item);
                batch.insert(
                  BlockMaster.tableName,
                  question.toMap(),
                  conflictAlgorithm: ConflictAlgorithm.replace,
                );
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });

            print("Questions saved in DB successfully.");
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading question_list: $e");
    }
  }

  Future<void> aspOptionMaster() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadAspOption);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];
          print("data is $datalist");

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("asp_option");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                AspOption aspoptn = AspOption.fromMap(item);
                batch.insert(AspOption.tableName, aspoptn.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table asp_option: $e");
    }
  }

  Future<void> downloadChallengeCategory() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadChallengeCategory);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("challenge_cat_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                ChallengeCatMaster chcatmas = ChallengeCatMaster.fromMap(item);
                batch.insert(ChallengeCatMaster.tableName, chcatmas.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table challenge_cat_master: $e");
    }
  }

  Future<void> downloadChallengeSubCategory() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadChallengeSubCategory);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("challenge_sub_cat_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                ChallengeSubcatMaster chsubcatmas = ChallengeSubcatMaster.fromMap(item);
                batch.insert(ChallengeSubcatMaster.tableName, chsubcatmas.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table challenge_sub_cat_master: $e");
    }
  }

  Future<void> downloadWayforCategory() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadWayforCategory);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("wayfor_cat_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                WayforCatMaster wycatmas = WayforCatMaster.fromMap(item);
                batch.insert(WayforCatMaster.tableName, wycatmas.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table wayfor_cat_master: $e");
    }
  }

  Future<void> downloadWayforSubCategory() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadWayforSubCategory);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("wayfor_sub_cat_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                WayforSubcatMaster wysubcatmas = WayforSubcatMaster.fromMap(item);
                batch.insert(WayforSubcatMaster.tableName, wysubcatmas.toMap());
              }
              await batch.commit(noResult: true); // ⚡ Fast insert
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table wayfor_sub_cat_master: $e");
    }
  }

  Future<void> downloadclfMaster() async {
    try {
      var response = await Dio().get(Api.BaseUrl + Api.downloadclfMaster);

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        if (responseData['status'] == "success") {
          List<dynamic> datalist = responseData['data'];

          // Purana data clear karo
          await DatabaseHelper.instance.truncateTable("clf_master");

          if (datalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            // Batch insert
            await db.transaction((txn) async {
              var batch = txn.batch();
              for (var item in datalist) {
                ClfMaster clfmass = ClfMaster.fromMap(item);
                batch.insert(ClfMaster.tableName, clfmass.toMap());
              }
              await batch.commit(noResult: true);
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table clf_master: $e");
    }
  }

  // Future<void> downloadStateMaster(String coachId) async {
  //   try {
  //     var response = await Dio().post(Api.BaseUrl + Api.downloadStateMaster,data: {"coach_id": coachId});
  //
  //     if (response.statusCode == 200) {
  //       final responseData =
  //       response.data is String ? jsonDecode(response.data) : response.data;
  //
  //       if (responseData['status'] == "success") {
  //         List<dynamic> statedatalist = responseData['data'];
  //
  //         // Purana data clear karo
  //         await DatabaseHelper.instance.truncateTable("state_master");
  //
  //         if (statedatalist.isNotEmpty) {
  //           Database db = await DatabaseHelper.instance.database;
  //           // Batch insert
  //           await db.transaction((txn) async {
  //             var batch = txn.batch();
  //             for (var item in statedatalist) {
  //               Statemaster statemass = Statemaster.fromMap(item);
  //               batch.insert(Statemaster.tableName, statemass.toMap());
  //             }
  //             await batch.commit(noResult: true);
  //           });
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Error downloading table state_master: $e");
  //   }
  // }
  Future<void> downloadStateMaster(String coachId) async {
    try {
      var response = await Dio().post(
        Api.BaseUrl + Api.downloadStateMaster,
        data: {"coach_id": coachId},
      );

      if (response.statusCode == 200) {
        final responseData =
        response.data is String ? jsonDecode(response.data) : response.data;

        print("API Response: $responseData");

        if (responseData['status'] == "success") {
          List<dynamic> statedatalist = responseData['data'];

          // 🔹 Purana data delete
          await DatabaseHelper.instance.truncateTable("state_master");

          if (statedatalist.isNotEmpty) {
            Database db = await DatabaseHelper.instance.database;

            await db.transaction((txn) async {
              var batch = txn.batch();

              for (var item in statedatalist) {
                // 🔹 Har item ka lang_id print karo
                print("Lang ID from API item: ${item['lang_id']}");

                Statemaster statemass = Statemaster.fromMap(item);
                batch.insert(Statemaster.tableName, statemass.toMap());
              }

              await batch.commit(noResult: true);
            });

            // 🔹 Sab lang_id ek list me
            List<String> langIds = statedatalist
                .map((item) => item['lang_id'].toString())
                .toList();

            print("All Lang IDs: $langIds");

            String langIdsString = langIds.join(",");

            await SharedPreferHelper.setPrefString("lang_id", langIdsString);

            print("Saved Language IDs: $langIdsString");

          }
        }
      }
    } catch (e) {
      debugPrint("Error downloading table state_master: $e");
    }
  }
}