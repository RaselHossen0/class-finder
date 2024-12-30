import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/rounded_button.dart';
import '../../Login/components/already_have_an_acount_check.dart';
import '../../Login/components/rounded_input_text_field.dart';
import '../../Login/components/rounded_password_field.dart';
import '../../Login/login_screen.dart';
import '../signup_provider.dart';
import 'background.dart';
import 'or_divider.dart';
import 'socal_icon.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedInputTextField(
                hintText: "Name",
                controller: _nameController,
                onChanged: (value) {
                  _nameController.text = value;
                },
                icon: Icons.person,
              ),
              RoundedInputTextField(
                hintText: "Email",
                controller: _emailController,
                onChanged: (value) {
                  _emailController.text = value;
                },
                icon: Icons.email,
              ),
              RoundedPasswordField(
                hintText: "Password",
                controller: _passwordController,
                onChanged: (value) {
                  _passwordController.text = value;
                },
              ),
              RoundedButton(
                text: signupState is AsyncLoading ? "Signing Up..." : "Sign Up",
                press: signupState is AsyncLoading
                    ? () {}
                    : () {
                        ref.read(signupProvider.notifier).signUp(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              "user",
                            );
                      },
              ),
              if (signupState is AsyncError)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    signupState.error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (signupState is AsyncData && signupState.value!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    signupState.value!,
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAcountCheck(
                login: false,
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
              ),
              const OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                    iconColor: const Color(0xFF4267B2),
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                    iconColor: const Color(0xFF1DA1F2),
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                    iconColor: const Color(0xFFEA4335),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
