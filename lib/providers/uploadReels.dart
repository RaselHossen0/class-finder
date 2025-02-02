import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

final uploadReelProvider =
    StateNotifierProvider<UploadReelNotifier, AsyncValue<void>>((ref) {
  return UploadReelNotifier();
});

class UploadReelNotifier extends StateNotifier<AsyncValue<void>> {
  UploadReelNotifier() : super(const AsyncData(null));

  Future<void> uploadReel({
    required String filePath,
    required String title,
    required String description,
    required String tags,
    required String type,
  }) async {
    try {
      cont userState = Get.find();
      final token = userState.token;
      final classId = userState.classId;
      state = const AsyncLoading();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://classroom-api.raselhossen.tech/media/upload/$classId'),
      )
        ..fields['title'] = title
        ..fields['description'] = description
        ..fields['tags'] = tags
        ..fields['type'] = type
        ..fields['isCoverImage'] = 'false'
        ..files.add(await http.MultipartFile.fromPath('mediaFile', filePath));

      final response = await request.send();
      if (response.statusCode == 201) {
        state = const AsyncData(null);
      } else {
        throw Exception('Failed to upload reel');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
