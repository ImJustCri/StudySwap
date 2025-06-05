import 'package:flutter/material.dart';

class CircolariCarousel extends StatelessWidget {
  const CircolariCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144,
      width: double.infinity,
      child: CarouselView(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        itemSnapping: true,
        itemExtent: 330,
        children: const [
          Center(child: Text('Item 1')),
          Center(child: Text('Item 2')),
          Center(child: Text('Item 3')),
        ],
      ),
    );
  }
}
