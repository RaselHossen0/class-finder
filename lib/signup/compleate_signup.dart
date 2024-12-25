import 'dart:convert';

import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';

import 'dart:io';

import '../every class/user.dart';





completeSignup(User us) async {
  Dio dio = Dio();

  // Ensure latLang is in the correct GeoJSON format
  try {
    if (us.latLang == null || us.latLang.length != 2) {
      throw Exception('Invalid latLang: must contain exactly two values [latitude, longitude].');
    }

    // Reverse the order for GeoJSON format [longitude, latitude]
    List<double> geoJsonCoordinates = [us.latLang[1], us.latLang[0]];
    String geoJsonString = jsonEncode(geoJsonCoordinates);

    // Prepare FormData
    FormData formData = FormData.fromMap({
      'className': us.className,
      'alternateMobileNumber': us.alternateMobileNumber,
      'aadhaarCardNumber': us.adharCardNum,
      'panCardFile': await MultipartFile.fromFile(us.panCardFile!, filename: 'Pan Card'),
      'price': '0',
      'mobileNumber': us.mobileNumber,
      'location': us.locationName,
      'panCardNumber': us.panCardNum,
      'photographFile': await MultipartFile.fromFile(us.photo!, filename: 'Photo'),
      'categoryId': us.category,
      'aadhaarCardFile': await MultipartFile.fromFile(us.aadharCardFile!, filename: 'Aadhar Card'),
      'coordinates': geoJsonString, // Pass GeoJSON string as the coordinates
      'email': us.email,
      'description': us.description,
      'rating': '0',
    });

    // Debugging information
    print("Prepared GeoJSON Coordinates: $geoJsonString");
    print("Sending formData: ${formData.fields}");

    // Perform the POST request
    Response response = await dio.post(
      '$rootApi/auth/class-owner/complete-signup',
      data: formData,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    // Handle response
    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');
    return response;
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}







fetchCategories() async {
  // Create an instance of Dio
  Dio dio = Dio();

  // URL for the GET request
  String url = '$rootApi/categories';

  // Headers
  dio.options.headers = {
    'accept': 'application/json',  // Set the 'accept' header to application/json
  };

  try {
    // Send GET request
    Response response = await dio.get(url);

    // Handle the response
    if (response.statusCode == 200) {
      return response;
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {

    print('Error: $e');
  }
}

//kkkkk
