import 'package:flutter/material.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text('Exchange Page', style: TextStyle(fontSize: 24)),
    );
  }
}
