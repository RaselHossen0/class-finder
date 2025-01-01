import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/filter_provider.dart';

class Distanceslider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Slider(
          value: filterState.distanceRange,
          min: 0,
          max: 3000,
          activeColor: Colors.black,
          inactiveColor: Colors.grey[300],
          divisions: 30,
          label: '${filterState.distanceRange.toStringAsFixed(0)} km',
          onChanged: (value) {
            ref.read(filterProvider.notifier).updateDistanceRange(value);
            print(filterState.distanceRange);
          },
        ),
      ],
    );
  }
}
