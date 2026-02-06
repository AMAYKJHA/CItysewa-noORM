import "package:flutter/material.dart";

import "package:citysewa_provider/api/models.dart" show Service;
import "package:citysewa_provider/widgets/widgets.dart"
    show VerifyYourselfBanner;

class ServicePage extends StatefulWidget {
  final bool verified;
  final List<Service> serviceList;
  const ServicePage({
    super.key,
    this.verified = false,
    this.serviceList = const [],
  });

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.verified)
          Center(child: Text("Service Page"))
        else
          Align(alignment: Alignment.topCenter, child: VerifyYourselfBanner()),
      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final Service service;
  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
