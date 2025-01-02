import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whitecodel_reels/whitecodel_reels.dart';

import '../../models/class.dart';

class ReelsPage extends ConsumerWidget {
  ReelsPage(this.classModel, {super.key});
  final ClassModel classModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: Column(
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
                videoList:
                    List.generate(videos.length, (index) => videos[index].url),
                builder: (context, index, child, videoPlayerController,
                    pageController) {
                  bool isReadMore = false;
                  StreamController<double> videoProgressController =
                      StreamController<double>();

                  videoPlayerController.addListener(() {
                    double videoProgress =
                        videoPlayerController.value.position.inMilliseconds /
                            videoPlayerController.value.duration.inMilliseconds;
                    videoProgressController.add(videoProgress);
                  });

                  return Stack(
                    children: [
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
                                              padding: const EdgeInsets.only(
                                                  right: 50, left: 10),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                        ),
                                        //tags
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50, left: 10),
                                          child: Text(
                                            videos[index].tags,
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 50, left: 10),
                                          child: Visibility(
                                            visible: true,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  // Visibility(
                                                  //   visible: true,
                                                  //   child: InkWell(
                                                  //     onTap: () {},
                                                  //     child: RichText(
                                                  //       text: TextSpan(
                                                  //         children: [
                                                  //           const TextSpan(
                                                  //             text: '1000',
                                                  //             style: TextStyle(
                                                  //               color: Colors
                                                  //                   .white70,
                                                  //               fontSize: 14,
                                                  //             ),
                                                  //           ),
                                                  //           TextSpan(
                                                  //             text: " Likes",
                                                  //             style: GoogleFonts
                                                  //                 .roboto(
                                                  //               color: Colors
                                                  //                   .white,
                                                  //               fontSize: 14,
                                                  //             ),
                                                  //           ),
                                                  //         ],
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
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
                          // color: Colors.red.withOpacity(0.5),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      true
                                          ? Icons.thumb_up_alt
                                          : Icons.thumb_up_alt_outlined,
                                      color: Color.fromARGB(
                                        255,
                                        214,
                                        183,
                                        8,
                                      ),
                                    ),
                                    color: Colors.white,
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
                              const SizedBox(
                                height: 10,
                              ),
                              // Column(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: const Icon(
                              //         false
                              //             ? Icons.favorite
                              //             : Icons.favorite_border,
                              //         color: Colors.red,
                              //       ),
                              //       color: Colors.white,
                              //     ),
                              //     InkWell(
                              //       onTap: () {},
                              //       child: Text(
                              //         '10K',
                              //         style: GoogleFonts.roboto(
                              //           color: Colors.white,
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Column(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: const Icon(
                              //         Icons.comment,
                              //         color: Colors.white,
                              //       ),
                              //       color: Colors.white,
                              //     ),
                              //     InkWell(
                              //       child: Text(
                              //         '10K',
                              //         style: GoogleFonts.roboto(
                              //           color: Colors.white,
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Column(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: const Icon(
                              //         Icons.share,
                              //         color: Colors.white,
                              //       ),
                              //       color: Colors.white,
                              //     ),
                              //     Text(
                              //       'Share',
                              //       style: GoogleFonts.roboto(
                              //         color: Colors.white,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Column(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: const Icon(
                              //         false
                              //             ? Icons.bookmark
                              //             : Icons.bookmark_border,
                              //         color: Colors.white,
                              //       ),
                              //       color: Colors.white,
                              //     ),
                              //     Text(
                              //       'Save',
                              //       style: GoogleFonts.roboto(
                              //         color: Colors.white,
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: videoProgressController.stream,
                        builder: (context, snapshot) {
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: SliderComponentShape.noThumb,
                                overlayShape: SliderComponentShape.noOverlay,
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
                                      Duration(milliseconds: position.toInt()));
                                },
                                // onChangeEnd: (value) {
                                //   videoPlayerController.play();
                                // },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
