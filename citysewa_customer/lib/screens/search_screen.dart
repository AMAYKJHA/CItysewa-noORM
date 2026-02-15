import "package:citysewa_customer/api/models.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/utils/utils.dart" show GetRandomNumber;
import "package:citysewa_customer/api/api.dart" show ServiceManager;
import "package:citysewa_customer/widgets/widgets.dart" show ServiceTile;

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
      appBar: AppBar(),
      body: Padding(
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
        keyboardType: TextInputType.text,
        onSubmitted: (value) {
          widget.onSubmit(value);
        },
        decoration: InputDecoration(
          hintText: 'Plumber, Mechaninc',
          prefixIcon: Icon(Icons.search),
        ),
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
                  service: serviceList[index],
                  rating: GetRandomNumber.getDouble(min: 3.8, max: 4.7),
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
