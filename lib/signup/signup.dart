import 'package:class_rasel/componants/app_bar.dart';
import 'package:class_rasel/every%20class/user.dart';
import 'package:class_rasel/signup/signupService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../every class/get_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  final box = GetStorage();
  final cont signupCont = Get.find();

  bool isLoadingUser = false;
  bool isLoadingOwner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Push content and buttons apart
          children: [
            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    appBar(title: "Signup"),
                    const SizedBox(height: 16),

                    // First Name Input
                    Text('First Name', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _name,
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

                    // Email Input
                    Text('Email', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _email,
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

                    // Password Input
                    Text('Password', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pass,
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
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Buttons at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Signup as User Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoadingUser
                          ? null
                          : () async {
                              // Validation: Check if fields are empty

                              setState(() {
                                isLoadingUser = true;
                              });

                              EasyLoading.show(status: 'Signing up...');
                              try {
                                if (_name.text.isEmpty ||
                                    _email.text.isEmpty ||
                                    _pass.text.isEmpty) {
                                  EasyLoading.showError(
                                      'Please fill all fields');
                                  return; // Prevent signup if fields are empty
                                }
                                var result = await signupService(
                                    _name.text, _email.text, _pass.text);

                                if (result.statusCode == 200) {
                                  box.write('token', result.data["token"]);
                                  User us = User(
                                      name: _name.text,
                                      email: _email.text,
                                      role: "user",
                                      latLang: []);
                                  signupCont.user = us;

                                  EasyLoading.showSuccess(
                                      result.data["message"]);
                                  Get.offNamed('/Loader');
                                }
                              } catch (e) {
                                print("Error: $e");
                                EasyLoading.showError(
                                    'An error occurred. Please try again.');
                              } finally {
                                setState(() {
                                  isLoadingUser = false;
                                });
                                EasyLoading.dismiss();
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
                      child: isLoadingUser
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Signup as User',
                              style: TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Signup as Class Owner Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoadingOwner
                          ? null
                          : () async {
                              // Validation: Check if fields are empty
                              if (_name.text.isEmpty ||
                                  _email.text.isEmpty ||
                                  _pass.text.isEmpty) {
                                EasyLoading.showError('Please fill all fields');
                                return; // Prevent signup if fields are empty
                              }

                              setState(() {
                                isLoadingOwner = true;
                              });

                              EasyLoading.show(status: 'Signing up...');
                              try {
                                var result = await signupService(
                                    _name.text, _email.text, _pass.text);
                                if (result == null) {
                                  EasyLoading.showError(
                                      'An error occurred. Please try again.');
                                  return;
                                }

                                if (result.statusCode == 200) {
                                  box.write('token', result.data["token"]);
                                  User us = User(
                                      name: _name.text,
                                      email: _email.text,
                                      role: "class_owner",
                                      latLang: []);
                                  signupCont.user = us;

                                  EasyLoading.showSuccess(
                                      result.data["message"]);

                                  if (result.data["error"] == 0) {
                                    Get.toNamed('/SecondSignUp');
                                  }
                                }

                                EasyLoading.showSuccess(
                                    'Signed up as Class Owner');
                              } catch (e) {
                                print("Error: $e");
                                EasyLoading.showError(
                                    'An error occurred. Please try again.');
                              } finally {
                                setState(() {
                                  isLoadingOwner = false;
                                });
                                EasyLoading.dismiss();
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
                      child: isLoadingOwner
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Signup as Class Owner',
                              style: TextStyle(fontSize: 16.0),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
