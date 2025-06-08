import 'package:flutter/material.dart';

class CircolareContent extends StatelessWidget {
  final String number;
  final String title;

  const CircolareContent({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 64),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Circolare n. $number",
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                title.substring(title.indexOf(".") + ".".length).trim(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
