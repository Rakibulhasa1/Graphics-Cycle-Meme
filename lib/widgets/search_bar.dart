import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  CustomSearchBar({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search memes',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
