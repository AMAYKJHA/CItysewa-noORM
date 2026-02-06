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
    return ListView(
      children: [
        if (widget.verified)
          Center(child: Text("Booking Page"))
        else
          Align(alignment: Alignment.topCenter, child: VerifyYourselfBanner()),
      ],
    );
  }
}
