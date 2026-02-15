import "package:flutter/material.dart";

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Future<void> refreshBookings() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookings")),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: [Text("Booking Screen")]),
        ),
        onRefresh: () {
          return refreshBookings();
        },
      ),
    );
  }
}
