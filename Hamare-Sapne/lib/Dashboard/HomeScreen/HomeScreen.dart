import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trikal_up/Common/Api.dart';
import 'package:trikal_up/Common/DatabaseHelper.dart';
import '../../Common/AppLanguages.dart';
import '../../Common/BrandColors.dart';
import '../../Common/SharedPreferHelper.dart';
import '../../Controllers/home_controller.dart';
import '../Manage_Family/panchayet_list.dart';
import '../Profile/profile.dart';
import 'dashboardscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find<HomeController>();
  String projectName="",stateCode="",languageId="", logo ="",projectImage="";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> cards = [
    {
      "label": "Pending Activities",
      "aspirationCount": 12,
      "feedbackCount": 5,
      "color": Colors.teal,
    },
    {
      "label": "BIHAAN",
      "aspirationCount": 8,
      "feedbackCount": 3,
      "color": Colors.pink,
    },
    {
      "label": "Another Card1",
      "aspirationCount": 8,
      "feedbackCount": 3,
      "color": Colors.purple,
    },
  ];

  List<String> savedLanguageIds = [];

  @override
  void initState() {
    super.initState();
    // checkForUpdateAndShowBanner(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    loadSavedLanguage();

    _startAutoScroll();
    getData();
    homeController.getDataHome();

  }

  Future<void> loadSavedLanguage() async {
    String ids =
        await SharedPreferHelper.getPrefString("lang_id") ?? "";

    savedLanguageIds = ids.split(",");

    print("Saved Language IDs: $savedLanguageIds");

    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    double cardWidth = 360.0;
    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset + cardWidth;

        if (currentScroll >= maxScroll) {
          // Last card ke baad direct start se scroll
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll,
            duration: const Duration(milliseconds: 500), // smooth scroll
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  Future<void> getData() async {
    String name = await SharedPreferHelper.getPrefString("full_name");
    stateCode = await SharedPreferHelper.getPrefString("state_lgd_code");
    // coachImage = await SharedPreferHelper.getPrefString("coach_image");
    languageId = await SharedPreferHelper.getPrefString("languageId");
   if(languageId.isNotEmpty) {
     try{
       projectName = (await DatabaseHelper.instance.getProjectName(stateCode, languageId))!;
       projectImage = (await DatabaseHelper.instance.getProjectImage(stateCode, languageId))!;
     }catch(e){
     }
   }
    // logo = (await DatabaseHelper.instance.getName(stateCode))!;
    setState(() {});

  }
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle the error, e.g., show a Snackbar or AlertDialog
      Get.snackbar('Error', 'Could not launch phone call');
    }
  }
  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height * 0.23;

    homeController.countSync();
    return UpgradeAlert(
        barrierDismissible: false,
        showLater: true,
        showIgnore: true,

        dialogStyle: Platform.isIOS
        ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,

        upgrader: Upgrader(
        debugLogging: true,

        languageCode: 'en',
    ),

    child:WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Colors.white,
        backgroundColor: BrandColors.appbackgroundColor,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1E9092),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CircleAvatar(
                        //   radius: 35,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.width * 0.18,
                          child: Obx(() {
                            double size = MediaQuery.of(context).size.width * 0.18;

                            // 1️⃣ Local file check
                            if (homeController.coachImage.isNotEmpty &&
                                homeController.coachImage != null &&
                                homeController.coachImage!.isNotEmpty) {
                              String localPath = homeController.coachImage!.replaceAll('"', '');
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
                            if (homeController.coachImage.value.isNotEmpty) {
                              return ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: "${Api.BaseUrl}${Api.imageCoach}${homeController.coachImage.value}",
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




                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    homeController.fullname.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
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
              ListTile(
                leading: Icon(Icons.account_circle, color: Color(0xFF1E9092)),
                title: Text('profile'.tr),
                onTap: () {
                  Get.to(() => Profile());
                  // Get.to(() => HumanOnlyCamera());
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF1E9092)),
                title: Text('language'.tr),
                onTap: () async {
                  String savedLangCode = await SharedPreferHelper.getPrefString("lang") ?? "en_US";
                  String selectedLangCode = savedLangCode;

                  Get.bottomSheet(
                    StatefulBuilder(
                      builder: (context, setState) {
                        AppLanguages appLanguages = AppLanguages();

                        return FutureBuilder(
                          future: appLanguages.loadLanguages(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (appLanguages.languages.isEmpty) {
                              return const Center(
                                  child: Text("No languages found"));
                            }

                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 🔹 Header Row
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "select_language".tr,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.grey),
                                          onPressed: () => Get.back(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Divider(color: Colors.grey[300]),

                                    // 🔹 Modern List
                                    // Flexible(
                                    //   child: ListView.separated(
                                    //     shrinkWrap: true,
                                    //     itemCount:
                                    //     appLanguages.languages.length,
                                    //     separatorBuilder: (_, __) =>
                                    //     const SizedBox(height: 12),
                                    //     itemBuilder: (context, index) {
                                    //       final lang =
                                    //       appLanguages.languages[index];
                                    //       final code = lang['code'] as String;
                                    //
                                    //       return AnimatedContainer(
                                    //         duration: const Duration(
                                    //             milliseconds: 300),
                                    //         curve: Curves.easeInOut,
                                    //         decoration: BoxDecoration(
                                    //           color: selectedLangCode == code
                                    //               ? const Color(0xFF1E9092)
                                    //               .withOpacity(0.1)
                                    //               : Colors.white,
                                    //           borderRadius:
                                    //           BorderRadius.circular(16),
                                    //           border: Border.all(
                                    //             color: selectedLangCode == code
                                    //                 ? const Color(0xFF1E9092)
                                    //                 : Colors.grey.shade300,
                                    //             width: 1.2,
                                    //           ),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.black
                                    //                   .withOpacity(0.05),
                                    //               blurRadius: 6,
                                    //               offset: const Offset(0, 3),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: RadioListTile<String>(
                                    //           value: code,
                                    //           groupValue: selectedLangCode,
                                    //           activeColor:
                                    //           const Color(0xFF1E9092),
                                    //           contentPadding:
                                    //           const EdgeInsets.symmetric(
                                    //             horizontal: 16,
                                    //             vertical: 4,
                                    //           ),
                                    //           title: Text(
                                    //             lang['name'] as String,
                                    //             style: TextStyle(
                                    //               fontSize: 16,
                                    //               fontWeight: FontWeight.w600,
                                    //               color: selectedLangCode ==
                                    //                   code
                                    //                   ? const Color(0xFF1E9092)
                                    //                   : Colors.black87,
                                    //             ),
                                    //           ),
                                    //           secondary: Icon(
                                    //             Icons.flag,
                                    //             color: selectedLangCode == code
                                    //                 ? const Color(0xFF1E9092)
                                    //                 : Colors.grey,
                                    //           ),
                                    //           onChanged: (value) {
                                    //             setState(() {
                                    //               selectedLangCode = value!;
                                    //             });
                                    //           },
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),

                                    Builder(
                                      builder: (context) {

                                        print("All Languages: ${appLanguages.languages}");
                                        final filteredLanguages = appLanguages.languages
                                            .where((lang) => savedLanguageIds.contains(lang['id'].toString()))
                                            .toList();
                                        return Flexible(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: filteredLanguages.length,
                                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                                            itemBuilder: (context, index) {

                                              final lang = filteredLanguages[index];
                                              final code = lang['code'] as String;

                                              print("Language Item: $lang");

                                              return AnimatedContainer(
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                decoration: BoxDecoration(
                                                  color: selectedLangCode == code
                                                      ? const Color(0xFF1E9092).withOpacity(0.1)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: selectedLangCode == code
                                                        ? const Color(0xFF1E9092)
                                                        : Colors.grey.shade300,
                                                    width: 1.2,
                                                  ),
                                                ),
                                                child: RadioListTile<String>(
                                                  value: code,
                                                  groupValue: selectedLangCode,
                                                  activeColor: const Color(0xFF1E9092),
                                                  title: Text(lang['name']),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedLangCode = value!;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            const Color(0xFF1E9092),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            elevation: 3,
                                          ),
                                          onPressed: () async {
                                            await SharedPreferHelper.setPrefString("lang", selectedLangCode);

                                            final selectedLang = appLanguages.languages.firstWhere((lang) => lang['code'] == selectedLangCode,
                                              orElse: () => {
                                                "id": "1",
                                                "code": "en_US",
                                                "locale": const Locale("en", "US"),
                                                "name": "English",
                                              },
                                            );

                                            await SharedPreferHelper
                                                .setPrefString(
                                              "languageId",
                                              selectedLang['id'].toString(),
                                            );


                                            Get.updateLocale(
                                                selectedLang['locale']
                                                as Locale);

                                            await getData();
                                            Get.back();
                                          },
                                          child: Text(
                                            "ok".tr,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    isScrollControlled: true,
                  );
                },
              ),
              InkWell(
                onTap: () => _makePhoneCall('9999999999'),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.call, color: Color(0xFF1E9092)),
                      const SizedBox(width: 12),
                      Text(
                        'helpline'.tr,

                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+91 9999999999',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),


              ListTile(
                leading:
                Icon(Icons.power_settings_new, color: Color(0xFF1E9092)),
                title: Text('logout_text'.tr),
                onTap: () {
                  if (homeController.syncCount.value > 0) {
                    homeController.syncPopup(context);
                  } else {
                    homeController.showLogoutPopup(context);
                  }
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF1E9092),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              Text(
                'home_header'.tr,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white, // sirf button ka background
                  shape: BoxShape.circle, // circular button
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    if (homeController.syncCount.value > 0) {
                      homeController.syncPopup(context);
                    } else {
                      homeController.showLogoutPopup(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // CircleAvatar(
                        //   radius: 35,
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.width * 0.18,
                          child: Obx(() {
                            double size = MediaQuery.of(context).size.width * 0.18;

                            // 1️⃣ Local file check
                            if (homeController.coachImage.isNotEmpty &&
                                homeController.coachImage != null &&
                                homeController.coachImage!.isNotEmpty) {
                              String localPath = homeController.coachImage!.replaceAll('"', '');
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

                            if (homeController.coachImage.value.isNotEmpty) {
                              return ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: "${Api.BaseUrl}${Api.imageCoach}${homeController.coachImage.value}",
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



                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() {

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // if (displayName.isNotEmpty)
                                  Text(
                            "${'home_title'.tr}, ${homeController.fullname.value}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
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
              const SizedBox(height: 25),

              SizedBox(

                height: MediaQuery.of(context).size.height * 0.20, // Card height
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    // Card 1
                    Container(
                      width: 344,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Logo with circular background
                          // Container(
                          //   width: 110,
                          //   height: 96,
                          //   padding: EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     shape: BoxShape.circle,
                          //   ),
                          //   child: Image.asset(
                          //     'assets/nrlm.png',
                          //     fit: BoxFit.contain,
                          //     errorBuilder: (context, error, stackTrace) {
                          //       return Icon(Icons.image_not_supported, color: Colors.white);
                          //     },
                          //   ),
                          // ),
                          // SizedBox(width: 16),
                          // Full Name
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "p_day".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ), Text(
                                  "h_national".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 344,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Logo with circular background
                          Container(
                            width: 110,
                            height: 96,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(
                              Api.BaseUrlImage+projectImage,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported, color: Colors.white);
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          // Full Name
                          Expanded(
                            child: Text(
                              projectName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Card 3
                    Container(
                      width: 344,
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.only(left: 26,right: 26,top: 6,bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // text के चारों ओर padding
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "आमची स्वप्ने",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal, // text color
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // text के चारों ओर padding
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "ನಮ್ಮ ಕನಸುಗಳು",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal, // text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          // Row 2
                          Padding(
                            padding: const EdgeInsets.only(left:88.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // text के चारों ओर padding
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "हमारे सपने",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal, // text color
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          // Row 3
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // text के चारों ओर padding
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "ನಮ್ಮ ಕನಸುಗಳು",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal, // text color
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // text के चारों ओर padding
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "మన కలలు",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal, // text color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'sub_title'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // First Row
                      Row(
                        children: [
                          Expanded(
                            child: homeController.buildMenuBox(
                              title: 'card_text1'.tr,
                              icon: Image.asset("assets/growth.png",
                                  width: 55, height: 55),
                              onTap: () {
                                Get.to(
                                      () => Dashboardscreen(),
                                  duration: const Duration(milliseconds: 500),
                                  transition: Transition.rightToLeft,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: homeController.buildMenuBox(
                              title: 'card_text2'.tr,
                              icon: Image.asset("assets/family4.png",
                                  width: 55, height: 55),
                              onTap: () {
                                Get.to(
                                      () => PanchayetList(),
                                  duration: const Duration(milliseconds: 500),
                                  transition: Transition.rightToLeft,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Second Row
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                                  () => homeController.buildMenuBox(
                                title: 'card_text3'.tr,
                                icon: Image.asset("assets/cycle.png",
                                    width: 55, height: 55),
                                count: homeController.syncCount.value,
                                onTap: () async {
                                  if (homeController.syncCount.value > 0) {
                                    homeController.syncPendingData(context);
                                  } else {
                                    SmartDialog.showToast("no_pending_data".tr);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: homeController.buildMenuBox(
                              title: 'card_text4'.tr,
                              icon: Image.asset("assets/exit.png",
                                  width: 55, height: 55),
                              onTap: () {
                                onWillPop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildInfoCardWithSections({
    required String label,
    required int aspirationCount,
    required int feedbackCount,
    required Color color,
  }) {
    return Container(
      width: 344, // existing width
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.only(left: 12,right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // shadow color
            spreadRadius: 2, // how much the shadow spreads
            blurRadius: 6, // softness of the shadow
            offset: Offset(0, 3), // position: x, y
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Two sections horizontally: Aspiration & Feedback
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Aspiration
              Column(
                children: [
                  Text(
                    "$aspirationCount",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Aspiration",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
              // Feedback
              Column(
                children: [
                  Text(
                    "$feedbackCount",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Feedback",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<bool> onWillPop(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('exit_text1'.tr,
                  style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('exit_text2'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('no'.tr),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SystemNavigator.pop(); // Exit the app
                    },
                    child: Text('yes'.tr),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ) ??
        false;
  }
}