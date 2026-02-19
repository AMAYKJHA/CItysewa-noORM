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
    if (!mounted) return;
    if (userLoaded == null) return;

    final generatedDates = GetDateTime.getFutureDate(7);
    setState(() {
      user = userLoaded;
      dateList = generatedDates;
      selectedDate = generatedDates.isNotEmpty
          ? generatedDates.first.split(' ')[0]
          : null;
    });

    final manager = AddressManager();
    final response = await manager.listAddresses(userLoaded.id);
    if (!mounted) return;

    if (response.success) {
      setState(() {
        addressList = response.addressList;
      });
    }
  }

  Future confirmBooking() async {
    setState(() {
      isLoading = true;
    });
    final serviceId = service?.id;
    final customerId = user?.id;
    final addressId = selectedAddress?.id;

    if (serviceId == null ||
        customerId == null ||
        addressId == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text("Make sure you entered all fields correctly."),
          ),
        ),
      );
    } else {
      final booking = Booking(
        serviceId: serviceId,
        customerId: customerId,
        addressId: addressId,
        bookingDate: selectedDate!,
        bookingTime: selectedTime!,
      );

      try {
        final manager = BookingManager();
        final response = await manager.createBooking(booking);

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Center(child: Text(response.message)),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text(response.message))),
          );
        }
      } catch (e) {
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
    service = args["service"] is Service ? args["service"] as Service : null;

    if (service == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Book Service")),
        body: Center(child: Text("Unable to load selected service.")),
      );
    }

    if (user == null && dateList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Book Service")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade800,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.deepOrange.shade200),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Book Service")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            ServiceTile(service: service!),

            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Date", style: titleTextStyle),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...dateList.map(
                        (date) => RenderDate(
                          date: date,
                          isSelected: selectedDate == date.split(' ')[0],
                          onClick: () {
                            setState(() {
                              selectedDate = date.split(' ')[0];
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Select Time", style: titleTextStyle),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => pickTime(context),
                    icon: Icon(Icons.access_time, size: 20),
                    label: Text(selectedTime ?? "Choose Time"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delivery Address", style: titleTextStyle),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return DropdownMenuFormField<Address>(
                              hintText: 'Select an address',
                              width: constraints.maxWidth,
                              inputDecorationTheme: InputDecorationTheme(
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                border: inputBorder,
                                enabledBorder: inputBorder,
                                focusedBorder: inputBorder.copyWith(
                                  borderSide: BorderSide(
                                    color: Colors.deepOrange.shade400,
                                    width: 2,
                                  ),
                                ),
                              ),
                              menuStyle: MenuStyle(
                                minimumSize: WidgetStateProperty.all(
                                  Size(constraints.maxWidth, 0),
                                ),
                                maximumSize: WidgetStateProperty.all(
                                  Size(constraints.maxWidth, 300),
                                ),
                              ),
                              dropdownMenuEntries: addressList
                                  .map(buildMenuItem)
                                  .toList(),
                              onSelected: (value) {
                                setState(() => selectedAddress = value);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/add-address');
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: isLoading ? null : () => confirmBooking(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  disabledBackgroundColor: Colors.deepOrange.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        "Confirm Booking",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
        label: "${address.location['area'] ?? 'Area'} (${address.landmarks})",
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
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: service.thumbnail != null
                ? Image.network(
                    service.thumbnail!,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  )
                : Image.asset(
                    'assets/images/test.png',
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.store_outlined,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      service.providerName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Rs. ${service.price} ${service.priceUnit}",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RenderDate extends StatelessWidget {
  final String date;
  final bool isSelected;
  final VoidCallback? onClick;

  const RenderDate({
    super.key,
    required this.date,
    this.isSelected = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final splitDate = date.split(' ');
    final isActive = isSelected;

    return GestureDetector(
      onTap: onClick,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepOrange : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.deepOrange : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              splitDate[1],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "${splitDate[2]} ${splitDate[3]}",
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.white70 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
