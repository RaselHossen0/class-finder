import 'package:class_rasel/Global.dart';
import 'package:dio/dio.dart';

fetchChatHistoryData(int userId) async {
  final dio = Dio();

  try {
    final response = await dio.get(
      '$rootApi/chats/user/$userId',
      options: Options(
        headers: {
          'accept': 'application/json',
        },
      ),
    );

    print(response.data);
    return response;
  } catch (e) {
    print('Error: $e'); // Handle errors
  }
}
