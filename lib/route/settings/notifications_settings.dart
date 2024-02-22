import 'dart:math';

import 'package:flutter/material.dart';

class NotificationSetting extends StatelessWidget {
  static const List<String> gifLinks = [
    "https://i.pinimg.com/originals/94/c4/ce/94c4cee816a0ff61372defb6d1271054.gif",
    "https://i.pinimg.com/originals/48/fd/b2/48fdb2bcfcd5af94d49855a414771999.gif",
    "https://i.pinimg.com/originals/15/0e/ef/150eefbaf3aeeef32156443b3c96c5e2.gif",
    "https://i.pinimg.com/originals/28/b4/2d/28b42d9172a7b03691d0453f213ee5e4.gif"
  ];

  const NotificationSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Push notifications",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              child: Image.network(
                gifLinks[random.nextInt(gifLinks.length)],
              ),
            ),
            Text(
              "coming soon!",
              style: Theme.of(context).textTheme.displaySmall,
            )
          ],
        ),
      ),
    );
  }
}
