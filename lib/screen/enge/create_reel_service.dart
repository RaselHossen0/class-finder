
import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart'; // Import http_parser for MediaType

uploadMedia(String tk, int id, String title, String description,String file) async {
  final dio = Dio();

  String idd = id.toString();
  String url = '$rootApi/media/upload/$idd';

  // File to upload

  print("                          99                  ");


  try {
    FormData formData = FormData.fromMap({
      'mediaFile': await MultipartFile.fromFile(
        file,
        //filename: 'istockphoto-2147709540-640_adpp_is.mp4',
        contentType: MediaType('video', 'mp4'), // Use MediaType from http_parser
      ),
      'title': title,
      'description': description,
      'isCoverImage': false,
      'tags': 'string',
      'type': 'reel',
    });

    final response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': tk,
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Upload successful: ${response.data}');
      return response;
    } else {
      print('Failed to upload media. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading media: $e');
  }
}
