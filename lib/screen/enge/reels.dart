import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:class_rasel/screen/enge/reels_service.dart';
import 'package:class_rasel/screen/enge/video_card.dart';
import 'package:class_rasel/screen/enge/video_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Global.dart';

class Reels extends StatefulWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  late List<dynamic> videoUrls = [];
  final List<VideoData> videoDataList = [];
  final List<Widget> videoCards = [];
  final cont reels = Get.find();

  @override
  void initState() {
    super.initState();
    _initializeReels();
  }

  Future<void> _initializeReels() async {
    EasyLoading.show(status: 'Loading...');
    try {
      await _getVideo();
      _initializeVideos();
    } catch (e) {
      print("Error in initializing reels: $e");
      EasyLoading.showError("Failed to load reels");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _getVideo() async {
    try {
      var result = await fetchClassDetails(reels.token, reels.classId!);
      videoUrls = result.data["Media"] ?? [];
    } catch (e) {
      print("Error in fetching video URLs: $e");
    }
  }

  void _initializeVideos() {
    for (int i = 0; i < videoUrls.length; i++) {
      final videoData = VideoData(
        url: videoUrls[i]["url"],
        caption: videoUrls[i]["title"],
        videoId: videoUrls[i]["id"],
        des: videoUrls[i]["description"],
        date: videoUrls[i]["upload_date"],
      );

      videoDataList.add(videoData);
      videoCards.add(VideoCard(video: videoData));
    }

    setState(() {}); // Trigger UI update
  }

  @override
  void dispose() {
    // Clear video lists to free memory
    videoDataList.clear();
    videoCards.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        "Create Reels",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed("/CreateReels");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        add,
                        width: 20,
                        height: 20,
                        semanticsLabel: 'Add Reel',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Video List or Loader
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: videoUrls.isEmpty
                  ? const Center(
                child: Text(
                  "No videos found.",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : Column(children: videoCards),
            ),
          ],
        ),
      ),
    );
  }
}
