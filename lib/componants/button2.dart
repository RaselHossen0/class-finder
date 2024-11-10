import 'package:flutter/material.dart';

class ButtonRow2 extends StatefulWidget {
  final int ind; // Initial selected index
  final Function(int) onIndexChanged; // Callback to notify index change

  const ButtonRow2({
    super.key,
    required this.ind,
    required this.onIndexChanged,
  });

  @override
  State<ButtonRow2> createState() => _ButtonRow2State();
}

class _ButtonRow2State extends State<ButtonRow2> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.ind; // Set initial value
  }

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
      widget.onIndexChanged(index); // Notify parent of the change
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 10.0, // Space between buttons
        runSpacing: 10.0, // Space between rows if wrapped
        alignment: WrapAlignment.start, // Center align the buttons
        children: [
          CustomOutlinedButton2(
            text: 'Reels',
            isSelected: _selectedIndex == 0, // Check if this button is selected
            onPressed: () {
              _onButtonPressed(0);
            },
          ),
          CustomOutlinedButton2(
            text: 'Posts',
            isSelected: _selectedIndex == 1, // Check if this button is selected
            onPressed: () {
              _onButtonPressed(1);
            },
          ),
          // CustomOutlinedButton2(
          //   text: 'Experiences',
          //   isSelected: _selectedIndex == 2, // Check if this button is selected
          //   onPressed: () {
          //     _onButtonPressed(2);
          //   },
          // ),
          CustomOutlinedButton2(
            text: 'Events',
            isSelected: _selectedIndex == 2, // Check if this button is selected
            onPressed: () {
              _onButtonPressed(2);
            },
          ),
        ],
      ),
    );
  }
}

class CustomOutlinedButton2 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSelected;

  const CustomOutlinedButton2({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromARGB(255, 151, 159, 10)
            : Colors.white, // Change background color
        side: BorderSide(
          color: isSelected
              ? const Color.fromARGB(255, 151, 159, 10)
              : Colors.blueGrey, // Change border color
          width: 2,
        ), // Border color and width
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // Button padding
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : const Color.fromARGB(
                  255, 34, 36, 2), // Change text color based on selection
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
