import 'dart:io';
import 'package:dio/dio.dart';
import 'package:class_rasel/Global.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Response?> createOrUpdateEvent(
    String title,
    String date,
    String description,
    int classId,
    String location, // Human-readable location (optional)
    LatLng coordinates, // Coordinates as LatLng
    List<File> files,
    String token,
    {bool isUpdate = false,
    int? eventId}) async {
  final dio = Dio();

  try {
    // Prepare the files for multipart data
    List<MultipartFile> fileParts = [];
    for (var file in files) {
      fileParts.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
        ),
      );
    }

    // Format the coordinates as a string
    String formattedCoordinates =
        "${coordinates.latitude},${coordinates.longitude}";

    // Construct FormData
    FormData formData = FormData.fromMap({
      'title': title,
      'date': date,
      'description': description,
      'classId': classId,
      'location': location,
      'coordinates': formattedCoordinates, // Send as a string
      'files': fileParts, // Add files as a list of MultipartFile
    });

    // Determine URL and method based on isUpdate
    final url = isUpdate && eventId != null
        ? '$rootApi/events/$eventId'
        : '$rootApi/events';
    final method = isUpdate ? dio.put : dio.post;

    // Send request
    final response = await method(
      url,
      data: formData,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    print('Response: $response');

    return response;
  } catch (e) {
    print('Error during file upload: $e');
    return null;
  }
}
