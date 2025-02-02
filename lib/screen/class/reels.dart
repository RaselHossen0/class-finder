import 'dart:async';

import 'package:class_rasel/models/class.dart';
import 'package:class_rasel/providers/uploadReels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whitecodel_reels/whitecodel_reels.dart';

class ReelsPage extends ConsumerWidget {
  ReelsPage(this.classModel, {super.key});
  final ClassModel classModel;
  Future<void> _pickAndUploadReel(BuildContext context, WidgetRef ref) async {
    print('Picking and uploading reel');
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('No file picked');
      return;
    }

    // Show a dialog to enter details
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final tagsController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Upload Reel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                    labelText: 'Tags (e.g., #tag1 #tag2)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                EasyLoading.show(status: 'Uploading...');
                await ref.read(uploadReelProvider.notifier).uploadReel(
                      filePath: pickedFile.path,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tagsController.text,
                      type: 'reel',
                    );
                EasyLoading.dismiss();
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState = ref.watch(uploadReelProvider);
    if (classModel.media.isEmpty) {
      return Container(
        child: Center(
          child: Text('No reels! Check later'),
        ),
      );
    }
    final videos =
        classModel.media.where((e) => e.type.toLowerCase() == 'reel').toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickAndUploadReel(context, ref),
        child: const Icon(Icons.upload),
      ),
      backgroundColor: Colors.white,
      body: videos.isEmpty
          ? const Center(child: Text('No reels! Check later'))
          : Column(
              children: [
                Expanded(
                  child: WhiteCodelReels(
                    key: UniqueKey(),
                    context: context,
                    loader: const Center(
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    isCaching: false,
                    videoList: List.generate(
                        videos.length, (index) => videos[index].url),
                    builder: (context, index, child, videoPlayerController,
                        pageController) {
                      bool isReadMore = false;
                      bool isVideoError =
                          false; // Flag for handling video errors

                      videoPlayerController.addListener(() {
                        if (videoPlayerController.value.hasError) {
                          isVideoError = true;
                        }
                      });

                      StreamController<double> videoProgressController =
                          StreamController<double>();

                      videoPlayerController.addListener(() {
                        if (!isVideoError) {
                          double videoProgress = videoPlayerController
                                  .value.position.inMilliseconds /
                              videoPlayerController
                                  .value.duration.inMilliseconds;
                          videoProgressController.add(videoProgress);
                        }
                      });

                      return Stack(
                        children: [
                          if (isVideoError)
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Failed to load video',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Implement video reload logic if needed
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          else
                            child,
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isReadMore = !isReadMore;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.0),
                                              Colors.black.withOpacity(0.2),
                                              Colors.black.withOpacity(0.5),
                                            ],
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints: const BoxConstraints(
                                                maxHeight: 300,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 8,
                                                  ),
                                                  child: Text(
                                                    videos[index].title,
                                                    maxLines:
                                                        isReadMore ? 100 : 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                videos[index].tags,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 30),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 70,
                            right: 10,
                            child: SizedBox(
                              height: 450,
                              child: Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Implement delete functionality
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // Implement like functionality
                                        },
                                        icon: const Icon(
                                          Icons.thumb_up_alt_outlined,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          '10K',
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          StreamBuilder<double>(
                            stream: videoProgressController.stream,
                            builder: (context, snapshot) {
                              return Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    thumbShape: SliderComponentShape.noThumb,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    trackHeight: 2,
                                  ),
                                  child: Slider(
                                    value: (snapshot.data ?? 0).clamp(0.0, 1.0),
                                    min: 0.0,
                                    max: 1.0,
                                    activeColor: Colors.red,
                                    inactiveColor: Colors.white,
                                    onChanged: (value) {
                                      final position = videoPlayerController
                                              .value.duration.inMilliseconds *
                                          value;
                                      videoPlayerController.seekTo(
                                        Duration(
                                            milliseconds: position.toInt()),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
