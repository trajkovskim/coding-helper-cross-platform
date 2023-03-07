import 'package:flutter/material.dart';

class CodingHelperInitialPage extends StatelessWidget {
  const CodingHelperInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            SizedBox(height: 10),
            Text(
              'Coding helper',
              style: theme.textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
