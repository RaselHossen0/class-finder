import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';

 fetchEvents(String token) async {
  final dio = Dio();

  try {

    print("                              event                   ");
    // Set the base options for Dio
    dio.options.baseUrl = rootApi;
    dio.options.headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Perform the GET request
    final response = await dio.get('/events');

    // Handle the response
    print('Response data: ${response.data}');
    return response;
  } on DioError catch (e) {
    // Handle the error
    if (e.response != null) {
      print('Error response: ${e.response?.data}');
    } else {
      print('Error: ${e.message}');
    }
  }
}


fetchEventById(int id,String tk) async {
  // Create Dio instance
  final Dio dio = Dio();

  // The API endpoint
  String url = '$rootApi/events/$id';

  // The Bearer token
   String token = tk;

  try {
    // Make the GET request
    final Response response = await dio.get(
      url,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    // Print the response
    print('Response data: ${response.data}');
    return response;
  } catch (e) {
    if (e is DioError) {

      print('DioError: ${e.response?.data ?? e.message}');

    } else {
      // Handle other errors
      print('Error: $e');
    }
  }
}



updateEventById(String tk,int id, var dataIn) async {
  final Dio dio = Dio();

  String url = '$rootApi/events/$id';
  String token = tk;

  final Map<String, dynamic> data = dataIn;

  try {
    final Response response = await dio.put(
      url,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {

      print('Event updated successfully: ${response.data}');
      return response;
    } else {
      print('Failed to update event. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating event: $e');
  }
}
