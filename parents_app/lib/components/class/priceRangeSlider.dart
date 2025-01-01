import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/filter_provider.dart';

class PriceRangeSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        RangeSlider(
          values: RangeValues(
            filterState.priceRange,
            filterState
                .priceRangeMax, // Assuming you have a max price range in state
          ),
          min: 0,
          max: 5000,
          divisions: 20,
          labels: RangeLabels(
            '${filterState.priceRange.toStringAsFixed(0)} ₹',
            '${filterState.priceRangeMax.toStringAsFixed(0)} ₹',
          ),
          onChanged: (values) {
            ref
                .read(filterProvider.notifier)
                .updatePriceRange(values.start, values.end);
          },
          activeColor: Colors.black,
          inactiveColor: Colors.grey[300],
        ),
      ],
    );
  }
}
