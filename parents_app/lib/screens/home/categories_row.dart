import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../providers/categories_provider.dart';

class CategoryRowWidget extends ConsumerWidget {
  const CategoryRowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories
            .map((category) => _buildCategoryItem(
                  category.logo != null
                      ? NetworkImage(category.logo!)
                      : AssetImage(categoryIcon),
                  category.name,
                ))
            .toList(),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildCategoryItem(ImageProvider icon, String label) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image(
              image: icon,
              height: 35,
              width: 35,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset(categoryIcon, height: 35, width: 35),
            )),
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
