// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:modern_themes/modern_themes.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class CookingClass {
//   final String title;
//   final String date;
//   final String location;
//   final String imageUrl;
//   final VoidCallback onJoinTap;
//
//   CookingClass({
//     required this.title,
//     required this.date,
//     required this.location,
//     required this.imageUrl,
//     required this.onJoinTap,
//   });
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Parent App',
//       debugShowCheckedModeBanner: false,
//       themeMode: Themes.themeMode,
//       theme: Themes.defaultLightTheme,
//       darkTheme: Themes.darkTheme,
//       highContrastTheme: Themes.highContrastLightTheme,
//       highContrastDarkTheme: Themes.highContrastDarkTheme,
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   final List<CookingClass> cookingClasses = [
//     CookingClass(
//       title: 'Dance class at Dance Dynamics',
//       date: '15 Sep 2024',
//       location: '4517 Washington Ave. Manchester',
//       imageUrl:
//       'https://images.squarespace-cdn.com/content/v1/5fff80bc242bf166f24693d9/1611867377645-J40VTGSCE9LVF2R56Z75/DanceDynamics_286.jpg',
//       onJoinTap: () {},
//     ),
//     CookingClass(
//       title: 'Music class at BrooklynSchool of Music',
//       date: 'Everyday At 05 PM',
//       location: '4517 Washington Ave. Manchester',
//       imageUrl:
//       'https://www.bsmny.org/wp-content/uploads/2022/05/Project_Bridge_PB2022_21-1024x683.jpg',
//       onJoinTap: () {},
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Custom App Bar
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(130),
//         child: Container(
//           padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//           child: Column(
//             children: [
//               // Location and Menu Row
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, size: 20),
//                         SizedBox(width: 8),
//                         Text(
//                           'New York',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.menu),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//               // Search Bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Icon(Icons.search, color: Colors.grey),
//                       ),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Search...',
//                             border: InputBorder.none,
//                             hintStyle: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Icon(Icons.tune, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       // Main Content
//       body: CustomScrollView(
//         slivers: [
//           // Categories Section
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Categories',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           backgroundColor: Colors.transparent,
//                         ),
//                         onPressed: () {},
//                         child: Text(
//                           'View all',
//                           style: TextStyle(
//                             color: Colors.orange,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildCategoryItem(Icons.music_note, 'Concert'),
//                       _buildCategoryItem(Icons.sports_basketball, 'Sport'),
//                       _buildCategoryItem(Icons.museum, 'Exhibition'),
//                       _buildCategoryItem(Icons.music_note, 'DJ-Set'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Rest of your content...
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//                   (context, index) => CookingClassCard(
//                 title: cookingClasses[index].title,
//                 date: cookingClasses[index].date,
//                 location: cookingClasses[index].location,
//                 imageUrl: cookingClasses[index].imageUrl,
//                 onJoinTap: cookingClasses[index].onJoinTap,
//               ),
//               childCount: cookingClasses.length,
//             ),
//           ),
//         ],
//       ),
//
//       // Bottom Navigation Bar
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 20,
//               color: Colors.black.withOpacity(.1),
//             )
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//             child: GNav(
//               gap: 8,
//               activeColor: Colors.white,
//               iconSize: 24,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               duration: Duration(milliseconds: 400),
//               tabBackgroundColor: Colors.black,
//               tabs: [
//                 GButton(
//                   icon: Icons.home,
//                   text: 'Home',
//                 ),
//                 GButton(
//                   icon: Icons.apps,
//                   text: 'Categories',
//                 ),
//                 GButton(
//                   icon: Icons.bookmark,
//                   text: 'Saved',
//                 ),
//                 GButton(
//                   icon: Icons.person,
//                   text: 'Profile',
//                 ),
//               ],
//               selectedIndex: 0,
//               onTabChange: (index) {
//                 // Handle tab change
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryItem(IconData icon, String label) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, size: 24),
//         ),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
// // class HomeScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: CustomScrollView(
// //           slivers: [
// //             // Status Bar Time and Battery Section
// //             SliverToBoxAdapter(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     const Text(
// //                       '9:41',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     Row(
// //                       children: [
// //                         Icon(Icons.signal_cellular_alt, size: 16),
// //                         const SizedBox(width: 4),
// //                         Icon(Icons.wifi, size: 16),
// //                         const SizedBox(width: 4),
// //                         Icon(Icons.battery_full, size: 16),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // Story/Profile Section
// //             SliverToBoxAdapter(
// //               child: Container(
// //                 height: 100,
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 child: ListView(
// //                   scrollDirection: Axis.horizontal,
// //                   children: [
// //                     // Your Story
// //                     Column(
// //                       children: [
// //                         Container(
// //                           width: 60,
// //                           height: 60,
// //                           margin: const EdgeInsets.symmetric(horizontal: 8),
// //                           decoration: BoxDecoration(
// //                             shape: BoxShape.circle,
// //                             border: Border.all(color: Colors.grey.shade300),
// //                           ),
// //                           child: const Center(
// //                             child: Icon(Icons.add, size: 30),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 4),
// //                         const Text('You', style: TextStyle(fontSize: 12)),
// //                       ],
// //                     ),
// //                     // Other Stories
// //                     for (var i = 0; i < 4; i++)
// //                       Column(
// //                         children: [
// //                           Container(
// //                             width: 60,
// //                             height: 60,
// //                             margin: const EdgeInsets.symmetric(horizontal: 8),
// //                             decoration: BoxDecoration(
// //                               shape: BoxShape.circle,
// //                               border: Border.all(color: Colors.orange),
// //                               image: const DecorationImage(
// //                                 image: NetworkImage('https://picsum.photos/60'),
// //                                 fit: BoxFit.cover,
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Text('@User$i', style: const TextStyle(fontSize: 12)),
// //                         ],
// //                       ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // Category Pills
// //             SliverToBoxAdapter(
// //               child: Container(
// //                 height: 40,
// //                 margin: const EdgeInsets.symmetric(vertical: 16),
// //                 child: ListView(
// //                   scrollDirection: Axis.horizontal,
// //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 16, vertical: 8),
// //                       margin: const EdgeInsets.only(right: 8),
// //                       decoration: BoxDecoration(
// //                         color: Colors.black,
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: const Text(
// //                         'Near By You',
// //                         style: TextStyle(color: Colors.white),
// //                       ),
// //                     ),
// //                     for (var category in [
// //                       '🦾 Sport',
// //                       '🎪 Circus',
// //                       '🎪 Circuss'
// //                     ])
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                             horizontal: 16, vertical: 8),
// //                         margin: const EdgeInsets.only(right: 8),
// //                         decoration: BoxDecoration(
// //                           color: Colors.grey.shade200,
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                         child: Text(category),
// //                       ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // Search Bar with Tags
// //             SliverToBoxAdapter(
// //               child: Container(
// //                 margin: const EdgeInsets.symmetric(horizontal: 16),
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade100,
// //                   borderRadius: BorderRadius.circular(25),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.search, color: Colors.grey),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: Wrap(
// //                         spacing: 8,
// //                         children: [
// //                           for (var tag in [
// //                             '🥐 Dance',
// //                             '🦾 Music',
// //                             '🎻 Orchestra'
// //                           ])
// //                             Chip(
// //                               label: Text(tag),
// //                               deleteIcon: const Icon(Icons.close, size: 16),
// //                               onDeleted: () {},
// //                               backgroundColor: Colors.white,
// //                             ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //
// //             // Class Cards List
// //             SliverList(
// //               delegate: SliverChildBuilderDelegate(
// //                 (context, index) => Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 8),
// //                   child: CookingClassCard(
// //                     title: index == 0
// //                         ? 'Dance class at Dance Dynamics'
// //                         : 'Music class at Brooklyn School of Music',
// //                     date: index == 0 ? '15 Sep 2024' : 'Everyday At 05 PM',
// //                     location: '4517 Washington Ave. Manchester',
// //                     imageUrl: index == 0
// //                         ? 'https://images.squarespace-cdn.com/content/v1/5fff80bc242bf166f24693d9/1611867377645-J40VTGSCE9LVF2R56Z75/DanceDynamics_286.jpg'
// //                         : 'https://www.bsmny.org/wp-content/uploads/2022/05/Project_Bridge_PB2022_21-1024x683.jpg',
// //                     onJoinTap: () {},
// //                   ),
// //                 ),
// //                 childCount: 2,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class CookingClassCard extends StatelessWidget {
//   final String title;
//   final String date;
//   final String location;
//   final String imageUrl;
//   final VoidCallback onJoinTap;
//
//   const CookingClassCard({
//     Key? key,
//     required this.title,
//     required this.date,
//     required this.location,
//     required this.imageUrl,
//     required this.onJoinTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image container with overlays
//           Stack(
//             children: [
//               // Background image
//               Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(12),
//                     topRight: Radius.circular(12),
//                   ),
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               // Date chip
//               Positioned(
//                 top: 16,
//                 right: 16,
//                 child: Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     date,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ),
//               // Fork icon
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.amber.shade100,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.restaurant,
//                     size: 20,
//                     color: Colors.amber.shade800,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Content section
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on_outlined,
//                       size: 20,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'Wants Join',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         '14',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '/50',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ClassDetailsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             expandedHeight: 200.0,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text('Dance Studio'),
//               background: Image.network(
//                 'https://source.unsplash.com/random/400x200?dance',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Dance Studio',
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Dance • 0.5 km • \$50/month',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Learn various dance styles from professional instructors. Our studio offers classes for all skill levels and age groups.',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Photos',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   SizedBox(height: 8),
//                   Container(
//                     height: 120,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 5,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               'https://source.unsplash.com/random/120x120?dance&sig=$index',
//                               width: 120,
//                               height: 120,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Videos',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   SizedBox(height: 8),
//                   ElevatedButton.icon(
//                     onPressed: () {},
//                     icon: Icon(Icons.play_arrow),
//                     label: Text('Watch Intro Video'),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Upcoming Activities',
//                     style: Theme.of(context).textTheme.headlineLarge,
//                   ),
//                   SizedBox(height: 8),
//                   ListTile(
//                     title: Text('Summer Dance Workshop'),
//                     subtitle: Text('July 15, 2023'),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                   ),
//                   ListTile(
//                     title: Text('Annual Dance Competition'),
//                     subtitle: Text('August 20, 2023'),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ChatScreen()),
//         ),
//         label: Text('Chat with Instructor'),
//         icon: Icon(Icons.chat),
//       ),
//     );
//   }
// }
//
// class EventsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events and Competitions'),
//       ),
//       body: ListView.builder(
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.event, color: Colors.blue),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Event ${index + 1}',
//                         style: Theme.of(context)
//                             .textTheme
//                             .headlineMedium
//                             ?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Date: July ${index + 1}, 2023',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: Colors.grey),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Location: City Park',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Join us for a fun-filled day of activities and performances!',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       OutlinedButton(
//                         onPressed: () {},
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.blue),
//                         ),
//                         child: const Text('Learn More'),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                         ),
//                         child: const Text('Join Event'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with Instructor'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 bool isMe = index % 2 == 0;
//                 return Align(
//                   alignment:
//                   isMe ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: isMe ? Colors.blue[100] : Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'This is message ${index + 1}',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
