import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> skill;
  final bool scroll;
  final LayerLink? layerLink;

  const Dropdown({
    super.key,
    required this.skill,
    required this.scroll,
    required this.layerLink, // LayerLink added
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  void _removeSkill(String skill) {
    // This method is intentionally left empty for future use
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: widget.layerLink!, // Link the LayerLink to this widget
      child: Container(
        child: widget.scroll
            ? SizedBox(
          height: 50, // Set a fixed height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.skill.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(
                  label: Text(widget.skill[index]),
                  backgroundColor:
                  const Color.fromARGB(255, 248, 250, 252),
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 17, 17, 17)),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              );
            },
          ),
        )
            : Wrap(
          spacing: 8.0, // Space between chips horizontally
          runSpacing: 8.0, // Space between chips vertically
          children: widget.skill.map((skill) {
            return Chip(
              label: Text(
                skill,
                style: const TextStyle(color: Colors.lightBlue),
              ),
              backgroundColor:
              const Color.fromARGB(255, 241, 245, 249),
              labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 17, 17, 17)),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16.0),
              ),
              deleteIcon: const Icon(
                Icons.close,
                size: 18,
                color: Colors.lightBlue,
              ),
              onDeleted: () {
                setState(() {
                  widget.skill.remove(skill);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
