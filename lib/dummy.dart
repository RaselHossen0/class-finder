completeSignup(User us) async {
  Dio dio = Dio();

  // Replace with your file paths


  // Prepare FormData
  FormData formData = FormData.fromMap({
    'className': us.className,
    'alternateMobileNumber': us.alternateMobileNumber,
    'aadhaarCardNumber': us.adharCardNum,
    'panCardFile': await MultipartFile.fromFile(us.panCardFile, filename: 'Pan Card'),
    'price': '0',
    'mobileNumber': us.mobileNumber,
    'location': us.locationName,
    'panCardNumber': us.panCardNum,
    //'certificatesFile': await MultipartFile.fromFile(certificatesFilePath, filename: 'Cv_1 (1).pdf'),
    'photographFile': await MultipartFile.fromFile(us.photo, filename: 'Photo'),
    'categoryId': us.category,
    'aadhaarCardFile': await MultipartFile.fromFile(us.aadharCardFile, filename: 'Cv_1 (1).pdf'),
    'coordinates': us.latLang,
    'email': us.email,
    'description': us.description,
    'rating': '0',
  });

  try {
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
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}
