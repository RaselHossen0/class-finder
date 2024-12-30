import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:chewie/chewie.dart';
import 'package:class_finder/profile/themes.dart';
import 'package:class_finder/providers/chatProvider.dart';
import 'package:class_finder/providers/user_provider.dart';
import 'package:class_finder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'Screens/chat/chatScreen.dart';
import 'components/class_info.dart';
import 'models/class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class CookingClass {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final VoidCallback onJoinTap;

  CookingClass({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.onJoinTap,
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeProvider(
      initTheme: MyThemes.lightTheme,
      child: MaterialApp(
        title: 'Parents App',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: MyThemes.lightTheme,
        // theme: ThemeProvider.of(context),
        home: const InitialScreen(),
      ),
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class CookingClassCard extends ConsumerWidget {
  final ClassModel classModel;
  final VoidCallback onJoinTap;

  const CookingClassCard({
    Key? key,
    required this.classModel,
    required this.onJoinTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userDetailsProvider);
    return InkWell(
      onTap: onJoinTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with overlays
            Stack(
              children: [
                // Background image
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(classModel.media.firstOrNull?.url ??
                          'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Date chip
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      classModel.price.toString() + ' ₹',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Fork icon
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant,
                      size: 20,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classModel.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          classModel.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 2,
                        //   vertical: 1,
                        // ),
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                            onPressed: () async {
                              print('User: $user');
                              print('Class Owner: ${classModel.ClassOwnerId}');

                              final params = {
                                'userId': user!.id,
                                'classOwnerId': classModel.ClassOwnerId
                              };
                              final chatRoom = await ref
                                  .read(createChatProvider(params).future);

                              if (chatRoom != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(chatId: chatRoom),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to create chat room')),
                                );
                              }

                              // Placeholder for chat navigation
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                            },
                            icon: Icon(Icons.message,
                                color: Colors.black, size: 20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClassInfoWidget(
                        classModel: classModel, showDistanceOnly: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;
  final Color color;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.date,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}

class ReelVideoScreen extends StatefulWidget {
  final String videoUrl;

  const ReelVideoScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _ReelVideoScreenState createState() => _ReelVideoScreenState();
}

class _ReelVideoScreenState extends State<ReelVideoScreen> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reel Video'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _chewieController != null
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
