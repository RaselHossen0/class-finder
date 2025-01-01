import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../components/location_widget.dart';
import '../../main.dart';
import '../../models/class.dart';
import '../../providers/class_providers.dart';
import '../class/class_details.dart';
import 'categories_row.dart';
import 'class_card.dart';
import 'class_search_widget.dart';

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
    final pagingController = ref.watch(pagedClassesProvider);

    return Scaffold(
      // Custom App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              // Location and Menu Row
              Expanded(child: LocationWidget()),
              // Search Bar
              ClassSearchWidget()
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
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     padding: EdgeInsets.zero,
                      //     backgroundColor: Colors.transparent,
                      //   ),
                      //   onPressed: () {},
                      //   child: Text(
                      //     'View all',
                      //     style: TextStyle(
                      //       color: Colors.orange,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CategoryRowWidget(),
                ],
              ),
            ),
          ),

          // Rest of your content...
          // Classes Section
          PagedSliverList<int, ClassModel>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<ClassModel>(
              itemBuilder: (context, item, index) => CookingClassCard(
                classModel: item,
                onJoinTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassDetailsScreen(
                        classModel: item,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
    );
  }
}
