// import 'package:class_finder/constants.dart';
// import 'package:class_finder/providers/ratingProvider.dart';
// import 'package:class_finder/providers/user_provider.dart';
import 'package:class_rasel/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../providers/ratingProvider.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final int classId;

  RatingScreen({required this.classId});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  @override
  void initState() {
    ref.read(ratingProvider.notifier).fetchRatings(widget.classId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ratingState = ref.watch(ratingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: Text('Class Ratings'),
      ),
      body: ratingState.when(
        data: (ratings) => ListView.builder(
          itemCount: ratings.length,
          itemBuilder: (context, index) {
            final rating = ratings[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    '$frontEndUrl/${rating.user.profileImage}',
                  ),
                ),
                title: Text(
                  rating.user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      rating.comment,
                      style: GoogleFonts.openSans(
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${DateFormat.yMMMd().format(DateTime.parse(rating.createdAt))}', // Assuming `rating.createdAt` is a String that can be parsed to DateTime
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    Text('${rating.rating}'),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRatingDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddRatingDialog(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    double rating = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Rating'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: 'Comment'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Text('Rating (0-5)'),
              Slider(
                value: rating,
                min: 0,
                max: 5,
                divisions: 5,
                label: rating.toString(),
                activeColor: const Color.fromARGB(255, 157, 74, 15),
                inactiveColor: Colors.grey,
                onChanged: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     final user = ref.read(userDetailsProvider);
            //     final ratingData = {
            //       'userId': user!.id, // Replace with actual user ID
            //       'classId': widget.classId,
            //       'rating': rating,
            //       'comment': commentController.text,
            //     };
            //     ref.read(ratingProvider.notifier).addRating(ratingData);
            //     Navigator.pop(context);
            //   },
            //   child: Text('Submit'),
            // ),
          ],
        ),
      ),
    );
  }
}
