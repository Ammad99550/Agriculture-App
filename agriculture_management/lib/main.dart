import 'package:agriculture_management/provider/app_provider.dart';
import 'package:agriculture_management/screens/custom_bottom_bar/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:agriculture_management/constants/theme.dart';
import 'package:agriculture_management/firebase_helper/firebase_auth_services.dart';

import 'package:agriculture_management/screens/auth_ui/welcome/welcome.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";

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
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Farm App',
        theme: themeData,
        home: StreamBuilder(
          stream: FirebaseAuthHelper.instance.getAuthChange,
          builder: (context, snapshot) {
            // if (snapshot.hasData) {
            //   return const CustomBottomBar();
            // }
            return const Welcome();
          },
        ),
      ),
    );
  }
}
