import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

import "package:citysewa_provider/api/api.dart" show ServiceManager;

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  int? providerId;
  bool isLoading = false;
  String? thumbnailPath;
  String photoLabel = "Upload a thumbnail";
  List<String> priceUnitList = ["hr", 'day', 'total'];
  String? selectedPriceUnit;

  final titleController = TextEditingController();
  final serviceTypeController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future getThumbnail() async {
    final XFile? photo = await getImage();
    if (photo != null) {
      setState(() {
        thumbnailPath = photo.path;
        photoLabel = photo.name;
      });
    }
  }

  void addService() async {
    setState(() {
      isLoading = true;
    });
    final title = titleController.text.toString();
    final serviceType = serviceTypeController.text.toString().trim();
    final description = descController.text.toString().trim();
    final price = priceController.text.toString().trim();

    if (title.isEmpty ||
        serviceType.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        selectedPriceUnit == null ||
        thumbnailPath == null) {
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
    } else {
      final integerPrice = int.tryParse(price);
      if (integerPrice == null || integerPrice < 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                "Price must be greater than or equal to Rs.100 and non-decimal.",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      } else {
        final serviceManager = ServiceManager();
        final response = await serviceManager.addService(
          providerId!,
          title,
          serviceType,
          description,
          integerPrice,
          selectedPriceUnit != "total"
              ? "/$selectedPriceUnit"
              : selectedPriceUnit!,
          thumbnailPath!,
        );

        if (response.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Center(
                child: Text(response.message, style: TextStyle(fontSize: 16)),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(response.message, style: TextStyle(fontSize: 16)),
              ),
            ),
          );
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    serviceTypeController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    providerId = args["providerId"];
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.deepOrange.shade200),
    );

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepOrange.shade400),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Add Service")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF3EE), Color(0xFFFDE7DE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: const Color(0xFFF3C2B3)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withAlpha(25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepOrange.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: inputDecoration.copyWith(
                    hintText: "Service Title",
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: serviceTypeController,
                  decoration: inputDecoration.copyWith(
                    hintText: "Service Type (Carpenter, Plumber, ...)",
                    prefixIcon: const Icon(Icons.category_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Description',
                    prefixIcon: Icon(Icons.description_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: inputDecoration.copyWith(
                          hintText: "Price",
                          prefixIcon: const Icon(Icons.currency_rupee_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenuFormField<String>(
                            enableSearch: false,
                            hintText: 'Category',
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Colors.white,
                              border: inputBorder,
                              enabledBorder: inputBorder,
                              focusedBorder: inputBorder.copyWith(
                                borderSide: BorderSide(
                                  color: Colors.deepOrange.shade400,
                                ),
                              ),
                            ),
                            width: 200,
                            dropdownMenuEntries: priceUnitList
                                .map(buildMenuItem)
                                .toList(),
                            onSelected: (value) {
                              setState(() => selectedPriceUnit = value!);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: getThumbnail,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.deepOrange.shade200),
                    foregroundColor: Colors.deepOrange.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  icon: const Icon(Icons.add_a_photo_rounded, size: 20),
                  label: Text(
                    photoLabel.length > 25
                        ? '${photoLabel.substring(0, 22)}...'
                        : photoLabel,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : addService,
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
                      "Add Service",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuEntry<String> buildMenuItem(String item) =>
      DropdownMenuEntry(value: item, label: item);
}
