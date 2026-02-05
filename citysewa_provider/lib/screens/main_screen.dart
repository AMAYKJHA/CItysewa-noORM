import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";

import "package:citysewa_provider/api/api.dart" show AuthService;
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
  User? user;
  String userName = "Guest";
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final auth = AuthService();
    final userLoaded = await auth.getProvider(user!.id);
    if (userLoaded != null) {
      await SessionManager.saveUser(userLoaded);
      final newUser = await SessionManager.getUser();
      setState(() {
        user = newUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(verified: user!.verified),
      BookingPage(verified: user!.verified),
      ServicePage(verified: user!.verified),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        leading: ProfileIcon(),
        titleSpacing: 0,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        title: Text(
          "${user!.firstName} ${user!.lastName}",
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
      floatingActionButton: Visibility(
        visible: currentPageIndex == 2,
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          shape: CircleBorder(),
          onPressed: () {
            print("clicked");
          },
          child: Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: pages[currentPageIndex],
        ),
        onRefresh: () {
          return fetchUser();
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Colors.deepOrange,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.deepOrange, //Colors.grey.withAlpha(60),

        items: <Widget>[
          Icon(Icons.home, size: 28, color: Colors.white),
          Icon(Icons.book_outlined, size: 28, color: Colors.white),
          Icon(
            Icons.miscellaneous_services_outlined,
            size: 28,
            color: Colors.white,
          ),
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
