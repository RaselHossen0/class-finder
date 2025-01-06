import 'dart:io';

import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:class_rasel/screen/enge/create_reel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CreateReels extends StatefulWidget {
  const CreateReels({super.key});

  @override
  State<CreateReels> createState() => _CreateReelsState();
}

class _CreateReelsState extends State<CreateReels> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedVideo;
  VideoPlayerController? _videoPlayerController;
  bool isLoading = false;
  final cont createRe = Get.find();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
        _videoPlayerController = VideoPlayerController.file(_selectedVideo!)
          ..initialize().then((_) {
            setState(() {}); // Refresh the UI
            _videoPlayerController!.play(); // Auto-play the video
          });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Reels'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Title', _titleController),
            SizedBox(height: 16),
            _buildTextField('Description', _descriptionController),
            SizedBox(height: 16),
            _buildVideoPicker(),
            if (_selectedVideo != null && _videoPlayerController != null)
              _buildVideoPlayer(),
            Spacer(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPicker() {
    return Row(
      children: [
        Text('Select Video', style: TextStyle(fontSize: 14)),
        Spacer(),
        ElevatedButton(
          onPressed: _pickVideo,
          child: Text('Pick Video'),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController!),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null // Disable button if loading
            : () async {
          setState(() {
            isLoading = true;
          });

          print("                      999999999           ");

          EasyLoading.show(
              status: 'Logging in...'); // Show loading

          try {

            String? filePath = _selectedVideo?.path;

            var result = await uploadMedia(createRe.token, createRe.classId!, _titleController.text, _descriptionController.text, filePath!);
            print(result.data);
            if( result.statusCode==201){
              Get.offNamed("/Enge/:1");
            }
            else{
              EasyLoading.showError('Unexpected error occurred. Please try again.');
            }


          } catch (e) {
            // Handle network or API errors
            print("Error: $e");

            EasyLoading.showError(
                'An error occurred. Please try again.');
          } finally {
            setState(() {
              isLoading = false;
            });
            EasyLoading
                .dismiss(); // Hide loading after response
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 15, 98, 233),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          'Create Reel',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}