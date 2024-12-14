import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'rounded_input_text_field.dart';

class RoundedPasswordField extends StatelessWidget {
  RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: cPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: cPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
