import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:carousel_slider/carousel_slider.dart";

const appIcon = "assets/images/test.png";

class AppLogo extends StatelessWidget {
  static const appLogo = 'assets/images/test.png';
  final double size;
  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(appLogo, width: 2 * size, height: 2 * size),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final bool isLoggedIn;
  final String? userPhoto;
  final VoidCallback? onClick;
  const ProfileIcon({
    super.key,
    this.isLoggedIn = false,
    this.userPhoto,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final photoIcon = Icon(
      Icons.face,
      shadows: [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.3),
          offset: Offset(0, 4),
          blurRadius: 5,
          spreadRadius: 0,
        ),
      ],
      size: 30,
      color: Colors.grey,
    );
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: onClick ?? () {},
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: CircleAvatar(
            radius: 20,
            child: Center(
              child: userPhoto != null
                  ? ClipOval(child: CachedNetworkImage(imageUrl: userPhoto!))
                  : photoIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, this.leading, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      leading: leading,
      titleSpacing: 8,
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      title: title,
      centerTitle: false,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.white.withAlpha(25)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

class ServiceSearchBar extends StatelessWidget {
  const ServiceSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/search');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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

class Carousel extends StatelessWidget {
  final List itemList;
  final List<Widget> items;
  Carousel({super.key, required this.itemList})
    : items = itemList.map((image) {
        return Card(
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(image, fit: BoxFit.fill),
          ),
        );
      }).toList();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
      ),
    );
  }
}

class ServiceCarousel extends StatelessWidget {
  final List itemList;
  final List<Widget> carouselItems;
  final BuildContext context;
  ServiceCarousel({super.key, required this.context, required this.itemList})
    : carouselItems = itemList.map((item) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/service');
          },
          child: Card(
            elevation: 3,
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item["thumbnail"]["image"],
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      }).toList();

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: carouselItems,
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
      ),
    );
  }
}
