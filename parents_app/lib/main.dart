import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:video_player/video_player.dart';

import 'ProfileScreen.dart';
import 'Screens/Welcome/welcome_screen.dart';
import 'constants.dart';

void main() {
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: cPrimaryColor,
      ),
      // themeMode: Themes.themeMode,
      // theme: Themes.defaultLightTheme,
      // darkTheme: Themes.darkTheme,
      // highContrastTheme: Themes.highContrastLightTheme,
      // highContrastDarkTheme: Themes.highContrastDarkTheme,
      home: const WelcomeScreen(),
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class AppScreens extends ConsumerStatefulWidget {
  const AppScreens({super.key});

  @override
  ConsumerState<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends ConsumerState<AppScreens> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomeScreen(),
          EventsScreen(),
          ChatScreen(),
          ProfileWidget(
            name: "John Doe",
            email: "johndoe@example.com",
            imageUrl: "https://example.com/profile.jpg",
            onLogout: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
              // Define logout functionality here
            },
          )
        ],
      ),
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
                  icon: Icons.event,
                  text: 'Events',
                ),
                GButton(
                  icon: Icons.message,
                  text: 'Messages',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                ref.read(selectedIndexProvider.notifier).state = index;

                // Handle tab change
              },
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CookingClass> cookingClasses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cookingClasses.add(CookingClass(
      title: 'Dance class at Dance Dynamics',
      date: '15 Sep 2024',
      location: '4517 Washington Ave. Manchester',
      imageUrl:
          'https://images.squarespace-cdn.com/content/v1/5fff80bc242bf166f24693d9/1611867377645-J40VTGSCE9LVF2R56Z75/DanceDynamics_286.jpg',
      onJoinTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassDetailsScreen()),
        );
      },
    ));
    cookingClasses.add(CookingClass(
      title: 'Music class at Brooklyn School of Music',
      date: 'Everyday At 05 PM',
      location: '4517 Washington Ave. Manchester',
      imageUrl:
          'https://www.bsmny.org/wp-content/uploads/2022/05/Project_Bridge_PB2022_21-1024x683.jpg',
      onJoinTap: () {},
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              // Location and Menu Row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'New York',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.tune, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Main Content
      body: CustomScrollView(
        slivers: [
          // Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {},
                        child: Text(
                          'View all',
                          style: TextStyle(
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryItem(Icons.music_note, 'Dance'),
                      _buildCategoryItem(Icons.sports_basketball, 'Music'),
                      _buildCategoryItem(Icons.museum, 'Events'),
                      _buildCategoryItem(Icons.music_note, 'Others'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Rest of your content...
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CookingClassCard(
                title: cookingClasses[index].title,
                date: cookingClasses[index].date,
                location: cookingClasses[index].location,
                imageUrl: cookingClasses[index].imageUrl,
                onJoinTap: cookingClasses[index].onJoinTap,
              ),
              childCount: cookingClasses.length,
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             // Status Bar Time and Battery Section
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       '9:41',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.signal_cellular_alt, size: 16),
//                         const SizedBox(width: 4),
//                         Icon(Icons.wifi, size: 16),
//                         const SizedBox(width: 4),
//                         Icon(Icons.battery_full, size: 16),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Story/Profile Section
//             SliverToBoxAdapter(
//               child: Container(
//                 height: 100,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     // Your Story
//                     Column(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           margin: const EdgeInsets.symmetric(horizontal: 8),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: const Center(
//                             child: Icon(Icons.add, size: 30),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text('You', style: TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                     // Other Stories
//                     for (var i = 0; i < 4; i++)
//                       Column(
//                         children: [
//                           Container(
//                             width: 60,
//                             height: 60,
//                             margin: const EdgeInsets.symmetric(horizontal: 8),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.orange),
//                               image: const DecorationImage(
//                                 image: NetworkImage('https://picsum.photos/60'),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text('@User$i', style: const TextStyle(fontSize: 12)),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Category Pills
//             SliverToBoxAdapter(
//               child: Container(
//                 height: 40,
//                 margin: const EdgeInsets.symmetric(vertical: 16),
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       margin: const EdgeInsets.only(right: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'Near By You',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     for (var category in [
//                       '🦾 Sport',
//                       '🎪 Circus',
//                       '🎪 Circuss'
//                     ])
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         margin: const EdgeInsets.only(right: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(category),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Search Bar with Tags
//             SliverToBoxAdapter(
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.search, color: Colors.grey),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Wrap(
//                         spacing: 8,
//                         children: [
//                           for (var tag in [
//                             '🥐 Dance',
//                             '🦾 Music',
//                             '🎻 Orchestra'
//                           ])
//                             Chip(
//                               label: Text(tag),
//                               deleteIcon: const Icon(Icons.close, size: 16),
//                               onDeleted: () {},
//                               backgroundColor: Colors.white,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Class Cards List
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) => Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: CookingClassCard(
//                     title: index == 0
//                         ? 'Dance class at Dance Dynamics'
//                         : 'Music class at Brooklyn School of Music',
//                     date: index == 0 ? '15 Sep 2024' : 'Everyday At 05 PM',
//                     location: '4517 Washington Ave. Manchester',
//                     imageUrl: index == 0
//                         ? 'https://images.squarespace-cdn.com/content/v1/5fff80bc242bf166f24693d9/1611867377645-J40VTGSCE9LVF2R56Z75/DanceDynamics_286.jpg'
//                         : 'https://www.bsmny.org/wp-content/uploads/2022/05/Project_Bridge_PB2022_21-1024x683.jpg',
//                     onJoinTap: () {},
//                   ),
//                 ),
//                 childCount: 2,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CookingClassCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final VoidCallback onJoinTap;

  const CookingClassCard({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.onJoinTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      image: NetworkImage(imageUrl),
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
                      date,
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
                    title,
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
                          location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Wants Join',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '14',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/50',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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

class ClassDetailsScreen extends StatefulWidget {
  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
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

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  late VideoPlayerController _introVideoController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    _initializeIntroVideo();
  }

  Future<void> _initializeIntroVideo() async {
    _introVideoController = VideoPlayerController.network(
      'https://samplelib.com/lib/preview/mp4/sample-5s.mp4', // Replace with your video URL
    );

    await _introVideoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _introVideoController,
      autoPlay: false,
      looping: false,
    );
    setState(() {}); // Rebuild to show the player
  }

  @override
  void dispose() {
    _introVideoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.light,
            ),
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Dance Studio',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://c8.alamy.com/comp/W2C3AK/students-of-traditional-indian-dance-in-class-chennai-madras-tamil-nadu-india-W2C3AK.jpg',
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
                    'Dance Studio',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dance • 0.5 km • \$50/month',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Learn various dance styles from professional instructors. Our studio offers classes for all skill levels and age groups.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Photos',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://imgmedia.lbb.in/media/2019/03/5c9213c8005a5f60d9912ac5_1553077192080.jpg',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  Text(
                    'Reels',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Handle reel video playback on tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReelVideoScreen(
                                  videoUrl:
                                      'https://www.instagram.com/reel/C48R8-5S5Vj/?utm_source=ig_embed&amp;utm_campaign=loading', // Replace with actual reel URL
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 10),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'https://cacpro.com/wp-content/uploads/2023/09/cacpro_blog_InstagramReels_header_0923-990x565.jpg',
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 180,
                                  ),
                                ),
                                const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white70,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upcoming Activities',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ActivityCard(
                    title: 'Summer Dance Workshop',
                    date: 'July 15, 2023',
                    icon: Icons.emoji_events,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  ActivityCard(
                    title: 'Annual Dance Competition',
                    date: 'August 20, 2023',
                    icon: Icons.emoji_events,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          // Placeholder for chat navigation
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        label: const Text('Chat with Instructor',
            style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for modern look
      // appBar: AppBar(
      //   backgroundColor: Colors.black, // Modern orange theme
      //   title: const Text('Events & Competitions'),
      //   centerTitle: true, // Center title for symmetry
      // ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.event, color: Colors.black),
                    const SizedBox(width: 10),
                    Text(
                      'Event ${index + 1}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      'Date: July ${index + 1}, 2023',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text(
                      'Location: City Park',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Join us for a day filled with exciting activities and performances!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Learn More',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: const Text('Join Event',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Instructor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                bool isMe = index % 2 == 0;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'This is message ${index + 1}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
