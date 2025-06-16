import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class OnboardingContent extends StatelessWidget {
  final Onboarding onboarding;
  final ValueNotifier<double> notifier;
  final int page;

  const OnboardingContent({super.key, required this.onboarding, required this.notifier, this.page = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlidingPage(
      page: page,
      notifier: notifier,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(onboarding.image, width: 256,),
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                onboarding.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Text(
              onboarding.caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: theme.colorScheme.secondary
              ),
            )
          ],
        ),
      ),
    );
  }
}
