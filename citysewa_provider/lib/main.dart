import 'package:flutter/material.dart';

import 'package:citysewa_provider/screens/splash_screen.dart' show SplashScreen;
import 'package:citysewa_provider/screens/login_screen.dart' show LoginScreen;
import 'package:citysewa_provider/screens/main_screen.dart' show MainScreen;
import 'package:citysewa_provider/screens/otp_screen.dart' show OTPScreen;
import 'package:citysewa_provider/screens/signup_screen.dart' show SignupScreen;
import 'package:citysewa_provider/screens/profile_screen.dart'
    show ProfileScreen;
import 'package:citysewa_provider/screens/verification_screen.dart'
    show VerificationScreen;
import 'package:citysewa_provider/screens/add_service_screen.dart'
    show AddServiceScreen;

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Citysewa Provider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        fontFamily: 'Inter',
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xfffffefe),
          hoverColor: Color(0xfffffefe),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black45),
            borderRadius: BorderRadius.circular(10),
          ),
          focusColor: Colors.red,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepOrange,
            minimumSize: Size.fromHeight(50),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepOrange,
            minimumSize: Size.fromHeight(50),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.deepOrange,
          contentTextStyle: TextStyle(fontSize: 14, color: Colors.white),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/otp': (context) => OTPScreen(),
        '/register': (context) => SignupScreen(),
        '/profile': (context) => ProfileScreen(),
        '/verify': (context) => VerificationScreen(),
        '/add-service': (context) => AddServiceScreen(),
      },
    );
  }
}
