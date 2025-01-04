import 'package:class_rasel/screen/enge/video_data.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends StatefulWidget {
  final VideoData video;

  const VideoCard({super.key, required this.video});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

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
      );

      setState(() {}); // Update UI after initializing
    } catch (error) {
      // Handle initialization errors here
      debugPrint("Error initializing video player: $error");
    }
  }

  @override
  void dispose() {
    // Dispose of controllers to free up resources
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 250, 196, 61),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.video.caption,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            _videoPlayerController.value.isInitialized
                ? Container(
              height: 450, // Set a fixed height
              width: screenWidth * 0.8, // Ensure the width is constrained
              child: Chewie(controller: _chewieController),
            )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
