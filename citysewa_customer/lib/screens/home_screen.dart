import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

import "package:citysewa/services/pref_service.dart" show PrefService;
import "package:citysewa/screens/profile_screen.dart" show ProfileScreen;
import "package:citysewa/screens/login_screen.dart" show LoginScreen;
import "package:citysewa/screens/notification_screen.dart"
    show NotificationScreen;
import "package:citysewa/screens/search_screen.dart" show SearchScreen;
import "package:citysewa/screens/service_screen.dart" show ServiceScreen;
import "package:citysewa/api/api_services.dart" show ServiceAPI;
import "package:citysewa/screens/widgets.dart" show ServiceCarousel;
// import "package:citysewa/screens/constants.dart";

ServiceAPI service = ServiceAPI();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List featuredService = [];
  Future<List?> getServiceCarousel() async {
    try {
      final result = await service.serviceCarousel();
      return result['results'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List?> getFeaturedService() async {
    try {
      final result = await service.featuredService();
      return result['results'];
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.red),
      backgroundColor: Color(0xfffbf0f9),
      body: Column(
        children: [
          Header(),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  SearchBar(),
                  const SizedBox(height: 15),
                  FutureBuilder(
                    future: getServiceCarousel(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          return ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ServiceCarousel(
                              context: context,
                              itemList: snapshot.data!,
                            ),
                          );
                        }
                      }
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
                  FutureBuilder(
                    future: getFeaturedService(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final itemList = snapshot.data!;
                        return SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: itemList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ServiceScreen(
                                        serviceId: itemList[index]["service"],
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      itemList[index]["thumbnail"]["image"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return SizedBox(width: 0, height: 0);
                    },
                  ),
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
          ),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  Header({super.key});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String userFirstName = "Guest";
  String? userPhoto;
  bool isLoggedIn = false;
  Icon photoIcon = Icon(
    Icons.face,
    shadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        offset: Offset(0, 4),
        blurRadius: 5,
        spreadRadius: 0,
      ),
    ],
    size: 30,
    color: const Color.fromARGB(255, 239, 62, 50),
  );
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    isLoggedIn = PrefService.getValue("isLoggedIn") ?? false;
    if (isLoggedIn) {
      setState(() {
        userFirstName = PrefService.getValue('firstName') ?? userFirstName;
        userPhoto = PrefService.getValue('photo');
        if (userPhoto == null && PrefService.getValue('gender') == "FEMALE") {
          photoIcon = Icon(
            Icons.face_4,
            shadows: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset(0, 4),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
            size: 30,
            color: const Color.fromARGB(255, 239, 62, 50),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isLoggedIn
                          ? ProfileScreen(setHomeScreen: _loadUserData)
                          : LoginScreen(afterLogin: _loadUserData),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    child: userPhoto != null
                        ? ClipOval(
                            child: CachedNetworkImage(imageUrl: userPhoto!),
                          )
                        : photoIcon,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hi,",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    userFirstName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(Icons.notifications, size: 28, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0, 4),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: const Color.fromARGB(255, 115, 115, 115)),
            SizedBox(width: 10),
            Text(
              "Search for services",
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 115, 115, 115),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
