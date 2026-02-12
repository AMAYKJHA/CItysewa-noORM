import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "package:citysewa/services/pref_service.dart" show PrefService;
import "package:citysewa/api/api_services.dart" show AuthAPI;

AuthAPI auth = AuthAPI();

class UpdateProfileScreen extends StatefulWidget {
  final VoidCallback onSave;
  UpdateProfileScreen({super.key, required this.onSave});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool isUpdating = false;
  String selectedGender = PrefService.getValue('gender') ?? "MALE";
  String? imagePath;
  String imageName = "";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void getPhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        imagePath = image.path;
        imageName = image.name;
      }
    });
  }

  void update(
    String firstName,
    String lastName,
    String gender,
    String? imagePath,
  ) async {
    setState(() {
      isUpdating = true;
    });
    try {
      final updatedDetails = await auth.updateProfile(
        firstName,
        lastName,
        gender,
        imagePath,
      );

      PrefService.setUserFirstName(updatedDetails['first_name']);
      PrefService.setUserLastName(updatedDetails['last_name']);
      PrefService.setUserGender(updatedDetails['gender']);
      if (updatedDetails['photo'] != null) {
        PrefService.setUserPhoto(updatedDetails['photo']!);
      }
      widget.onSave();
      Navigator.pop(context, true);
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
    setState(() {
      isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update your profile",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 35,
        backgroundColor: Colors.red,
      ),
      backgroundColor: Color(0xfffbf0f9),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 247, 230, 230),
                const Color.fromARGB(255, 245, 87, 87),
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("First Name"),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 40,
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Last Name"),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 40,
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text("Gender"),
                Container(
                  child: Row(
                    children: [
                      RadioMenuButton(
                        value: "MALE",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                        child: Text("male"),
                      ),
                      RadioMenuButton(
                        value: "FEMALE",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() => selectedGender = value!);
                        },
                        child: Text("female"),
                      ),
                      RadioMenuButton(
                        value: "OTHERS",
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                        child: Text("other"),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text("Photo"),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        getPhoto();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 1,
                        ),
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 229, 227),
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(150),
                              offset: Offset(0, 2),
                              blurRadius: 2,
                              blurStyle: BlurStyle.normal,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("Upload")],
                          ),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 180, maxHeight: 20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(imageName, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    update(
                      firstNameController.text.toString(),
                      lastNameController.text.toString(),
                      selectedGender,
                      imagePath,
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 81, 69),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(150),
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          blurStyle: BlurStyle.normal,
                        ),
                      ],
                    ),
                    child: Center(
                      child: isUpdating
                          ? CircularProgressIndicator(
                              color: Colors.black.withAlpha(180),
                            )
                          : Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
