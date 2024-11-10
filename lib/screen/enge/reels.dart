import 'package:class_rasel/screen/enge/video_card.dart';
import 'package:class_rasel/screen/enge/video_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Global.dart';

class Reels extends StatefulWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  List<VideoData> vd = [];
  bool _isLoading = true;

  List<Widget> cad=[];

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  void initVideo() async {
    for (int i = 0; i < videoUrls.length; i++) {
      VideoData videoData = VideoData(
        url: videoUrls[i],
        caption: "Video ${i + 1}",
        videoId: "${i + 1}",
      );
      Widget all=VideoCard(video: videoData);
      vd.add(videoData);
      cad.add(all);
    }
    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [


        Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Create Reels",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                add,
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                  children: cad
                )
              ),

          ],
        ),
      ),
    );
  }
}
