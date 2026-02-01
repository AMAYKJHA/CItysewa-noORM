import "package:flutter/material.dart";

class ServicePage extends StatefulWidget {
  ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [Center(child: Text("Service Page"))]);
  }
}
