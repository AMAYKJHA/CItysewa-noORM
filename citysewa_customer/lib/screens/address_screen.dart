import "package:citysewa_customer/session_manager.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/api/api.dart" show AddressManager;
import "package:citysewa_customer/api/models.dart" show User, Address;
import "package:citysewa_customer/widgets/widgets.dart" show AddressTile;

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  User? user;
  List<Address> addressList = [];
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future loadUser() async {
    final user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        this.user = user;
      });
      refreshAddresses();
    }
  }

  Future<void> refreshAddresses() async {
    final manager = AddressManager();
    final response = await manager.listAddresses(user!.id);
    if (response.success) {
      setState(() {
        addressList = response.addressList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Addresses")),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: addressList.length,
            itemBuilder: (context, index) {
              return AddressTile(address: addressList[index]);
            },
          ),
        ),
        onRefresh: () {
          return refreshAddresses();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add-address',
            arguments: {"userId": user!.id},
          );
        },
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
