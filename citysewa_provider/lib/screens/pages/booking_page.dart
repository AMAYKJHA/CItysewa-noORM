import "package:flutter/material.dart";

import 'package:citysewa_provider/api/models.dart' show Booking;
import "package:citysewa_provider/widgets/widgets.dart"
    show VerifyYourselfBanner;

class BookingPage extends StatefulWidget {
  final bool verified;
  final List<Booking> bookingList;
  const BookingPage({
    super.key,
    this.verified = false,
    this.bookingList = const [],
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<Widget> renderBookings() {
    List<Widget> renderedBookings = <Widget>[];

    for (Booking booking in widget.bookingList) {
      renderedBookings.add(BookingTile(booking: booking));
    }
    return renderedBookings;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.verified)
          ...renderBookings()
        else
          Align(alignment: Alignment.topCenter, child: VerifyYourselfBanner()),
      ],
    );
  }
}

class BookingTile extends StatelessWidget {
  final Booking booking;
  const BookingTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF3EE), Color(0xFFFDE7DE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFFF3C2B3)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.status,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.bookingDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.deepOrange.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.bookingTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
