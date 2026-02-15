import "package:flutter/material.dart";

import "package:citysewa_customer/api/api.dart" show AddressManager;
import "package:citysewa_customer/api/models.dart" show User, Address;

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  User? user;
  List<Address> addressList = [];
  @override
  void initState() {
    super.initState();
  }

  Future addAddress() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new address")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: []),
      ),
    );
  }
}
