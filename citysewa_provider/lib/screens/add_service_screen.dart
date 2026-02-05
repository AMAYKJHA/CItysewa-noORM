import "package:flutter/material.dart";

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Text("Add service"),
            TextField(decoration: InputDecoration(hintText: "Title")),
            TextField(decoration: InputDecoration(hintText: "Service type")),
            TextField(decoration: InputDecoration(hintText: "Description")),
          ],
        ),
      ),
    );
  }
}
