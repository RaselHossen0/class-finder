import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/locationServiceProvider.dart';

class LocationWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationNotifierProvider);
    // final user = ref.watch(userDetailsProvider);

    return Scaffold(
      body: locationState.when(
        data: (location) {
          String city = location['city'];
          double latitude = location['latitude'];
          double longitude = location['longitude'];
          String address = location['address'];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '$address, $city',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(100),
                //   child: Container(
                //     height: 20,
                //     width: 20,
                //     child: Image.network(
                //       user!.profileImage,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
