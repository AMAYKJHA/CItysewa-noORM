import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:carousel_slider/carousel_slider.dart";

import "package:citysewa_customer/api/models.dart"
    show Service, Address, Booking;

const appIcon = "assets/images/test.png";
const defaultProfileImage = "assets/images/avatar.png";

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(appIcon, width: 2 * size, height: 2 * size),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final String? userPhoto;
  final VoidCallback? onClick;
  final double radius;
  const ProfileIcon({
    super.key,
    this.userPhoto,
    this.onClick,
    this.radius = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onClick,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: Colors.transparent,
          backgroundImage: userPhoto != null
              ? CachedNetworkImageProvider(userPhoto!)
              : AssetImage(defaultProfileImage) as ImageProvider,
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

class ServiceTile extends StatelessWidget {
  final Service service;
  final double rating;

  const ServiceTile({super.key, required this.service, required this.rating});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/service',
          arguments: {"serviceId": service.id},
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
            SizedBox(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: service.thumbnail != null
                      ? Image.network(
                          service.thumbnail!,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 60,
                        )
                      : Image.asset(
                          'assets/images/test.png',
                          fit: BoxFit.cover,
                          width: 90,
                          height: 60,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  service.title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      service.providerName,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 134, 134, 134),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color.fromARGB(255, 134, 134, 134),
                      ),
                    ),
                    Icon(Icons.star, color: Colors.amber, size: 15),
                  ],
                ),
                Text(
                  "Rs.${service.price} ${service.priceUnit}",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookingTile extends StatelessWidget {
  final Booking booking;
  const BookingTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: Offset(0, 3),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  booking.bookingDate,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  booking.bookingTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      booking.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 134, 134, 134),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final Address address;
  const AddressTile({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: Offset(0, 3),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  address.landmarks,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${address.location["area"]}",
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 134, 134, 134),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      address.location["city"],
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 134, 134, 134),
                      ),
                    ),
                    Text(
                      " (${address.location["district"]["name"]})",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
