import 'package:class_rasel/screen/enge/video_data.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

import '../../every class/get_controller.dart';

class VideoCard extends StatefulWidget {
  final VideoData video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isMuted = false;
  final cont vdCard = Get.find();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.video.url);

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        showControls: false, // Disable default controls
      );

      setState(() {}); // Update UI after initializing
    } catch (error) {
      debugPrint("Error initializing video player: $error");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  String _formatDate(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('d MMMM EEEE, HH:mm').format(dateTime);
  }

  void _toggleVolume() {
    setState(() {
      _isMuted = !_isMuted;
      _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.black,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  vdCard.vd = widget.video;
                  Get.toNamed('/ReelDt');

                },
              ),
            ],
          ),

          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: const Color.fromARGB(255, 250, 196, 61),
            //     width: 1.0,
            //   ),
            //   borderRadius: BorderRadius.circular(12.0),
            // ),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _togglePlayPause, // Pause/play on video tap
                  child: _videoPlayerController.value.isInitialized
                      ? Container(
                    height: 450,
                    width: screenWidth * 0.8,
                    child: Chewie(controller: _chewieController),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: _toggleVolume, // Toggle volume on button press
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _formatDate(widget.video.date),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 8.0,
                  right: 8.0,
                  child: Text(
                    widget.video.caption,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //       icon: const Icon(Icons.edit, color: Colors.white),
          //       onPressed: () {
          //         // Handle edit action here
          //         debugPrint("Edit button pressed");
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}