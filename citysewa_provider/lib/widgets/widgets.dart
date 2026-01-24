import "package:flutter/material.dart";

class AppLogo extends StatelessWidget {
  static const appLogo = 'assets/images/test.png';
  final double size;
  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(appLogo, width: 2 * size, height: 2 * size),
    );
  }
}
