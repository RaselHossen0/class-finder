import 'dart:async';

import 'package:class_finder/components/class/distanceSlider.dart';
import 'package:class_finder/providers/categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/class/priceRangeSlider.dart';
import '../../providers/class_providers.dart';
import '../../providers/filter_provider.dart';

class ClassSearchWidget extends ConsumerWidget {
  ClassSearchWidget({Key? key}) : super(key: key);
  Timer? _debounce;
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    print(filterState.priceRange);
    print(filterState.distanceRange);
    final categories = ref.watch(categoriesProvider);
    void _onSearchChanged() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        ref
            .read(classSearchProvider.notifier)
            .updateSearchQuery(searchController.text);
        final controller = ref.read(pagedClassesProvider);
        controller.refresh();
      });
    }

    searchController.addListener(_onSearchChanged);

    final searchQuery =
        ref.watch(classSearchProvider); // Listen to search query

    // Create a controller outside the build method to avoid reverse text issue

    // Handle text changes and update search query
    searchController.addListener(() {
      ref
          .read(classSearchProvider.notifier)
          .updateSearchQuery(searchController.text);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.search, color: Colors.grey),
            ),
            Expanded(
              child: TextField(
                controller: searchController, // Bind the controller to query
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            CustomPopup(
              content: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with title and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 16),

                    // Price Filter

                    PriceRangeSlider(),
                    SizedBox(height: 16),

                    Distanceslider(),

                    SizedBox(height: 7),

                    // Category Filter (Dropdown)
                    Text(
                      'Category',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: filterState.category.isEmpty
                          ? null
                          : filterState.category,
                      hint: Text('Select Category'),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(filterProvider.notifier)
                            .updateCategory(value ?? '');
                      },
                      items: categories.when(
                        data: (data) {
                          final uniqueCategories =
                              data.toSet().toList(); // Ensure unique values
                          // print(uniqueCategories.length);
                          return uniqueCategories.map<DropdownMenuItem<String>>(
                              (Category category) {
                            return DropdownMenuItem<String>(
                              value: category.id.toString(),
                              child: Text(category.name),
                            );
                          }).toList();
                        },
                        loading: () => [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('Loading...'),
                          ),
                        ],
                        error: (error, stack) => [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('Error loading locations'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Apply Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        onPressed: () {
                          final controller = ref.read(pagedClassesProvider);
                          controller.refresh();
                          Navigator.pop(context);
                          // Optionally, update the list based on the selected filters
                        },
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.white,
              isLongPress: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(Icons.tune, color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
