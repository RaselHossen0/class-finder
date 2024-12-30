import 'package:class_finder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/rounded_button.dart';
import '../../../providers/authProvider.dart';
import '../../Login/components/rounded_password_field.dart';
import 'background.dart';
// import '../auth_provider.dart';
// import 'rounded_input_text_field.dart';
// import 'rounded_password_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  final String email;
  ChangePasswordScreen(this.email, {Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(alignment: Alignment.topLeft, child: BackButton()),
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
              RoundedPasswordField(
                controller: _newPasswordController,
                hintText: "New Password",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                onChanged: (value) {},
              ),
              if (authState.isLoading)
                CircularProgressIndicator()
              else
                RoundedButton(
                  text: "Change Password",
                  press: () async {
                    if (_newPasswordController.text ==
                        _confirmPasswordController.text) {
                      await ref.read(authProvider.notifier).changePassword(
                          _confirmPasswordController.text, widget.email);
                      if (authState.successMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authState.successMessage!)),
                        );
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InitialScreen()),
                            (_) => false);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Passwords do not match")),
                      );
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
