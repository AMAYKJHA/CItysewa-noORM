import "package:citysewa_customer/session_manager.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/api/api.dart" show AddressManager;
import "package:citysewa_customer/api/models.dart" show User, Address;
import "package:http/http.dart";

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  User? user;
  bool isLoading = false;
  final List<String> districts = ['Kathmandu', 'Lalitpur', 'Bhaktapur'];
  String selectedDistrict = 'Kathmandu';
  final cityController = TextEditingController();
  final wardController = TextEditingController();
  final areaController = TextEditingController();
  final landmarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    User? user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        this.user = user;
      });
    }
  }

  Future addAddress() async {
    setState(() {
      isLoading = true;
    });
    final city = cityController.text.toString();
    final ward = wardController.text.toString();
    final area = areaController.text.toString();
    final landmarks = landmarksController.text.toString();
    if (city.isEmpty || ward.isEmpty || area.isEmpty || landmarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              "Please make sure all fields are filled out correctly.",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      final integerWard = int.tryParse(ward);
      if (integerWard == null || integerWard < 1 || integerWard > 35) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                "Ward must be between 1 and 35.",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      } else {
        final manager = AddressManager();
        final response = await manager.addAddress(
          user!.id,
          districts.indexOf(selectedDistrict) + 1,
          city,
          integerWard,
          area,
          landmarks,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: response.success
                ? Colors.green
                : Colors.deepOrange,
            content: Text(response.message),
          ),
        );
        if (response.success) Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong. Please try again.")),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.deepOrange.shade200),
    );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: Colors.deepOrange.shade400),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Add a new address")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenuFormField<String>(
                  enableSearch: false,
                  hintText: 'District',
                  width: double.infinity,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder.copyWith(
                      borderSide: BorderSide(color: Colors.deepOrange.shade400),
                    ),
                  ),
                  menuStyle: MenuStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(constraints.maxWidth, 0),
                    ),
                    maximumSize: WidgetStateProperty.all(
                      Size(constraints.maxWidth, 400),
                    ),
                  ),
                  dropdownMenuEntries: districts.map(buildMenuItem).toList(),
                  onSelected: (value) {
                    setState(() => selectedDistrict = value!);
                  },
                );
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: cityController,
              keyboardType: TextInputType.name,
              decoration: inputDecoration.copyWith(
                hintText: 'City',
                prefixIcon: const Icon(Icons.location_city_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: wardController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration.copyWith(
                hintText: 'Ward',
                prefixIcon: const Icon(Icons.warehouse_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: areaController,
              keyboardType: TextInputType.name,
              decoration: inputDecoration.copyWith(
                hintText: 'Area or street',
                prefixIcon: const Icon(Icons.streetview_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: landmarksController,
              keyboardType: TextInputType.name,
              decoration: inputDecoration.copyWith(
                hintText: 'Landmarks',
                prefixIcon: const Icon(Icons.landscape_rounded),
              ),
            ),

            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading ? null : addAddress,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  disabledBackgroundColor: Colors.deepOrange.withAlpha(150),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuEntry<String> buildMenuItem(String item) =>
      DropdownMenuEntry(value: item, label: item);
}
