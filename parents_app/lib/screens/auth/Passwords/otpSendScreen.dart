import 'package:class_finder/screens/auth/Passwords/changePassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Screens/Login/components/rounded_input_text_field.dart';
import '../../../components/rounded_button.dart';
import '../../../providers/authProvider.dart';
import 'background.dart';
// import '../auth_provider.dart';
// import 'rounded_input_text_field.dart';
// import 'rounded_password_field.dart';

class OtpSendScreen extends ConsumerStatefulWidget {
  const OtpSendScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<OtpSendScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  // final TextEditingController _newPasswordController = TextEditingController();
  // final TextEditingController _confirmPasswordController =
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Change Password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Image.asset(
                "assets/images/password.png",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              if (authState.otp == null)
                RoundedInputTextField(
                  controller: _emailController,
                  hintText: "Your email",
                  onChanged: (value) {},
                  icon: Icons.email,
                ),
              if (authState.otp != null)
                RoundedInputTextField(
                  controller: _otpController,
                  hintText: "OTP",
                  onChanged: (value) {},
                  icon: Icons.lock,
                ),
              if (authState.isLoading)
                CircularProgressIndicator()
              else
                RoundedButton(
                  text: authState.otp == null ? "Send OTP" : "Verify OTP",
                  press: () async {
                    if (authState.otp == null &&
                        _emailController.text.isNotEmpty) {
                      await ref
                          .read(authProvider.notifier)
                          .sendOtp(_emailController.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter email")),
                      );
                    }
                    if (authState.successMessage != null &&
                        authState.otp != null &&
                        _otpController.text.isNotEmpty &&
                        _otpController.text == authState.otp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(authState.successMessage!)),
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangePasswordScreen(_emailController.text)));
                    }
                  },
                ),
              if (authState.errorMessage != null)
                Text(
                  authState.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
