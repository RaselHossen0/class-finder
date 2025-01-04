import 'dart:io';
import 'package:dio/dio.dart';
import 'package:class_rasel/Global.dart';

Future<Response?> createEvent(
    String title,
    String date,
    String description,
    int classId,
    String location,
    List<File> files,
    String token,
    ) async {
  final dio = Dio();

  print("              in        sskaw          ");

  try {
    // Preparing files for multipart data

    print("              in        sskaw          ");
    List<MultipartFile> fileParts = [];
    for (var file in files) {
      fileParts.add(
        await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
      );
    }

    // Constructing FormData
    FormData formData = FormData.fromMap({
      'title': title,
      'date': date,
      'description': description,
      'classId': classId,
      'location': location,
      'files': fileParts, // Add files as a list of MultipartFile
    });

    print("FormData: ${formData.fields}");
    print("Files: ${formData.files}");

    // Sending POST request
    final response = await dio.post(
      '$rootApi/events',
      data: formData,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    print('Response data: ${response.data}');
    return response;
  } catch (e) {
    print('Error during file upload: $e');
    return null;
  }
}
