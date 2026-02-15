import "package:flutter/material.dart";

import "package:citysewa_customer/session_manager.dart" show SessionManager;
import "package:citysewa_customer/api/api.dart" show BookingManager;
import "package:citysewa_customer/api/models.dart" show User, Booking;
import "package:citysewa_customer/widgets/widgets.dart" show BookingTile;

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
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
    return Scaffold(
      appBar: AppBar(title: Text("Bookings")),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: bookingList.length,
            itemBuilder: (context, index) {
              return BookingTile(booking: bookingList[index]);
            },
          ),
        ),
        onRefresh: () {
          return refreshBooking();
        },
      ),
    );
  }
}
