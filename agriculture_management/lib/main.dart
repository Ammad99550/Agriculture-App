import 'package:flutter/material.dart';
import 'package:agriculture_management/constants/theme.dart';
import 'package:agriculture_management/screens/auth_ui/welcome/welcome.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const Welcome(),
    );
  }
}
