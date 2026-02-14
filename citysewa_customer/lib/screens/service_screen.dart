import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";

import "package:citysewa/api/api_services.dart" show ServiceAPI;
import "package:citysewa/screens/widgets.dart" show Carousel;
import "package:citysewa/screens/booking_screen.dart" show BookingScreen;

const defaultProfileImage = "https://placehold.net/avatar-1.png";

ServiceAPI serviceAPI = ServiceAPI();

class ServiceScreen extends StatefulWidget {
  final int serviceId;
  ServiceScreen({super.key, required this.serviceId});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  Future getService(int serviceId) async {
    try {
      final result = await serviceAPI.retrieveService(serviceId);
      return result;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.red),
      backgroundColor: Color(0xfffbf0f9),
      body: SafeArea(
        child: FutureBuilder(
          future: getService(widget.serviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              final service = snapshot.data;
              List imgList = [];
              for (Map image in service['gallery']) {
                imgList.add(image['image']);
              }
              return Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: Carousel(itemList: imgList),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      service['title'],
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    Text(
                      "By ${service['provider']['first_name']} ${service['provider']['last_name']}",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Rs.${service['price']}${service['pricing_type']}",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Text("Description", style: TextStyle(fontSize: 17)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            offset: Offset(0, 4),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Html(
                        data: service['description'],
                        style: {"p": Style(fontSize: FontSize(14))},
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Center(
                                    child: Text(
                                      "Work in progress",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Book service",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Some problem occured",
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
