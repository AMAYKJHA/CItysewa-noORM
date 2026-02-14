import "package:flutter/material.dart";
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
  final List<Widget> items;
  final BuildContext context;
  ServiceCarousel({super.key, required this.context, required this.itemList})
    : items = itemList.map((item) {
        return InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ServiceScreen(serviceId: item["service"]),
            //   ),
            // );
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
      items: items,
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
      ),
    );
  }
}
