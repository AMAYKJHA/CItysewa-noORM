import "package:flutter/material.dart";
import "dart:async";

import "package:citysewa_provider/widgets/widgets.dart" show AppLogo;
import "package:citysewa_provider/session_manager.dart" show SessionManager;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), checkLogin);
  }

  void checkLogin() async {
    final isLoggedIn = await SessionManager.getLogin();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [AppLogo(size: 60), Text("Local Service, Made Simple")],
        ),
      ),
    );
  }
}
