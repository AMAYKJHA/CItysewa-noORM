import "package:citysewa_customer/api/models.dart";
import "package:flutter/material.dart";

import "package:citysewa_customer/utils/utils.dart" show GetRandomNumber;
import "package:citysewa_customer/api/api.dart" show ServiceManager;
import "package:citysewa_customer/widgets/widgets.dart" show ServiceTile;

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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(title: Text("Search Services")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: SearchBarWidget(
              onSubmit: (value) {
                setState(() {
                  serviceType = value;
                });
              },
            ),
          ),
          Expanded(child: SearchResult(serviceType: serviceType)),
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSubmit;
  const SearchBarWidget({super.key, required this.onSubmit});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          widget.onSubmit(value);
        },
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search for plumber, mechanic...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _controller.clear();
                    widget.onSubmit("");
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onChanged: (value) => setState(() {}),
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
    if (widget.serviceType.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search,
        title: "Find Services",
        subtitle: "Search for plumbers, electricians,\nmechanics and more",
      );
    }

    return FutureBuilder(
      future: getServices(widget.serviceType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.deepOrange),
                const SizedBox(height: 16),
                Text(
                  "Searching...",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final serviceList = snapshot.data;
          if (serviceList != null && serviceList.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "${serviceList.length} result${serviceList.length > 1 ? 's' : ''} found",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: ServiceTile(
                          service: serviceList[index],
                          rating: GetRandomNumber.getDouble(min: 3.8, max: 4.7),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return _buildEmptyState(
            icon: Icons.search_off,
            title: "No Results Found",
            subtitle: "Try searching with different keywords",
          );
        }
        return _buildEmptyState(
          icon: Icons.error_outline,
          title: "Something Went Wrong",
          subtitle: "Please try again",
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: Colors.deepOrange.shade300),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
