import "package:flutter/material.dart";

import "package:citysewa_provider/widgets/widgets.dart"
    show VerifyYourselfBanner;

class ServicePage extends StatefulWidget {
  final bool verified;
  const ServicePage({super.key, this.verified = false});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return !widget.verified
        ? Align(alignment: Alignment.topCenter, child: VerifyYourselfBanner())
        : ListView(children: [Text("Service page")]);
  }
}
