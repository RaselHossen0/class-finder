import 'package:class_rasel/componants/app_bar.dart';
import 'package:class_rasel/componants/button2.dart';
import 'package:class_rasel/screen/enge/events.dart';
import 'package:class_rasel/screen/enge/reels.dart';
import 'package:flutter/material.dart';

class Enge extends StatefulWidget {
  final int initialIndex; // Add an initialIndex parameter to the constructor

  const Enge({super.key, required this.initialIndex});

  @override
  State<Enge> createState() => _EngeState();
}

class _EngeState extends State<Enge> {
  late int ind;

  @override
  void initState() {
    super.initState();
    ind = widget.initialIndex; // Initialize ind from the passed parameter
    print("              1               ");
    print(ind);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            appBar(title: 'Engagement Tool'), // Custom AppBar widget

            ButtonRow2(
              ind: ind,
              onIndexChanged: (value) {
                setState(() {
                  ind = value; // Trigger rebuild when index changes
                });
              },
            ),

            SizedBox(
              height: 8,
            ),

            if (ind == 0) Reels(),
            if(ind == 2) Events(),
          ],
        ),
      ),
    ));
  }
}
