import "package:flutter/material.dart";

class BookingPage extends StatefulWidget {
  BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [Center(child: Text("Booking Page"))]);
  }
}
