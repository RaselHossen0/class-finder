import 'package:dio/dio.dart';

 fetchClassDetails(String tk, int id) async {
  final dio = Dio();

  try {
    String alu = id.toString();
    print("              33                  ");
    print(tk);
    print(id);
    final response = await dio.get(
      'https://classroom-api.raselhossen.tech/classes/$alu',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization':
          'Bearer $tk',
        },
      ),
    );

    // Print or handle the response
    print(response.data);

    return response;
  } catch (e) {
    // Handle any errors
    print("                 44              ");
    if (e is DioException) {
      print('Error: ${e.response?.statusCode}, ${e.response?.data}');
    } else {
      print('Unexpected error: $e');
    }
  }
}
