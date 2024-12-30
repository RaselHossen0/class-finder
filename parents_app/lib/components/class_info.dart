import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helper_functions/calsDistance.dart';
import '../models/class.dart';
import '../providers/locationServiceProvider.dart';

class ClassInfoWidget extends ConsumerWidget {
  final ClassModel classModel;
  final bool showDistanceOnly;

  ClassInfoWidget({required this.classModel, this.showDistanceOnly = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationNotifierProvider);

    return locationState.when(
      data: (location) {
        double distance = calculateDistance(
          location['latitude'],
          location['longitude'],
          classModel.coords.lat,
          classModel.coords.lng,
        );

        return Text(
          showDistanceOnly
              ? '${distance.toStringAsFixed(1)} km away'
              : '${classModel.category} • ${distance.toStringAsFixed(1)} km • ${classModel.price} ₹/month',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.grey[700]),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
