import 'package:class_finder/screens/auth/Passwords/otpSendScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/background.dart';
import '../../../components/rounded_button.dart';
import '../../../constants.dart';
import '../../../providers/user_provider.dart';
import '../../Signup/signup_screen.dart';
import '../../nav/navigation_screen.dart';
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
              hintText: "Password",
              controller: _passwordController,
              onChanged: (value) {},
            ),
            if (loginState.isLoading)
              CircularProgressIndicator()
            else
              RoundedButton(
                text: "LOGIN",
                press: () async {
                  ref.read(loginProvider.notifier).login(
                        _emailController.text,
                        _passwordController.text,
                      );
                  print(loginState.token);
                  if (loginState.token != null) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('token', loginState.token!);
                    ref.read(userDetailsProvider.notifier).fetchUserDetails(
                          loginState.token!,
                        );

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppScreens()));
                  }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot Password ? ',
                  style: const TextStyle(color: cPrimaryColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const OtpSendScreen();
                    }));
                  },
                  child: Text(
                    'Reset',
                    style: const TextStyle(
                      color: cPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
