import 'package:class_rasel/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  bool isLoading = false;

  Future<void> changePassword(String email, String password, String otp) async {
    setState(() {
      isLoading = true;
    });

    EasyLoading.show(status: 'Changing password...');
    try {
      if (email.isEmpty || password.isEmpty || otp.isEmpty) {
        EasyLoading.showError('All fields are required');
        return;
      }

      // API Endpoint
      String url = '$rootApi/auth/change-password';

      // Initialize Dio
      dio.Dio dioClient = dio.Dio();

      // Send POST request
      final dio.Response response = await dioClient.post(
        url,
        data: {
          "email": email,
          "password": password,
          "otp": otp,
        },
        options: dio.Options(
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      // Handle Response
      if (response.statusCode == 200 && response.data['error'] == 0) {
        EasyLoading.showSuccess(response.data['message']);
        Get.back(); // Navigate back to the previous page
      } else {
        EasyLoading.showError(response.data['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred. Please try again.');
      print("Error: $e");
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
                        "Change Password",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Input
                      Text(
                        'Email',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // OTP Input
                      Text(
                        'OTP',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _otpController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      Text(
                        'New Password',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Instructions
                      Text(
                        "Enter your email, the OTP sent to your email, and your new password.",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    await changePassword(
                      _emailController.text,
                      _passwordController.text,
                      _otpController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 15, 98, 233),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Change Password',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
