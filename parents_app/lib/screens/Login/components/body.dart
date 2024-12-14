import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/background.dart';
import '../../../components/rounded_button.dart';
import '../../Signup/signup_screen.dart';
import '../loginprovider.dart';
import 'already_have_an_acount_check.dart';
import 'rounded_input_text_field.dart';
import 'rounded_password_field.dart';

class Body extends ConsumerStatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputTextField(
              controller: _emailController,
              hintText: "Your email",
              onChanged: (value) {},
              icon: Icons.person,
            ),
            RoundedPasswordField(
              controller: _passwordController,
              onChanged: (value) {},
            ),
            if (loginState.isLoading)
              CircularProgressIndicator()
            else
              RoundedButton(
                text: "LOGIN",
                press: () {
                  ref.read(loginProvider.notifier).login(
                        _emailController.text,
                        _passwordController.text,
                      );
                },
              ),
            if (loginState.errorMessage != null)
              Text(
                loginState.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAcountCheck(
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
