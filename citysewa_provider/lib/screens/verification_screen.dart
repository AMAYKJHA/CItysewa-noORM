import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import 'package:citysewa_provider/api/api.dart' show AuthService;
import 'package:citysewa_provider/api/models.dart' show User;
import 'package:citysewa_provider/session_manager.dart' show SessionManager;

final auth = AuthService();

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future loadUser() async {
    final userLoaded = await SessionManager.getUser();
    if (userLoaded != null) {
      setState(() {
        user = userLoaded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(children: [VerificationForm(user)]),
      ),
    );
  }
}

class VerificationForm extends StatefulWidget {
  final User? user;
  const VerificationForm(this.user, {super.key});

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {
  bool isLoading = false;
  String? photoPath;
  String? docPath;
  String photoLabel = "Upload your photo";
  String docLabel = "Upload document";
  List<String> documentType = [
    'Citizenship',
    'Driving Liscense',
    'Voter ID',
    'National ID',
  ];
  String? selectedDocumentType;
  TextEditingController phoneController = TextEditingController();
  TextEditingController docNoController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    docNoController.dispose();
    super.dispose();
  }

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future getPhoto() async {
    final XFile? photo = await getImage();
    if (photo != null) {
      setState(() {
        photoPath = photo.path;
        photoLabel = photo.name;
      });
    }
  }

  Future getDoc() async {
    final XFile? doc = await getImage();
    if (doc != null) {
      setState(() {
        docPath = doc.path;
        docLabel = doc.name;
      });
    }
  }

  Future<void> submitForm() async {
    setState(() {
      isLoading = true;
    });
    final phoneNumber = phoneController.text.toString();
    final docNumber = docNoController.text.toString();
    final docType = selectedDocumentType;
    if (phoneNumber.isEmpty ||
        docNumber.isEmpty ||
        docType == null ||
        photoPath == null ||
        docPath == null) {
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
      final result = await auth.verifyProvider(
        widget.user!.id,
        phoneNumber,
        docNumber,
        docType,
        photoPath!,
        docPath!,
      );
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Center(child: Text(result.message)),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Center(child: Text(result.message))));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3EE), Color(0xFFFDE7DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFF3C2B3)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withAlpha(25),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Verify yourself",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.deepOrange.shade800,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration.copyWith(
              hintText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone_rounded),
            ),
          ),
          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              return DropdownMenuFormField<String>(
                enableSearch: false,
                hintText: 'Select a document type',
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
                dropdownMenuEntries: documentType.map(buildMenuItem).toList(),
                onSelected: (value) {
                  setState(() => selectedDocumentType = value!);
                },
              );
            },
          ),
          const SizedBox(height: 14),

          TextField(
            controller: docNoController,
            decoration: inputDecoration.copyWith(
              hintText: 'Document number',
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: getPhoto,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.deepOrange.shade200),
                  foregroundColor: Colors.deepOrange.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.add_a_photo_rounded, size: 20),
                label: Text(
                  photoLabel.length > 18
                      ? '${photoLabel.substring(0, 15)}...'
                      : photoLabel,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              OutlinedButton.icon(
                onPressed: getDoc,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.deepOrange.shade200),
                  foregroundColor: Colors.deepOrange.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.document_scanner, size: 20),
                label: Text(
                  docLabel.length > 18
                      ? '${docLabel.substring(0, 15)}...'
                      : docLabel,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isLoading ? null : submitForm,
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
                      "Submit",
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
