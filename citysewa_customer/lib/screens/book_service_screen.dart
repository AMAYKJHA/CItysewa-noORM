import "package:flutter/material.dart";

import "package:citysewa_customer/session_manager.dart" show SessionManager;
import "package:citysewa_customer/api/api.dart" show BookingManager;
import "package:citysewa_customer/api/models.dart" show User, Booking;

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  User? user;
  List<Booking> bookingList = [];

  @override
  void initState() {
    super.initState();
    getUser();
    refreshBooking();
  }

  Future getUser() async {
    User? user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        this.user = user;
      });
    }
  }

  Future refreshBooking() async {
    final manager = BookingManager();
    final response = await manager.listBookings(user!.id);
    if (response.success) {
      setState(() {
        bookingList = response.bookingList!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final serviceId = args["serviceId"];

    return Scaffold(
      appBar: AppBar(title: Text("Bookings")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [Text("Service Booking Screen"), Text("$serviceId")],
        ),
      ),
    );
  }
}
