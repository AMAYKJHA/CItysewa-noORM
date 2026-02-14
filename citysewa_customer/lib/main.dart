import 'package:flutter/material.dart';

import "package:citysewa_customer/screens/splash_screen.dart" show SplashScreen;
import 'package:citysewa_customer/screens/login_screen.dart' show LoginScreen;
import 'package:citysewa_customer/screens/home_screen.dart' show HomeScreen;
import 'package:citysewa_customer/screens/signup_screen.dart' show SignupScreen;
import 'package:citysewa_customer/screens/search_screen.dart' show SearchScreen;
import 'package:citysewa_customer/screens/booking_screen.dart'
    show BookingScreen;
import 'package:citysewa_customer/screens/address_screen.dart'
    show AddressScreen;
import 'package:citysewa_customer/screens/service_screen.dart'
    show ServiceScreen;

import 'package:citysewa_customer/screens/profile_screen.dart'
    show ProfileScreen;

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Citysewa Customer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        fontFamily: 'Inter',
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          toolbarHeight: 5,
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
        '/home': (context) => HomeScreen(),
        '/register': (context) => SignupScreen(),
        '/profile': (context) => ProfileScreen(),
        '/search': (context) => SearchScreen(),
        '/service': (context) => ServiceScreen(serviceId: 8),
        '/booking': (context) => BookingScreen(),
        '/address': (context) => AddressScreen(),
      },
    );
  }
}
