import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SearchBar(
            hintText: "Search for content",
            leading: const Icon(Icons.search),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface),
            elevation: WidgetStateProperty.all(0),
            side: WidgetStateProperty.all(BorderSide(
              color: Theme.of(context).colorScheme.secondaryFixedDim, // blue border color
              width: 1, // 1px border width
            )),
          ),

        ],
      ),
    );
  }
}
