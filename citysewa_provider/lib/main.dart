import 'package:flutter/material.dart';

import 'package:citysewa_provider/screens/login_screen.dart' show LoginScreen;

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      // ),
      home: LoginScreen(),
    );
  }
}
