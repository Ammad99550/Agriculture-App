// ignore_for_file: use_build_context_synchronously

import 'package:agriculture_management/firebase_helper/firebase_auth_services.dart';
import 'package:agriculture_management/screens/auth_ui/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agriculture_management/constants/routes.dart';
//import 'package:agriculture_management/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:agriculture_management/widgets/primary_button/primary_button.dart';
import 'package:agriculture_management/widgets/top_titles/top_titles.dart';

import '../../../constants/constants.dart';
//import '../../../firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool isShowPassword = true;
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();

  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    _name.dispose();
    _phone.dispose();
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
                  subtitle: "Welcome Back To E Commerce App",
                  title: "Create Account"),
              const SizedBox(
                height: 46.0,
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(
                    Icons.person_outline,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
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
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Phone",
                  prefixIcon: Icon(
                    Icons.phone_outlined,
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
                      child: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              PrimaryButton(
                title: "Create an account",
                onPressed: _signUp,
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Center(child: Text("I have already an account?")),
              const SizedBox(
                height: 12.0,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Login",
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

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _signUp() async {
    String username = _name.text;
    String email = _email.text;
    String phone = _phone.text;
    String password = _password.text;

    if (_name.text.isEmpty) {
      _showSnackbar("Please enter your name");
      return;
    }

    if (_email.text.isEmpty) {
      _showSnackbar("Please enter your email");
      return;
    }

    if (_phone.text.isEmpty) {
      _showSnackbar("Please enter your phone");
      return;
    }

    if (_password.text.isEmpty) {
      _showSnackbar("Please enter your password");
      return;
    }

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) &&
        _email.text.isNotEmpty) {
      _showSnackbar("Invalid email format");
      return;
    }

    // Validate password length
    if (password.length < 6 && _password.text.isNotEmpty) {
      _showSnackbar("Password must be at least 6 characters long");
      return;
    }

    // Show CircularProgressIndicator while signing up
    showLoadingDialog();

    try {
      // Attempt to sign up
      User? user = await _auth.signUpWithEmailandPassword(email, password);

      // Close the CircularProgressIndicator
      Navigator.of(context).pop();

      // Delay execution for a moment to ensure CircularProgressIndicator is dismissed
      await Future.delayed(Duration(milliseconds: 300));

      if (user != null) {
        print("Sign up successful");

        // Show success Snackbar
        _showSnackbar("User successfully signed up");

        // Navigate to the other screen after Snackbar is displayed
        Future.delayed(Duration(seconds: 2), () {
          FirebaseAuth.instance.signOut();
          Routes.instance.push(widget: const Login(), context: context);
        });
      } else {
        print("Sign up failed");
      }
    } catch (e) {
      // Close the CircularProgressIndicator
      Navigator.of(context).pop();

      // Check the specific exception for email already in use
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        _showSnackbar("Email is already in use");
      } else {
        // Check if the message contains the reCAPTCHA token warning
        String errorMessage = e.toString();
        if (errorMessage.contains("Creating user with empty reCAPTCHA token")) {
          _showSnackbar("Failed to create user. Please try again.");
        } else {
          _showSnackbar("Sign up failed");
        }
      }
    }
  }
}
