import "dart:math";

class GetRandomNumber {
  static final random = Random();

  static double getDouble({double min = 0.0, double max = 1.0}) {
    return min + random.nextDouble() * (max - min);
  }

  static int getInt({int max = 10}) {
    return random.nextInt(max);
  }
}
