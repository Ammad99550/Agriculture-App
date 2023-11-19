import 'package:flutter/material.dart';
import 'package:agriculture_management/constants/theme.dart';
import 'package:agriculture_management/screens/auth_ui/welcome/welcome.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAhghybvpJf91dby0w18Lkkm_MVCvq-jZE",
        appId: "1:167517423961:android:b4643f11c4b99a0f446448",
        messagingSenderId: "167517423961",
        projectId: "agricultureapp-90cbf"),
  );
  //initilization of Firebase app

  // other Firebase service initialization

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
