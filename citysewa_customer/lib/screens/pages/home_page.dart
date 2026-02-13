import "package:flutter/material.dart";

import "package:citysewa_customer/api/models.dart" show BookingStats;

class HomePage extends StatefulWidget {
  final bool verified;
  final BookingStats bookingStats;
  const HomePage({
    super.key,
    this.verified = false,
    required this.bookingStats,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [BookingSection(bookingStats: widget.bookingStats)],
    );
  }
}

class BookingSection extends StatefulWidget {
  final BookingStats bookingStats;
  const BookingSection({super.key, required this.bookingStats});

  @override
  State<BookingSection> createState() => _BookingSectionState();
}

class _BookingSectionState extends State<BookingSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3EE), Color(0xFFFDE7DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFF3C2B3)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bookings",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            spacing: 4,
            children: [
              Flexible(
                child: BookingCard(
                  title: "Completed",
                  value: widget.bookingStats.completed,
                  titleIcon: Icons.verified_rounded,
                ),
              ),

              Flexible(
                child: BookingCard(
                  title: "Pending",
                  value: widget.bookingStats.pending,
                  titleIcon: Icons.hourglass_top_rounded,
                ),
              ),

              Flexible(
                child: BookingCard(
                  title: "Cancelled",
                  value: widget.bookingStats.cancelled,
                  titleIcon: Icons.cancel_presentation_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData titleIcon;
  const BookingCard({
    super.key,
    required this.title,
    required this.value,
    required this.titleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(5),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(titleIcon, size: 16, color: Colors.grey),
              ],
            ),
            Text(
              "$value",
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
