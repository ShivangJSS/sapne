import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:trikal_up/Login/resetController.dart';
import 'package:trikal_up/Login/updateprofile.dart';

final Resetcontroller _resetController = Get.put(Resetcontroller());

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBEE0E1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Icon(
                Icons.lock_reset_rounded,
                size: 100,
                // color: Color(0xFF5e50a1),
                color: Color(0xFF5e50a1),
              ),
              const SizedBox(height: 10),
              const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),
              // Email / Phone Input
              TextField(
                controller: _resetController.passController,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.vpn_key_outlined, color: Color(0xFF5e50a1)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5e50a1), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // New Password
              TextField(
                controller: _resetController.newController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
                  prefixIcon: const Icon(Icons.fiber_new, color: Color(0xFF5e50a1)), // lock color
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5e50a1), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              TextField(
                controller: _resetController.cpassController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: const Icon(Icons.check, color: Color(0xFF5e50a1)), // icon color set
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300), // halka border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF5e50a1), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Reset Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    bool result = await InternetConnectionChecker().hasConnection;
                    if(result) {
                      await _resetController.changePassword(context);
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please check your internet connection and try again"),
                          backgroundColor: Colors.red, // optional: error highlight
                          duration: Duration(seconds: 3),
                        ),
                      );                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: const Text(
          "Version: 1.0.0",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
