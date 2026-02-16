import "package:flutter/material.dart";

import "package:citysewa_customer/utils/utils.dart" show GetDateTime;
import "package:citysewa_customer/session_manager.dart" show SessionManager;
import "package:citysewa_customer/api/api.dart"
    show BookingManager, AddressManager;
import "package:citysewa_customer/api/models.dart" show User, Service, Booking;

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  User? user;
  List<Booking> bookingList = [];
  List<String> dateList = [];
  String? selectedDate;
  String? selectedTime;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    User? user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        this.user = user;
        dateList = GetDateTime.getFutureDate(7);
        selectedDate = dateList[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final service = args["service"];

    return Scaffold(
      appBar: AppBar(title: Text("Bookings")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            ServiceTile(service: service),
            const SizedBox(height: 18),
            Text("Pick a date"),
            Wrap(
              children: [
                ...dateList.map(
                  (date) => RenderDate(
                    date: date,
                    onClick: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("Selected date: "),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(selectedDate!),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                InkWell(
                  onTap: () => pickTime(context),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text("Select time"),
                  ),
                ),
                if (selectedTime != null)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(selectedTime!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked.format(context);
      });
    }
  }
}

class ServiceTile extends StatelessWidget {
  final Service service;

  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          SizedBox(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: service.thumbnail != null
                    ? Image.network(
                        service.thumbnail!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 60,
                      )
                    : Image.asset(
                        'assets/images/test.png',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 60,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                service.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    service.providerName,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 134, 134, 134),
                    ),
                  ),
                ],
              ),
              Text(
                "Rs.${service.price} /${service.priceUnit}",
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RenderDate extends StatelessWidget {
  final String date;
  final VoidCallback? onClick;
  const RenderDate({super.key, required this.date, this.onClick});

  @override
  Widget build(BuildContext context) {
    final splitDate = date.split(' ');
    final textStyle = TextStyle(color: Colors.white);
    return InkWell(
      onTap: onClick ?? () {},
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(splitDate[0], style: textStyle),
            Text("${splitDate[1]} ${splitDate[2]}", style: textStyle),
          ],
        ),
      ),
    );
  }
}
