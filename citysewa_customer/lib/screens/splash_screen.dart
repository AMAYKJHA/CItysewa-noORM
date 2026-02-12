import "package:flutter/material.dart";
// import 'package:shared_preferences/shared_preferences.dart'
//     show SharedPreferences;
import 'dart:async';

import "package:citysewa/screens/home_screen.dart" show HomeScreen;
// import "package:citysewa/screens/login_screen.dart" show LoginScreen;

const appIcon = "lib/assets/app_icon.png";

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), changeScreen);
  }

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 60, backgroundImage: AssetImage(appIcon)),
            SizedBox(height: 10),
            Text(
              "Services at your home",
              style: TextStyle(
                fontSize: 17,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeScreen() async {
    // final pref = await SharedPreferences.getInstance();
    // bool isLoggedIn = pref.getBool('isLoggedIn') ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
