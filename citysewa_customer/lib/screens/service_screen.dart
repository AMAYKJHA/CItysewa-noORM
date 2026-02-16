import "package:citysewa_customer/api/models.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/api/api.dart" show ServiceManager;
import "package:citysewa_customer/session_manager.dart" show SessionManager;

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  bool isLoggedIn = false;
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
    checkLogin();
  }

  Future<void> checkLogin() async {
    final isLoggedIn = await SessionManager.getLogin();
    if (isLoggedIn) {
      setState(() {
        this.isLoggedIn = isLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    Map<String, dynamic> args = {};
    if (route?.settings.arguments is Map<String, dynamic>) {
      args = route?.settings.arguments as Map<String, dynamic>;
    }
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
                      borderRadius: BorderRadius.circular(5),
                      child: service!.thumbnail != null
                          ? Image.network(service.thumbnail!, fit: BoxFit.cover)
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
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: const Offset(0, 3),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      service.description ??
                          "Service from CitySewa at your home.",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLoggedIn) {
                              Navigator.pushNamed(
                                context,
                                '/book-service',
                                arguments: {"service": service},
                              );
                            } else {
                              Navigator.pushNamed(context, '/login');
                            }
                          },
                          child: Text("Book service"),
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
