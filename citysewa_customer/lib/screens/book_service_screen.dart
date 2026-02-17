import "package:flutter/material.dart";

import "package:citysewa_customer/utils/utils.dart" show GetDateTime;
import "package:citysewa_customer/session_manager.dart" show SessionManager;
import "package:citysewa_customer/api/api.dart"
    show BookingManager, AddressManager;
import "package:citysewa_customer/api/models.dart"
    show User, Service, Booking, Address;

class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  User? user;
  List<String> dateList = [];
  Service? service;
  String? selectedDate;
  String? selectedTime;
  List<Address> addressList = [];
  Address? selectedAddress;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadState();
  }

  Future loadState() async {
    User? userLoaded = await SessionManager.getUser();
    if (userLoaded != null) {
      setState(() {
        user = userLoaded;
        dateList = GetDateTime.getFutureDate(7);
        selectedDate = dateList[1].split(' ')[0];
      });
    }

    final manager = AddressManager();
    final response = await manager.listAddresses(user!.id);

    if (response.success) {
      setState(() {
        addressList = response.addressList;
      });
    }
  }

  Future confirmBooking() async {
    print("1.here" * 10);
    setState(() {
      isLoading = true;
    });
    print("2.here" * 10);
    final serviceId = service?.id;
    final customerId = user?.id;
    final addressId = selectedAddress?.id;

    print("3.here" * 10);
    if (serviceId == null ||
        customerId == null ||
        addressId == null ||
        selectedDate == null ||
        selectedTime == null) {
      print("4.here" * 10);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("Make sure you entered all fields correctly."),
          ),
        ),
      );
    } else {
      print("5.here" * 10);
      final booking = Booking(
        serviceId: serviceId,
        customerId: customerId,
        addressId: addressId,
        bookingDate: selectedDate!,
        bookingTime: selectedTime!,
      );

      print("6.here" * 10);
      try {
        print("7.here" * 10);
        final manager = BookingManager();
        final response = await manager.createBooking(booking);

        print("8.here" * 10);
        if (response.success) {
          print("9.here" * 10);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Center(child: Text(response.message)),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          print("10.here" * 10);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text(response.message))),
          );
        }
      } catch (e) {
        print("6.here" * 10);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text("Something went wrong. Please try again."),
            ),
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    Map<String, dynamic> args = {};
    if (route?.settings.arguments is Map<String, dynamic>) {
      args = route?.settings.arguments as Map<String, dynamic>;
    }
    service = args["service"];
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.deepOrange.shade200),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Bookings")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            ServiceTile(service: service!),
            const SizedBox(height: 18),
            Text("Pick a date"),
            Wrap(
              children: [
                ...dateList.map(
                  (date) => RenderDate(
                    date: date,
                    onClick: () {
                      setState(() {
                        selectedDate = date.split(' ')[0];
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
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      "Select time",
                      style: TextStyle(color: Colors.white),
                    ),
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
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenuFormField<Address>(
                  enableSearch: false,
                  hintText: 'Select an address',
                  width: double.infinity,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: BorderSide(color: Colors.deepOrange.shade400),
                    ),
                  ),
                  menuStyle: MenuStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(constraints.maxWidth, 0),
                    ),
                    maximumSize: WidgetStateProperty.all(
                      Size(constraints.maxWidth, 400),
                    ),
                  ),
                  dropdownMenuEntries: addressList.map(buildMenuItem).toList(),
                  onSelected: (value) {
                    setState(() => selectedAddress = value);
                  },
                );
              },
            ),

            const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            confirmBooking();
                          },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text("Confirm"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuEntry<Address> buildMenuItem(Address address) =>
      DropdownMenuEntry(
        value: address,
        label: "${address.location['area']} (${address.landmarks})",
      );

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked.format(context).split(' ')[0];
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
                "Rs.${service.price} ${service.priceUnit}",
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
            Text(splitDate[1], style: textStyle),
            Text("${splitDate[2]} ${splitDate[3]}", style: textStyle),
          ],
        ),
      ),
    );
  }
}
