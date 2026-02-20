import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";

import "package:citysewa_customer/session_manager.dart" show SessionManager;
import "package:citysewa_customer/api/models.dart" show User;
import "package:citysewa_customer/widgets/widgets.dart"
    show ProfileIcon, CustomAppBar, ServiceSearchBar;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  bool isLoggedIn = false;
  User? user;
  int currentPageIndex = 0;
  List featuredService = [];

  Future<List?> getServiceCarousel() async {
    return null;
  }

  Future<List?> getFeaturedService() async {
    return null;
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final isLoggedIn = await SessionManager.getLogin();
    if (isLoggedIn != this.isLoggedIn) {
      final user = await SessionManager.getUser();
      setState(() {
        this.isLoggedIn = true;
        this.user = user;
      });
    }
  }

  Future refreshHomePage() async {
    final user = await SessionManager.getUser();
    setState(() {
      isLoggedIn = true;
      this.user = user;
    });
  }

  void bottomNavigation(int value) {
    if (!isLoggedIn && (value == 1 || value == 2)) {
      goToLogin();
    } else if (value == 1) {
      Navigator.pushNamed(context, '/booking', arguments: {"user": user});
    } else if (value == 2) {
      Navigator.pushNamed(context, '/address', arguments: {"user": user});
    }
  }

  void goToLogin() {
    Navigator.pushNamed(
      context,
      '/login',
      arguments: {"afterLogin": refreshHomePage},
    );
  }

  void onProfileClick() {
    if (isLoggedIn) {
      Navigator.pushNamed(context, '/profile');
    } else {
      goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: ProfileIcon(onClick: onProfileClick, userPhoto: user?.photo),
        title: Row(
          children: [
            Flexible(
              child: Text(
                user == null ? "Guest" : "${user!.firstName} ${user!.lastName}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_rounded, color: Colors.white),
            splashRadius: 22,
            tooltip: 'Notification',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(height: 10),
              ServiceSearchBar(),
              FutureBuilder(
                future: getServiceCarousel(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {}
                  return SizedBox(width: 0, height: 0);
                },
              ),
              SizedBox(height: 10),
              Text(
                "Featured services",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 41, 41, 41),
                ),
              ),
              SizedBox(height: 5),
              // FutureBuilder(
              //   future: getFeaturedService(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData && snapshot.data != null) {
              //       final itemList = snapshot.data!;
              //       return SizedBox(
              //         height: 80,
              //         child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: itemList.length,
              //           itemBuilder: (context, index) {
              //             return InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => ServiceScreen(
              //                       serviceId: itemList[index]["service"],
              //                     ),
              //                   ),
              //                 );
              //               },
              //               child: Padding(
              //                 padding: EdgeInsets.only(right: 8),
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(5),
              //                   child: Image.network(
              //                     itemList[index]["thumbnail"]["image"],
              //                     fit: BoxFit.cover,
              //                   ),
              //                 ),
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     }
              //     return SizedBox(width: 0, height: 0);
              //   },
              // )
              SizedBox(height: 10),
              Text(
                "Popular services",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 41, 41, 41),
                ),
              ),
            ],
          ),
        ),
        onRefresh: () {
          return refreshHomePage();
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
          Icon(Icons.calendar_month_rounded, size: 26, color: Colors.white),
          Icon(Icons.place_rounded, size: 26, color: Colors.white),
        ],

        onTap: (value) {
          bottomNavigation(value);
        },
      ),
    );
  }
}
