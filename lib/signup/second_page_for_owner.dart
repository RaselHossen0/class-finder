import 'dart:io';

import 'package:class_rasel/componants/app_bar.dart';
import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SecondPageForOwner extends StatefulWidget {
  const SecondPageForOwner({super.key});

  @override
  State<SecondPageForOwner> createState() => _SecondPageForOwnerState();
}

class _SecondPageForOwnerState extends State<SecondPageForOwner> {
  final _mobileNum = TextEditingController();
  final _alternetMobile = TextEditingController();
  final _adharCardNum = TextEditingController();
  final _panCardNum = TextEditingController();

  final _adarhFile = TextEditingController();
  final _panFile = TextEditingController();
  final photo = TextEditingController();
  bool isLoading = false;
  bool locationNodal = false;
  bool hhhh = false;
  String? _selectOption;
  List<dynamic> options = [];
  List<String> optionsName = [];
  File? adharFile;
  File? panFile;
  File? photoFile;
  LatLng markerLocation = LatLng(23.8041, 90.4152);
  int changeId = 0;
  Map<String, int> aluu = Map();

  bool kajShesh = true;
  final cont signup = Get.find();
  @override
  @override
  void initState() {
    super.initState();
  }

// Create an async helper function

  @override
  Widget build(BuildContext context) {
    if (kajShesh) {
      return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                appBar(title: 'Compleate Sign Up'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Mobile Number*', style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: _mobileNum,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Alternet Mobile Number',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: _alternetMobile,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Adhar Card Number', style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: _adharCardNum,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Upload Adar Card', style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: _adarhFile,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () =>
                          _pickFile(_adarhFile), // Corrected to _adarhFile
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Pan Card Number', style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: _panCardNum,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Upload Pan Card', style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: _panFile,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () =>
                          _pickFile(_panFile), // Corrected to _adarhFile
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Upload Photo', style: TextStyle(fontSize: 14)),
                  ],
                ),
                TextFormField(
                  controller: photo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () =>
                          _pickFile(photo), // Corrected to _adarhFile
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null // Disable button if loading
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            EasyLoading.show(
                                status: 'Logging in...'); // Show loading

                            try {
                              signup.user.mobileNumber = _mobileNum.text;
                              signup.user.alternateMobileNumber =
                                  _alternetMobile.text;
                              signup.user.adharCardNum = _adharCardNum.text;
                              signup.user.aadharCardFile = _adarhFile.text;
                              signup.user.panCardNum = _panCardNum.text;
                              signup.user.panCardFile = _panFile.text;
                              signup.user.photo = photo.text;

                              Get.toNamed("/thirdSignUp");
                            } catch (e) {
                              // Handle network or API errors
                              print("Error: $e");

                              EasyLoading.showError(
                                  'An error occurred. Please try again.');
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                              EasyLoading
                                  .dismiss(); // Hide loading after response
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
                            'Sign Up as Class Owner',
                            style: TextStyle(fontSize: 16.0),
                          ),
                  ),
                ),
              ],
            ),
          ),
        )),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

void _pickFile(TextEditingController controller) async {
  // Open file picker dialog
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    // If a file is selected, get the file path
    String? filePath = result.files.single.path;

    // Update the TextFormField with the file path
    controller.text = filePath ?? 'No file selected';
  } else {
    // If no file is selected, set the text as empty or show an error
    controller.text = 'No file selected';
  }
}
