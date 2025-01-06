import 'package:class_rasel/componants/app_bar.dart';
import 'package:class_rasel/componants/button2.dart';
import 'package:class_rasel/screen/enge/events.dart';
import 'package:class_rasel/screen/enge/reels.dart';
import 'package:flutter/material.dart';

class Enge extends StatefulWidget {
  final int initialIndex;

  const Enge({super.key, required this.initialIndex});

  @override
  State<Enge> createState() => _EngeState();
}

class _EngeState extends State<Enge> {
  late int ind;

  @override
  void initState() {
    super.initState();
    ind = widget.initialIndex; // Initialize the selected index
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              appBar(title: 'Engagement Tool'), // Custom AppBar widget

              ButtonRow2(
                ind: ind,
                onIndexChanged: (value) {
                  setState(() {
                    ind = value; // Update index on tab switch
                  });
                },
              ),

              const SizedBox(height: 8),

              // Display widgets conditionally
              if (ind == 0)
                const Reels(), // Reels widget is automatically disposed when removed
              if (ind == 2)
                const Events(), // Events widget
            ],
          ),
        ),
      ),
    );
  }
}
