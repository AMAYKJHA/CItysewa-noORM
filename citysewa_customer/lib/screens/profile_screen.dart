import 'package:flutter/material.dart';

import 'package:citysewa_customer/api/api.dart' show AuthService;
import 'package:citysewa_customer/api/models.dart' show User;
import 'package:citysewa_customer/session_manager.dart' show SessionManager;
import 'package:citysewa_customer/widgets/widgets.dart'
    show VerifyYourselfBanner;

AuthService auth = AuthService();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Header(user),
            if (!user!.verified) ...[
              SizedBox(height: 20),
              VerifyYourselfBanner(),
            ],
            SizedBox(height: 24),
            SettingsContainer(),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final User? user;
  const Header(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    final userName = user != null
        ? "${user!.firstName} ${user!.lastName}"
        : "Guest";

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3EE), Color(0xFFFDE7DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: BoxBorder.all(color: const Color(0xFFF3C2B3)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(
              user!.photo ?? 'assets/images/test.png',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (user!.verified)
                      const Icon(
                        Icons.verified_rounded,
                        size: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Carpenter",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                if (!user!.verified) ...[
                  const SizedBox(height: 4),
                  const Text(
                    "Verification pending",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsContainer extends StatelessWidget {
  const SettingsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              "Settings",
              style: TextStyle(
                color: Colors.deepOrange.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          SettingTab("Account", "/account_settings"),
          SettingTab("Address", "/address_settings"),
          SettingTab("Profile", "/profile_settings"),
          SettingTab("Payment", "/payment_settings"),
        ],
      ),
    );
  }
}

class SettingTab extends StatelessWidget {
  final String name;
  final String path;
  const SettingTab(this.name, this.path, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.deepOrange.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
