import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'rounded_input_text_field.dart';

class RoundedPasswordField extends StatefulWidget {
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final String hintText;

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: _isHidden,
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: cPrimaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: _toggleVisibility,
            child: Icon(
              _isHidden ? Icons.visibility : Icons.visibility_off,
              color: cPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
