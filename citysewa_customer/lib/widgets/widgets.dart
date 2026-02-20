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
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(context, '/search');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.search, color: Colors.deepOrange, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              "Search for services...",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            Spacer(),
            Icon(Icons.tune, color: Colors.grey.shade400, size: 20),
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
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
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
        autoPlayInterval: Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
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
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(context, '/service');
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item["thumbnail"]["image"],
                fit: BoxFit.cover,
                width: double.infinity,
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
        autoPlayInterval: Duration(seconds: 4),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 16 / 9,
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
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/service',
          arguments: {"serviceId": service.id},
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: service.thumbnail != null
                  ? Image.network(
                      service.thumbnail!,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.image, color: Colors.grey.shade400),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.store_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.providerName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Rs. ${service.price}/${service.priceUnit}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(booking.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.calendar_today_rounded,
              color: Colors.deepOrange,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.bookingDate,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.bookingTime,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(booking.status),
                  size: 14,
                  color: statusColor,
                ),
                const SizedBox(width: 4),
                Text(
                  booking.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  final Address address;
  final VoidCallback? onTap;
  final bool isSelected;

  const AddressTile({
    super.key,
    required this.address,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.deepOrange, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.deepOrange.shade100
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: isSelected ? Colors.deepOrange : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.landmarks,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${address.location["area"] ?? ''}",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        address.location["city"] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      if (address.location["district"] != null) ...[
                        Text(
                          " • ",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        Text(
                          address.location["district"]["name"] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.deepOrange, size: 24),
          ],
        ),
      ),
    );
  }
}
