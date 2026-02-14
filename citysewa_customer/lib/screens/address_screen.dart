import "package:flutter/material.dart";

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Future<void> refreshAddresses() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: [Text("Address Screen")]),
        ),
        onRefresh: () {
          return refreshAddresses();
        },
      ),
    );
  }
}
