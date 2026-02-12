import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

import "package:citysewa/services/pref_service.dart" show PrefService;
import "package:citysewa/screens/update_profile_screen.dart"
    show UpdateProfileScreen;

class ProfileScreen extends StatefulWidget {
  final VoidCallback setHomeScreen;
  ProfileScreen({super.key, required this.setHomeScreen});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

const defaultProfileImage = "https://placehold.net/avatar-1.png";

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ProfileHeader(setHomeScreen: widget.setHomeScreen),
              SizedBox(height: 10),
              Menus(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  final VoidCallback setHomeScreen;
  ProfileHeader({super.key, required this.setHomeScreen});

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late String userFirstName;
  late String userLastName;
  late String userGender;
  String? userPhoto;
  late String userCategory;
  Icon photoIcon = Icon(
    Icons.face,
    shadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        offset: Offset(0, 4),
        blurRadius: 5,
        spreadRadius: 0,
      ),
    ],
    size: 60,
    color: const Color.fromARGB(255, 252, 39, 95),
  );
  String userLocation = "Kathmandu";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    setState(() {
      userFirstName = PrefService.getValue('firstName') ?? "Guest";
      userLastName = PrefService.getValue('lastName') ?? "";
      userGender = PrefService.getValue('gender') ?? "MALE";
      userCategory = PrefService.getValue('category') ?? "BASIC";
      userPhoto = PrefService.getValue('photo');
      if (userPhoto == null && userGender == "FEMALE") {
        photoIcon = Icon(
          Icons.face_4,
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: Offset(0, 4),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
          size: 60,
          color: const Color.fromARGB(255, 252, 39, 95),
        );
      }
    });
  }

  void _onUpdate() {
    _loadUserData();
    widget.setHomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 76, 63),
        border: BoxBorder.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 40,
                  child: userPhoto != null
                      ? ClipOval(
                          child: CachedNetworkImage(imageUrl: userPhoto!),
                        )
                      : photoIcon,
                ),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$userFirstName $userLastName",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "Current plan: $userCategory",
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    userLocation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfileScreen(onSave: _onUpdate),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(255, 254, 218, 218),
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 20,
                color: const Color.fromARGB(255, 254, 218, 218),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Menus extends StatelessWidget {
  Menus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 247, 230, 230),
            const Color.fromARGB(255, 245, 87, 87),
          ],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
        ),
        border: BoxBorder.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Settings", style: TextStyle(color: Colors.grey)),
          TileButton(text: "Account settings", action: () {}),
          TileButton(text: "Booking History", action: () {}),
          TileButton(text: "App preferences", action: () {}),
          TileButton(text: "Upgrade to premium", action: () {}),
          Divider(),
          Text("Preferencs", style: TextStyle(color: Colors.grey)),
          TileButton(text: "Notifications", action: () {}),
          TileButton(text: "Language and region", action: () {}),
          TileButton(text: "Daily activity", action: () {}),
          Divider(),
          Text("Payments", style: TextStyle(color: Colors.grey)),
          TileButton(text: "Manage ewallet", action: () {}),
          TileButton(text: "Payment history", action: () {}),
          Divider(),
          Text("Others", style: TextStyle(color: Colors.grey)),
          TileButton(text: "Blocked providers", action: () {}),
          TileButton(text: "Submit complaints", action: () {}),
          TileButton(text: "Feedback", action: () {}),
        ],
      ),
    );
  }
}

class TileButton extends StatelessWidget {
  final String text;
  final VoidCallback action;
  TileButton({super.key, required this.text, required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Text(text, style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
