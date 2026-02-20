import "dart:math";
import "package:intl/intl.dart";

class GetRandomNumber {
  static final random = Random();

  static double getDouble({double min = 0.0, double max = 1.0}) {
    return min + random.nextDouble() * (max - min);
  }

  static int getInt({int max = 10}) {
    return random.nextInt(max);
  }
}

class GetDateTime {
  static List<String> getFutureDate(int days) {
    final today = DateTime.now();
    final formatter = DateFormat("yyyy-MM-dd E dd MMM");

    return List.generate(days, (i) {
      final date = today.add(Duration(days: i));
      return formatter.format(date);
    });
  }
}
