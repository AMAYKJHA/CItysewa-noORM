import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";

import "package:citysewa_provider/api/api.dart"
    show AuthService, ServiceManager;
import "package:citysewa_provider/session_manager.dart" show SessionManager;
import "package:citysewa_provider/api/models.dart" show Service, User;

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
  int currentPageIndex = 0;
  List<Service> serviceList = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final userLoaded = await SessionManager.getUser();
    setState(() {
      user = userLoaded;
    });
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

  Future<void> fetchServices() async {
    final serviceManager = ServiceManager();
    final response = await serviceManager.listServices(user!.id);

    if (response.success) {
      setState(() {
        serviceList = response.serviceList!;
      });
    }
  }

  Future<void> fetchBookings() async {}

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(verified: user!.verified),
      BookingPage(verified: user!.verified),
      ServicePage(verified: user!.verified, serviceList: serviceList),
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        leading: ProfileIcon(),
        titleSpacing: 8,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        title: Row(
          children: [
            Flexible(
              child: Text(
                "${user!.firstName} ${user!.lastName}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (user!.verified) ...[
              const SizedBox(width: 6),
              const Icon(Icons.verified_rounded, size: 18, color: Colors.white),
            ],
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_rounded, color: Colors.white),
            splashRadius: 22,
            tooltip: 'Notification',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.white.withAlpha(25)),
        ),
      ),
      floatingActionButton: Visibility(
        visible: currentPageIndex == 2,
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          shape: CircleBorder(),
          onPressed: () {
            Navigator.pushNamed(context, '/add-service');
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
          if (!user!.verified || currentPageIndex == 0) {
            return fetchUser();
          } else if (currentPageIndex == 1) {
            return fetchBookings();
          } else {
            return fetchServices();
          }
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentPageIndex,
        height: 56,
        color: Colors.deepOrange,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.deepOrange.shade600,
        animationCurve: Curves.easeOutCubic,

        items: const <Widget>[
          Icon(Icons.home_rounded, size: 26, color: Colors.white),
          Icon(Icons.receipt_long_rounded, size: 26, color: Colors.white),
          Icon(Icons.handyman_rounded, size: 26, color: Colors.white),
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
