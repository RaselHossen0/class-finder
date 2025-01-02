import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final joinEventProvider =
    StateNotifierProvider<JoinEventNotifier, AsyncValue<bool>>((ref) {
  return JoinEventNotifier();
});

class JoinEventNotifier extends StateNotifier<AsyncValue<bool>> {
  JoinEventNotifier() : super(AsyncValue.data(false));

  Future<void> joinEvent(int eventId, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    EasyLoading.show(status: 'Joining Event...');
    final token = prefs.getString('token')!;
    final url =
        'https://classroom-api.raselhossen.tech/events/join/$eventId/$userId';
    final headers = {
      'accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers);
      print(response.body);
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        state = AsyncValue.data(responseBody['isJoined']);
      } else if (response.statusCode == 404) {
        state = AsyncValue.error('Event or User not found', StackTrace.current);
      } else if (response.statusCode == 400) {
        state = AsyncValue.error('Joined', StackTrace.current);
      } else {
        state = AsyncValue.error('Failed to join event', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    } finally {
      EasyLoading.dismiss();
      print(state.whenData((data) => data));
    }
  }
}
