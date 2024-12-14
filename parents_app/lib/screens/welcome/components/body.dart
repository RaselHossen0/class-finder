import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/background.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import '../../Signup/signup_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome To Authentication",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/icons/chat.svg",
                height: size.height * 0.45,
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "LOGIN",
                press: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    )),
              ),
              RoundedButton(
                text: "Sign Up",
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                ),
                color: cPrimaryLightColor,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
