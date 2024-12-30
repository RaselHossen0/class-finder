import 'package:chewie/chewie.dart';
import 'package:class_finder/screens/class/photo_views.dart';
import 'package:class_finder/screens/class/reels.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:video_player/video_player.dart';

import '../../components/class_info.dart';
import '../../models/class.dart';
import '../../providers/user_provider.dart';
import 'display_gesture.dart';

final selectedIndexProvider1 = StateProvider<int>((ref) => 0);

class ClassDetailsScreen extends ConsumerStatefulWidget {
  final ClassModel classModel;

  ClassDetailsScreen({super.key, required this.classModel});

  @override
  ConsumerState<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends ConsumerState<ClassDetailsScreen> {
  late VideoPlayerController _introVideoController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userDetailsProvider);
    final videos = widget.classModel.media
        .where((e) => e.type.toLowerCase() == 'reel')
        .toList();
    final List<Media> photos = widget.classModel.media
        .where((e) => e.type.toLowerCase() == 'photo')
        .toList();
    final selectedIndex = ref.watch(selectedIndexProvider1);
    final coverImage = widget.classModel.media.firstOrNull?.url ??
        'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg';
    return Scaffold(
      body: selectedIndex == 0
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  pinned: true,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.light,
                  ),
                  expandedHeight: 250.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      widget.classModel.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.classModel.media.firstWhere((e) {
                                return e.isCoverImage;
                              }).url ??
                              'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.classModel.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ClassInfoWidget(classModel: widget.classModel),
                        const SizedBox(height: 20),
                        Text(
                          widget.classModel.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : selectedIndex == 1
              ? DisplayGesture(
                  child: InteractiveviewDemoPage(
                    classModel: widget.classModel,
                  ),
                )
              // CustomScrollView(
              //             slivers: [
              //               if (photos.isNotEmpty) const SizedBox(height: 24),
              //               if (photos.isNotEmpty)
              //                 Text(
              //                   'Photos',
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .titleLarge
              //                       ?.copyWith(fontWeight: FontWeight.bold),
              //                 ),
              //               if (photos.isNotEmpty) const SizedBox(height: 8),
              //               if (photos.isNotEmpty)
              //                 SizedBox(
              //                   height: 120,
              //                   child: ListView.builder(
              //                     scrollDirection: Axis.horizontal,
              //                     itemCount: photos.length,
              //                     itemBuilder: (context, index) {
              //                       final photo = photos[index];
              //                       return Padding(
              //                         padding: const EdgeInsets.only(right: 10.0),
              //                         child: ClipRRect(
              //                           borderRadius: BorderRadius.circular(10),
              //                           child: Image.network(
              //                             photo.url ??
              //                                 'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg',
              //                             width: 120,
              //                             height: 120,
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       );
              //                     },
              //                   ),
              //                 ),
              //             ],
              //           )

              : ReelsPage(widget.classModel),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.photo,
                  text: 'Photos',
                ),
                // GButton(
                //   icon: Icons.message,
                //   text: 'Messages',
                // ),
                GButton(
                  icon: Icons.video_collection,
                  text: 'Reels',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                ref.read(selectedIndexProvider1.notifier).state = index;

                // Handle tab change
              },
            ),
          ),
        ),
      ),
    );
  }
}
