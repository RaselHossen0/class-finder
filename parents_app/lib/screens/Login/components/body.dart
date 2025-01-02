import 'dart:convert';

import 'package:class_finder/screens/auth/Passwords/otpSendScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
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
  bool isLoading = false;
  String? errorMessage;
  String? token;

  Future<void> login(String email, String password) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    EasyLoading.show(status: 'Logging in...');

    try {
      final response = await http.post(
        Uri.parse('https://classroom-api.raselhossen.tech/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == 0) {
          setState(() {
            token = data['token'];
          });
          EasyLoading.showSuccess(data['message']);

          // Store the token in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token!);
          await ref.read(userDetailsProvider.notifier).fetchUserDetails(token!);
          // Navigate to the next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppScreens()),
          );
        } else {
          setState(() {
            errorMessage = data['message'];
          });
          EasyLoading.showError(data['message']);
        }
      } else {
        final errorMessage =
            json.decode(response.body)["message"] ?? 'Login failed';
        setState(() {
          this.errorMessage = errorMessage;
        });
        EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Login failed';
      });
      EasyLoading.showError('Login failed');
    } finally {
      setState(() {
        isLoading = false;
      });
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    print(loginState.token);
    Size size = MediaQuery.of(context).size;
    if (loginState.token != null) {
      // This checks for the token after it is updated
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginState.token!);

        // Fetch user details and navigate to the next screen
        await ref
            .read(userDetailsProvider.notifier)
            .fetchUserDetails(loginState.token!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppScreens()),
        );
      });
    }
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
            if (isLoading)
              CircularProgressIndicator()
            else
              RoundedButton(
                text: "LOGIN",
                press: () async {
                  await login(_emailController.text, _passwordController.text);
                },
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
