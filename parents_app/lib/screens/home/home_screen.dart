import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/location_widget.dart';
import '../../main.dart';
import '../../providers/class_providers.dart';
import '../class/class_details.dart';
import 'categories_row.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<CookingClass> cookingClasses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final classesAsyncValue = ref.watch(classesProvider);

    return Scaffold(
      // Custom App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              // Location and Menu Row
              Expanded(child: LocationWidget()),
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
                  CategoryRowWidget(),
                ],
              ),
            ),
          ),

          // Rest of your content...
          classesAsyncValue.when(
            data: (classes) {
              if (classes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text('No classes available nearby')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CookingClassCard(
                    classModel: classes[index],
                    onJoinTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailsScreen(
                            classModel: classes[index],
                          ),
                        ),
                      );
                    },
                  ),
                  childCount: classes.length,
                ),
              );
            },
            loading: () => SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
    );
  }
}
