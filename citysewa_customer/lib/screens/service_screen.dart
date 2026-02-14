import "package:citysewa_customer/api/models.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/api/api.dart" show ServiceManager;

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  Future<ServiceResponse?> getService(int serviceId) async {
    try {
      final manager = ServiceManager();
      final serviceResponse = await manager.getService(serviceId);
      return serviceResponse;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Please try again.")),
      );
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final serviceId = args["serviceId"];
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.red),
      backgroundColor: Color(0xfffbf0f9),
      body: FutureBuilder(
        future: getService(serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.success) {
            final service = snapshot.data!.service;
            return Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  SizedBox(
                    height: 300,
                    child: ClipRRect(
                      child: service!.thumbnail != null
                          ? Image.network(service.thumbnail!)
                          : Image.asset('assets/images/test.png'),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    service.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  Text(
                    "By ${service.providerName}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                  ),
                  Text(
                    "Rs.${service.price} /${service.priceUnit}",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text("Description", style: TextStyle(fontSize: 17)),

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
                "Something went wrong. Please try again.",
                style: TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }
        },
      ),
    );
  }
}
