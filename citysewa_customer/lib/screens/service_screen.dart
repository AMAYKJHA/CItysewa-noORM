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
      backgroundColor: Color(0xFFF5F5F5),
      body: FutureBuilder(
        future: getService(serviceId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(pinned: true, title: Text("Service")),
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.success) {
            final service = snapshot.data!.service;
            if (service == null) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(pinned: true, title: Text("Service")),
                  SliverFillRemaining(
                    child: Center(child: Text("Service not found")),
                  ),
                ],
              );
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: Colors.deepOrange,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        service.thumbnail != null
                            ? Image.network(
                                service.thumbnail!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/test.png',
                                fit: BoxFit.cover,
                              ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: Offset(0, -24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.store_outlined,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  service.providerName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepOrange.shade400,
                                    Colors.deepOrange.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Rs. ${service.price}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " ${service.priceUnit}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "About this service",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
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
                              child: Text(
                                service.description,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
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
                                children: [
                                  _buildFeatureRow(
                                    Icons.verified_outlined,
                                    "Verified Provider",
                                  ),
                                  Divider(height: 24),
                                  _buildFeatureRow(
                                    Icons.schedule_outlined,
                                    "Flexible Scheduling",
                                  ),
                                  Divider(height: 24),
                                  _buildFeatureRow(
                                    Icons.support_agent_outlined,
                                    "Customer Support",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar(pinned: true, title: Text("Service")),
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Something went wrong",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please try again later",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: FutureBuilder(
        future: getService(serviceId),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.success &&
              snapshot.data!.service != null) {
            final service = snapshot.data!.service!;
            return Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      if (isLoggedIn) {
                        Navigator.pushNamed(
                          context,
                          '/book-service',
                          arguments: {"service": service},
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text("Please login to book this service."),
                            ),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLoggedIn ? "Book Now" : "Login to Book",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepOrange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.deepOrange, size: 20),
        ),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
      ],
    );
  }
}
