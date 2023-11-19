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

  void _signUp() async {
    String username = _name.text;
    String email = _email.text;
    String phone = _phone.text;
    String password = _password.text;

    User? user = await _auth.signUpWithEmailandPassword(email, password);

    if (user != null) {
      print("Sign up successful");
      FirebaseAuth.instance.signOut();
      Routes.instance.push(widget: const Login(), context: context);
    } else {
      print("Sign up failed");
    }
  }
}
