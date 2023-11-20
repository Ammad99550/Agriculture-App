// ignore_for_file: use_build_context_synchronously

import 'package:agriculture_management/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:agriculture_management/constants/constants.dart';
import 'package:agriculture_management/constants/routes.dart';
import 'package:agriculture_management/firebase_helper/firebase_auth_services.dart';
import 'package:agriculture_management/screens/auth_ui/sign_up/sign_up.dart';
import 'package:agriculture_management/widgets/primary_button/primary_button.dart';
import 'package:agriculture_management/widgets/top_titles/top_titles.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isShowPassword = true;

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitles(
                  subtitle: "Welcome Back To Agricultural App", title: "Login"),
              const SizedBox(
                height: 46.0,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: _password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(
                    Icons.password_sharp,
                  ),
                  suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              PrimaryButton(
                title: "Login",
                onPressed: _signIn,
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Center(child: Text("Don't have an account?")),
              const SizedBox(
                height: 12.0,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Routes.instance
                        .push(widget: const SignUp(), context: context);
                  },
                  child: Text(
                    "Create an account",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCircularProgress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _signIn() async {
    String email = _email.text;
    String password = _password.text;

    try {
      // Show circular progress indicator
      _showCircularProgress();

      User? user = await _auth.signInWithEmailandPassword(email, password);

      if (user != null) {
        print("Login successful");

        // Delay for a few seconds before hiding the progress indicator
        await Future.delayed(Duration(seconds: 2));

        // Hide the circular progress indicator
        Navigator.of(context).pop();

        // Uncomment the navigation part if needed
        Routes.instance.pushAndRemoveUntil(
            widget: const CustomBottomBar(), context: context);
      } else {
        print("Login failed");
        _showSnackBar("Incorrect email or password");
      }
    } catch (e) {
      print("Error during login: $e");
      _showSnackBar("An error occurred. Please try again.");

      // Hide the circular progress indicator in case of an error
      Navigator.of(context).pop();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
