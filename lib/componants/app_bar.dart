import 'package:class_rasel/Global.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/svg.dart';

class appBar extends StatefulWidget {
  final String title;
  const appBar({super.key, required this.title});

  @override
  State<appBar> createState() => _appBarState();
}

// ignore: camel_case_types
class _appBarState extends State<appBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              noti,
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
