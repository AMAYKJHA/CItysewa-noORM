import "package:citysewa_customer/api/models.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/api/api.dart" show ServiceManager;
// import "package:citysewa/screens/service_screen.dart" show ServiceScreen;

const defaultProfileImage = "https://placehold.net/avatar-1.png";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String serviceType = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.red),
      backgroundColor: Color(0xfffbf0f9),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SearchBar(
              onSubmit: (value) {
                setState(() {
                  serviceType = value;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(child: SearchResult(serviceType: serviceType)),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSubmit;
  const SearchBar({super.key, required this.onSubmit});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        autofocus: true,
        cursorColor: Colors.red,
        enableSuggestions: true,
        keyboardType: TextInputType.text,
        onSubmitted: (value) {
          widget.onSubmit(value);
        },
        decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}

class SearchResult extends StatefulWidget {
  final String serviceType;
  const SearchResult({super.key, required this.serviceType});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Service>> getServices(String serviceType) async {
    if (serviceType != "") {
      try {
        final manager = ServiceManager();
        final serviceListResponse = await manager.listServices(
          serviceType = serviceType.trim(),
        );
        return serviceListResponse.serviceList;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong. Please try again.")),
        );
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getServices(widget.serviceType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final serviceList = snapshot.data;
          if (serviceList != null) {
            if (serviceList.isEmpty) {
              return Center(
                child: Text(
                  "No results found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                return ServiceTile(
                  serviceId: serviceList[index].id,
                  serviceType: serviceList[index].serviceType,
                  title: serviceList[index].title,
                  price: serviceList[index].price,
                  pricingType: serviceList[index].priceUnit,
                  thumbnail: serviceList[index].thumbnail,
                  providerName: "Unknown provider",
                );
              },
            );
          } else {
            return Text(
              "No results found",
              style: TextStyle(color: Colors.grey),
            );
          }
        } else {
          return Text("Find services", style: TextStyle(color: Colors.grey));
        }
      },
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String serviceType;
  final String title;
  final int price;
  final String pricingType;
  final String providerName;
  final String? thumbnail;
  final int serviceId;
  final double rating = 4.1;

  const ServiceTile({
    super.key,
    required this.serviceType,
    required this.title,
    required this.price,
    required this.pricingType,
    required this.providerName,
    required this.serviceId,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/service',
          arguments: {"serviceId": serviceId},
        );
      },
      child: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 5),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: thumbnail != null
                      ? Image.network(thumbnail!, fit: BoxFit.fill)
                      : Image.asset('assets/images/test.png'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      providerName,
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
                  "Rs.$price$pricingType",
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
