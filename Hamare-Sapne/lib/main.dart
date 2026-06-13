import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trikal_up/Common/SharedPreferHelper.dart';
import 'package:trikal_up/Controllers/profile_controller.dart';
import 'package:trikal_up/Dashboard/HomeScreen/HomeScreen.dart';
import 'package:trikal_up/Login/resetpass.dart';
import 'Common/Api.dart';
import 'Common/AppLanguages.dart';
import 'Common/AppTranslations.dart';
import 'Common/DatabaseHelper.dart';
import 'Common/LanguageSelectionScreen.dart';
import 'Controllers/aspiration_controller.dart';
import 'Controllers/family_controller.dart';
import 'Controllers/home_controller.dart';
import 'Login/Login.dart';
import 'Login/login_controller.dart';
import 'Login/resetController.dart';
import 'Modals/LanguageModel.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String isLogin = await SharedPreferHelper.getPrefString("isLogin") ?? "";
  String isReset = await SharedPreferHelper.getPrefString("isReset") ?? "";
  String isUpdate = await SharedPreferHelper.getPrefString("isUpdate") ?? "";
  String? savedLang = await SharedPreferHelper.getPrefString("lang");
  String isLangDownloaded = await SharedPreferHelper.getPrefString("isLangDownloaded") ?? "";
  print('isReset $isReset');
  if (isLangDownloaded != "yes") {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      await downloadLanguageMaster();
      await SharedPreferHelper.setPrefString("isLangDownloaded", "yes");
    } else {
      runApp(NoInternetApp(
        onRetry: () async {
          bool retryResult = await InternetConnectionChecker().hasConnection;
          if (retryResult) {
            await downloadLanguageMaster();
            await SharedPreferHelper.setPrefString("isLangDownloaded", "yes");
            AppLanguages appLanguages = AppLanguages();
            await appLanguages.loadLanguages();
            // await checkForUpdate();
            runApp(MyApp(isLogin: isLogin, isReset: isReset, isUpdate: isUpdate ,savedLang: savedLang, appLanguages: appLanguages));
          }
        },
      ));
      return;
    }
  } else {
    debugPrint("Language master already downloaded, skipping download...");
  }


  AppLanguages appLanguages = AppLanguages();
  await appLanguages.loadLanguages();

  runApp(MyApp(
    isLogin: isLogin,
    isReset: isReset,
    isUpdate: isUpdate,
    savedLang: savedLang,
    appLanguages: appLanguages,
  ));




}



Future<void> downloadLanguageMaster() async {
  try {
    var response = await Dio().get(Api.BaseUrl + Api.downloadLanguage);

    if (response.statusCode == 200) {
      final responseData =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (responseData['status'] == "success") {
        List<dynamic> datalist = responseData['data'];

        // Purana data clear karo
        await DatabaseHelper.instance.truncateTable(LanguageModel.tableName);

        if (datalist.isNotEmpty) {
          Database db = await DatabaseHelper.instance.database;

          // Batch insert
          await db.transaction((txn) async {
            var batch = txn.batch();
            for (var item in datalist) {
              LanguageModel langModel = LanguageModel.fromMap(item);
              batch.insert(LanguageModel.tableName, langModel.toMap());
            }
            await batch.commit(noResult: true); // ⚡ Fast insert
          });
        }
      }
    }
  } catch (e) {
    debugPrint("Error downloading table language: $e");
  }
}

/// 🔹 No Internet Popup Screen

class NoInternetApp extends StatelessWidget {
  final Future<void> Function() onRetry;

  const NoInternetApp({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          Future.delayed(Duration.zero, () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Internet icon
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 70,
                        color: Color(0xFF1E9092),
                      ),
                      const SizedBox(height: 15),

                      // 🔹 Title
                      const Text(
                        "No Internet Connection",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),


                      const Text(
                        "Please connect to the internet to continue.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),


                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E9092),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            bool retryResult = await InternetConnectionChecker().hasConnection;
                            if(retryResult){
                            Navigator.of(context).pop();
                            await onRetry();
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please check your internet connection and try again"),
                                  backgroundColor: Colors.red, // optional: error highlight
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Retry",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),


                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            SystemNavigator.pop(); // recommended
                          },
                          child: const Text(
                            "Exit",
                            style: TextStyle(
                                fontSize: 16, color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E9092),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final String isLogin;
  final String isReset;
  final String isUpdate;
  final String? savedLang;
  final AppLanguages appLanguages;

  const MyApp({
    super.key,
    this.isLogin = "",
    this.isReset = "",
    this.isUpdate = "",
    this.savedLang,
    required this.appLanguages,
  });

  @override
  Widget build(BuildContext context) {
    Locale appLocale = const Locale('en', 'US');

    if (savedLang != null && savedLang!.isNotEmpty && appLanguages.languages.isNotEmpty) {
      final match = appLanguages.languages.firstWhere(
            (lang) => lang['code'] == savedLang,
        orElse: () => appLanguages.languages[0], // fallback English
      );
      appLocale = match['locale'] as Locale;
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hamare Sapne',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: FlutterSmartDialog.init(),
      translations: AppTranslations(),
      locale: appLocale, // Dynamic saved language
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: BindingsBuilder(() {
        Get.put(Resetcontroller());
        Get.put(LoginController());
        Get.put(familyController());
        Get.put(AspirationController());
        Get.put(HomeController());
        Get.put(ProfileController());
      }),

      home: isLogin == "Yes"
          ? (isReset == 'No'
          ? const Resetpass()
          // : (isReset == 'Yes'
          // ? const Updateprofile()
          : const HomeScreen())
          : (savedLang == null || savedLang!.isEmpty)
          ? const LanguageSelectionPage()
          : const Login(),
      // home: isLogin == "Yes"
      //
      //     ? const HomeScreen()
      //     : (savedLang == null || savedLang!.isEmpty)
      //     ? const LanguageSelectionPage()
      //     : const Login(),
    );
  }



}
