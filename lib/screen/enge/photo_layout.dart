import 'package:flutter/material.dart';

class PhotoLayoutMine extends StatefulWidget {
  final List<dynamic> photos;

  const PhotoLayoutMine({Key? key, required this.photos}) : super(key: key);

  @override
  _PhotoLayoutMineState createState() => _PhotoLayoutMineState();
}

class _PhotoLayoutMineState extends State<PhotoLayoutMine> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (widget.photos.isEmpty) {
            return Center(child: Text("No photos available"));
          } else if (widget.photos.length == 1) {
            return Image.network(
              widget.photos[0]["url"],
              fit: BoxFit.cover,
              width: double.infinity,
            );
          } else if (widget.photos.length == 2) {
            return Row(
              children: widget.photos.map((photo) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.network(photo["url"], fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            );
          } else if (widget.photos.length == 3) {
            return Column(
              children: [
                Expanded(
                  child: Image.network(
                    widget.photos[0]["url"],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Row(
                  children: widget.photos.sublist(1).map((photo) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.network(photo["url"], fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          } else if (widget.photos.length == 4) {
            return GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return Image.network(widget.photos[index]["url"], fit: BoxFit.cover);
              },
            );
          } else {
            return Stack(
              children: [
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Image.network(widget.photos[index]["url"], fit: BoxFit.cover);
                  },
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                    child: Center(
                      child: Text(
                        "+${widget.photos.length - 4}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
