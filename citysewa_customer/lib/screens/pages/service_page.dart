import "package:flutter/material.dart";

import "package:citysewa_customer/api/models.dart" show Service;
import "package:citysewa_customer/widgets/widgets.dart"
    show VerifyYourselfBanner;

class ServicePage extends StatefulWidget {
  final bool verified;
  final List<Service> serviceList;
  const ServicePage({
    super.key,
    this.verified = false,
    this.serviceList = const [],
  });

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<Widget> renderServices() {
    List<Widget> renderedServices = <Widget>[];

    for (Service serviceItem in widget.serviceList) {
      renderedServices.add(ServiceTile(service: serviceItem));
    }
    return renderedServices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.verified)
          ...renderServices()
        else
          Align(alignment: Alignment.topCenter, child: VerifyYourselfBanner()),
      ],
    );
  }
}

class ServiceTile extends StatelessWidget {
  final Service service;
  const ServiceTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF3EE), Color(0xFFFDE7DE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFFF3C2B3)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 90,
                height: 90,
                color: Colors.white,
                child: Image.asset(
                  service.thumbnail ?? 'assets/images/test.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.serviceType,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.deepOrange.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Rs. ${service.price}${service.priceUnit}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
