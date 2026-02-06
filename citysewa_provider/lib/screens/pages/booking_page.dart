import "package:flutter/material.dart";

import "package:citysewa_provider/widgets/widgets.dart"
    show VerifyYourselfBanner;

class BookingPage extends StatefulWidget {
  final bool verified;
  const BookingPage({super.key, this.verified = false});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return !widget.verified
        ? Align(alignment: Alignment.topCenter, child: VerifyYourselfBanner())
        : ListView(children: [Center(child: Text("Booking Page"))]);
  }
}
