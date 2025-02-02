import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:class_rasel/Global.dart';
import 'package:class_rasel/every%20class/get_controller.dart';
import 'package:class_rasel/screen/chat/chat_screen.dart';
import 'package:class_rasel/screen/class/class_edit.dart';
import 'package:class_rasel/screen/class/reels.dart';
import 'package:class_rasel/screen/location/locationServiceProvider.dart';
import 'package:class_rasel/screen/rating/ratings.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:video_player/video_player.dart';

import '../../models/class.dart';
import 'class_info.dart';
import 'display_gesture.dart';
import 'photo_views.dart';
import 'package:http/http.dart' as http;

class ClassNotifier extends AsyncNotifier<ClassModel> {
  @override
  Future<ClassModel> build() async {
    return fetchClassData();
  }

  Future<ClassModel> fetchClassData() async {
    cont userState = Get.find();
    final classId = userState.classId;
    print("classId: $classId");

    const String baseUrl = "https://classroom-api.raselhossen.tech";
    const String apiEndpoint = "/classes/";
    final token = userState.token;
    String authToken = "Bearer $token";

    final response = await http.get(
      Uri.parse("$baseUrl$apiEndpoint$classId"),
      headers: {
        'accept': 'application/json',
        'Authorization': authToken,
      },
    );

    print('response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ClassModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load class data');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => fetchClassData());
  }
}

// Provide the notifier
final classProvider = AsyncNotifierProvider<ClassNotifier, ClassModel>(
  ClassNotifier.new,
);
final selectedIndexProvider1 = StateProvider<int>((ref) => 0);

class ClassDetailsScreen extends ConsumerStatefulWidget {
  ClassDetailsScreen({super.key});

  @override
  ConsumerState<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends ConsumerState<ClassDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // 4 tabs
    ref.read(locationNotifierProvider.notifier).fetchLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classAsyncValue = ref.watch(classProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: cPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {
              classAsyncValue.maybeWhen(
                data: (classModel) {
                  Get.to(EditClassScreen(classModel: classModel));
                },
                orElse: () {},
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
        // title: Text("Class Details"),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: () => Navigator.pop(context),
        // ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Your Class'),
            Tab(icon: Icon(Icons.photo), text: 'Photos'),
            Tab(icon: Icon(Icons.video_collection), text: 'Reels'),
            Tab(icon: Icon(Icons.star), text: 'Ratings'),
          ],
        ),
      ),
      body: classAsyncValue.when(
        data: (classModel) => TabBarView(
          controller: _tabController,
          children: [
            // Home Tab
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class Cover Photo Section
                  Stack(
                    children: [
                      Container(
                        height: 250, // Height of the cover photo
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              classModel.media.isNotEmpty
                                  ? classModel.media
                                      .firstWhere((e) => e.isCoverImage)
                                      .url
                                  : 'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          classModel.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),

                  // Remaining Content Below
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classModel.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ClassInfoWidget(classModel: classModel),
                        const SizedBox(height: 20),
                        Text(
                          classModel.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 1.4),
                        ),
                        const SizedBox(height: 20),

                        // Google Map Container
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  classModel.coords.lat,
                                  classModel.coords.lng,
                                ),
                                zoom: 14,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('eventLocation'),
                                  position: LatLng(
                                    classModel.coords.lat,
                                    classModel.coords.lng,
                                  ),
                                  infoWindow: InfoWindow(
                                    title: classModel.name,
                                  ),
                                ),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // Photos Tab
            DisplayGesture(
              child: InteractiveviewDemoPage(
                classModel: classModel,
              ),
            ),
            // Reels Tab
            ReelsPage(classModel),
            // Ratings Tab
            RatingScreen(
              classId: classModel.id,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
