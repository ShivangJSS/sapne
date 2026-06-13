import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:trikal_up/Common/BrandColors.dart';
import 'package:upgrader/upgrader.dart';
import 'login_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

final _loginController = Get.find<LoginController>();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool _isObscure = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String latitude = "0.00";
  String longitude = "0.00",version="";

  Future<bool> _checkInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  void initState() {
    super.initState();
    _checkAndGetLocation();
    getData();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();

  }
  Future<void> getData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
     version = packageInfo.version;
    print("App version: ${packageInfo.version}+${packageInfo.buildNumber}");
     setState(() {

     });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360; // extra chhoti screen detect
    print("Screen width: ${size.width}");
    print("Screen height: ${size.height}");

    return
     Scaffold(
      backgroundColor: BrandColors.appbackgroundColor,
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            // TOP LOGOS + BACKGROUND
            // Stack(
            //   children: [
            //     ClipPath(
            //       clipper: WaveClipper(),
            //       child: Container(
            //         height: size.height * 0.44, // responsive height
            //         width: double.infinity,
            //         decoration: const BoxDecoration(
            //           gradient: LinearGradient(
            //             colors: [Colors.white, Colors.white],
            //             begin: Alignment.topLeft,
            //             end: Alignment.bottomRight,
            //           ),
            //         ),
            //         child: Opacity(
            //           opacity: 0.80,
            //           child: Image.asset(
            //             "assets/loginbg.png",
            //             fit: BoxFit.fill,
            //             alignment: Alignment.topCenter,
            //           ),
            //         ),
            //       ),
            //     ),
            //     // Positioned(
            //     //   // top: size.height * 0.020,
            //     //   top: 0,
            //     //   left: 0,
            //     //   right: 0,
            //     //   child: Column(
            //     //     crossAxisAlignment: CrossAxisAlignment.start, // text aligned to start
            //     //     children: [
            //     //       // Row for the two images
            //     //       Row(
            //     //         mainAxisAlignment: MainAxisAlignment.center, // keep both images centered
            //     //         children: [
            //     //
            //     //
            //     //
            //     //             Image.asset(
            //     //             "assets/logo1removebg.png",
            //     //             height: size.height * 0.13,
            //     //             width: size.width * 0.40,
            //     //             fit: BoxFit.contain,
            //     //           ),
            //     //           SizedBox(width: size.width * 0.05),
            //     //
            //     //           Transform.rotate(
            //     //             angle: -1.57, // radians (positive = clockwise)
            //     //             child: Image.asset(
            //     //               "assets/image.png",
            //     //               height: size.height * 0.13,
            //     //               width: size.width * 0.40,
            //     //               fit: BoxFit.contain,
            //     //             ),
            //     //           ),
            //     //           // Image.asset(
            //     //           //   "assets/logo_ministry.png",
            //     //           //   height: size.height * 0.13,
            //     //           //   width: size.width * 0.40,
            //     //           //   fit: BoxFit.contain,
            //     //           // ),
            //     //         ],
            //     //       ),
            //     //
            //     //       // Text just below the images and aligned to start
            //     Row(
            //       children: [
            //         Flexible(
            //           child: Padding(
            //             padding: EdgeInsets.only(
            //               left: size.width * 0.050,
            //               top: size.height * 0.005,
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   "home_header".tr,
            //                   maxLines: 2,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: GoogleFonts.montserrat(
            //                     fontSize: size.width < 360
            //                         ? size.width * 0.05        // Chhoti screen (Galaxy A series, etc.)
            //                         : size.width < 400
            //                         ? size.width * 0.10    // Medium screen (most phones)
            //                         : size.width * 0.11,
            //                     fontWeight: FontWeight.bold,
            //                     color: Color(0xFF1E9092),
            //                   ),
            //                 ),
            //                 Text(
            //                   "home_subheader".tr,
            //                   maxLines: 2,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: GoogleFonts.montserrat(
            //                     fontSize: size.width < 360
            //                         ? size.width * 0.045        // Chhoti screen (Galaxy A series, etc.)
            //                         : size.width < 400
            //                         ? size.width * 0.055    // Medium screen (most phones)
            //                         : size.width * 0.055,
            //                     fontWeight: FontWeight.w400,
            //                     color: Color(0xFF1E9092),
            //                   ),
            //                 ),Text(
            //                   "home_subheader1".tr,
            //                   maxLines: 2,
            //                   overflow: TextOverflow.ellipsis,
            //                   style: GoogleFonts.montserrat(
            //                     fontSize: size.width < 360
            //                         ? size.width * 0.045        // Chhoti screen (Galaxy A series, etc.)
            //                         : size.width < 400
            //                         ? size.width * 0.055    // Medium screen (most phones)
            //                         : size.width * 0.055,
            //                     fontWeight: FontWeight.w400,
            //                     color: Color(0xFF1E9092),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //     //
            //     //     ],
            //     //   ),
            //     // )
            //
            //   ],
            // ),
            Stack(
              children: [
                // Background image with wave
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: size.height * 0.44,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.80,
                      child: Image.asset(
                        "assets/loginbg.png",
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                // ✅ Sirf yeh Row → Positioned mein badlo
                Positioned(
                  top: size.height * 0.02,
                  left: size.width * 0.05,
                  right: size.width * 0.05, // ✅ right half image ke liye chhodo
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "home_header".tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: size.width < 360
                              ? size.width * 0.045   // chhota phone — ek line mein aayega
                              : size.width * 0.085,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E9092),
                        ),
                      ),
                      Text(
                        "home_subheader".tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: size.width < 360
                              ? size.width * 0.020   // chhota phone — ek line mein aayega
                              : size.width * 0.048,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1E9092),
                        ),
                      ),
                      Text(
                        "home_subheader1".tr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: size.width < 360
                              ? size.width * 0.020   // chhota phone — ek line mein aayega
                              : size.width * 0.048,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1E9092),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // LOGIN CARD
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                child: Container(
                  padding: EdgeInsets.all(size.width * 0.06),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _loginController.formKey,
                    child: Builder(builder: (context) {
                      final baseTextStyle = GoogleFonts.poppins(
                        color: Colors.black87,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'login_to_continue'.tr,
                            style: baseTextStyle.copyWith(
                              fontSize: isSmall ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),

                          // USERNAME FIELD
                          TextFormField(
                            controller: _loginController.usernameController,
                            style: baseTextStyle.copyWith(
                              fontSize: isSmall ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: _inputDecoration(
                              hint: 'user_name'.tr,
                              icon: Icons.person_outline,
                            ),
                            validator: (value) =>
                            value!.isEmpty ? 'please_enter_user_name'.tr : null,
                          ),
                          SizedBox(height: size.height * 0.02),

                          // PASSWORD FIELD
                          TextFormField(
                            controller: _loginController.passwordController,
                            style: baseTextStyle.copyWith(
                              fontSize: isSmall ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                            obscureText: _isObscure,
                            decoration: _inputDecoration(
                              hint: 'password'.tr,
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[500],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "please_enter_your_password".tr;
                              }
                              // if (value.length < 6) {
                              //   return "please_enter_your_password_characters".tr;
                              // }
                              // return null;
                            },
                          ),
                          SizedBox(height: size.height * 0.015),

                          // LOCATION + FORGOT PASSWORD
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: BrandColors.appColor, size: 18),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      "$latitude, $longitude",
                                      style: baseTextStyle.copyWith(
                                        fontSize: isSmall ? 11 : 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: GestureDetector(
                              //     onTap: () {},
                              //     child: Text(
                              //       "Forgot Password?",
                              //       style: baseTextStyle.copyWith(
                              //         fontSize: isSmall ? 12 : 13,
                              //         color: const Color(0xFF1E9092),
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                          SizedBox(height: size.height * 0.003),

                          // LOGIN BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: size.height * 0.065,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () async {
                                if (_loginController.formKey.currentState!.validate()) {
                                  bool hasInternet = await _checkInternet();
                                  if (!hasInternet) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Please check your internet connection!",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  } else {
                                    _loginController.getLogin(context);
                                  }
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF1E9092), Color(0xFF4DD0E1)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    'login_button_text'.tr,
                                    style: baseTextStyle.copyWith(
                                      fontSize: isSmall ? 14 : 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.015),

                          // BOTTOM LOGOS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/logo4.png", height: size.height * 0.045),
                              SizedBox(width: size.width * 0.1),
                              Image.asset("assets/logo3.png", height: size.height * 0.045),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.015),

// VERSION
        Builder(builder: (context) {
              final baseTextStyle = GoogleFonts.poppins(
                color: Colors.black87,
              );
              return Text(
                "${"version_text".tr}: $version",
                style: baseTextStyle.copyWith(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey,
                ),
              );
            }),

          ],
        ),)
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF1E9092)),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 14),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffix,
    );
  }


  Future<void> _checkAndGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showGpsDialog(context);
    } else {
      await _fetchAndSetLocation();
      // Continuously get the location updates
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1, // Update location after moving 10 meters
        ),
      ).listen((Position position) {
        if (!mounted) return;
        setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
        });
        print("latitude: $latitude, longitude: $longitude");
      });
    }
  }
  Future<void> _fetchAndSetLocation() async {
    try {
      Position position = await _getGeoLocation(context);
      if (!mounted) return;
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
      print("latitude: $latitude, longitude: $longitude");
    } catch (e) {
      print("Error fetching location: $e");
    }
  }
  Future<void> _showGpsDialog(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.orangeAccent),
              SizedBox(width: 10),
              Text(
                "GPS Required",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: const Text(
            "Please enable GPS to use this feature.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Geolocator.openLocationSettings();
                    bool gpsEnabled = await _checkLocationService();
                    while (!gpsEnabled) {
                      await Future.delayed(const Duration(seconds: 1));
                      gpsEnabled = await _checkLocationService();
                    }
                    await _fetchAndSetLocation();
                  },
                  child: const Text(
                    "Open Settings",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  Future<bool> _checkLocationService() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  Future<Position> _getGeoLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return Future.error('Failed to get the current location: $e');
    }
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Left top se shuru
    path.lineTo(0, size.height - 30);

    // Left → Center curve
    var firstControlPoint = Offset(size.width / 4, size.height - 80);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);

    // Center → Right curve
    var secondControlPoint = Offset(size.width * 3 / 4, size.height);
    var secondEndPoint = Offset(size.width, size.height - 60);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    // Right top tak sidha line
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}