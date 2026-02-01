import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";

import "package:citysewa_provider/session_manager.dart" show SessionManager;
import "package:citysewa_provider/api/models.dart" show User;

import "package:citysewa_provider/screens/pages/home_page.dart" show HomePage;
import "package:citysewa_provider/screens/pages/booking_page.dart"
    show BookingPage;
import "package:citysewa_provider/screens/pages/service_page.dart"
    show ServicePage;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userName = "Guest";
  int currentPageIndex = 0;

  List<Widget> pages = [HomePage(), BookingPage(), ServicePage()];
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    User? user = await SessionManager.getUser();
    if (user != null) {
      setState(() {
        userName = "${user.firstName} ${user.lastName}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        leading: ProfileIcon(),
        titleSpacing: 0,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        title: Text(
          userName,
          style: TextStyle(fontSize: 15, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: Colors.black, size: 32),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: pages[currentPageIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Colors.deepOrange,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.grey.withAlpha(60),
        items: <Widget>[
          Icon(Icons.home, size: 28),
          Icon(Icons.book_outlined, size: 28),
          Icon(Icons.miscellaneous_services_outlined, size: 28),
        ],
        onTap: (value) {
          if (value == currentPageIndex) return;
          setState(() {
            currentPageIndex = value;
          });
        },
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/profile');
        },
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('assets/images/test.png'),
        ),
      ),
    );
  }
}
