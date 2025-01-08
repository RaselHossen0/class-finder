import 'package:carousel_slider/carousel_slider.dart';
import 'package:class_rasel/Global.dart';
import 'package:flutter/material.dart';

class SliderMine extends StatefulWidget {
  final List<dynamic> photos;

  const SliderMine({Key? key, required this.photos}) : super(key: key);

  @override
  _SliderMineState createState() => _SliderMineState();
}

class _SliderMineState extends State<SliderMine> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.photos.isEmpty
          ? Center(child: Text("No photos available"))
          : CarouselSlider.builder(
          itemCount: widget.photos.length,
          options: CarouselOptions(
            height: 300, // Adjust height as needed
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            viewportFraction: 1.0, // Show one item at a time
            enableInfiniteScroll: widget.photos.length > 1,
        ),
        itemBuilder: (context, index, realIndex) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage("$rootApi/${widget.photos[index]["url"]}"),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
