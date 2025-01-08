import 'package:class_rasel/screen/change_otp_service.dart';
import 'package:class_rasel/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../every class/get_controller.dart';


class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  final _emailController = TextEditingController();
  bool isLoading = false;
  final cont sendOtt= Get.find();

  Future<void> sendOtp(String email) async {
    setState(() {
      isLoading = true;
    });

    EasyLoading.show(status: 'Sending OTP...');
    try {
      if (email.isEmpty) {
        EasyLoading.showError('Please enter your email');
        return;
      }

      // Simulate an API call for sending OTP
      await Future.delayed(Duration(seconds: 2)); // Replace with your API call
      EasyLoading.showSuccess('OTP sent successfully to $email');
      Get.toNamed('/VerifyOtp'); // Navigate to OTP verification page
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Bar
                      Text(
                        "Send OTP",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Input
                      Text(
                        'Email',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Instructions
                      Text(
                        "Enter your email address. We will send an OTP to verify your email.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Send OTP Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null // Disable button if loading
                      : () async {
                    setState(() {
                      isLoading = true;
                    });

                    EasyLoading.show(status: 'Logging in...'); // Show loading

                    try {
                      
                      var result = await sendOtpAlu(_emailController.text);
                      if(result["error"]==0){
                        sendOtt.otp=result["otp"];
                        Get.to(()=>ChangePasswordPage());
                      }



                    } catch (e) {
                      // Handle network or API errors
                      print("Error: $e");

                      EasyLoading.showError('An error occurred. Please try again.');
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                      EasyLoading.dismiss(); // Hide loading after response
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 15, 98, 233),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Next',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }
}
