import "package:flutter/material.dart";

import "package:citysewa/services/pref_service.dart" show PrefService;
// import "package:citysewa/screens/login_screen.dart";
// import "package:citysewa/screens/home_screen.dart" show HomeScreen;
// import "package:citysewa/screens/profile_screen.dart";
import "screens/splash_screen.dart" show SplashScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
