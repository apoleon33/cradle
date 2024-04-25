import 'dart:math';

import 'package:cradle/route/settings/abstract_settings.dart';
import 'package:flutter/material.dart';

class NotificationSetting extends SettingPage {
  static const List<String> gifLinks = [
    "https://i.pinimg.com/originals/94/c4/ce/94c4cee816a0ff61372defb6d1271054.gif",
    "https://i.pinimg.com/originals/48/fd/b2/48fdb2bcfcd5af94d49855a414771999.gif",
    "https://i.pinimg.com/originals/15/0e/ef/150eefbaf3aeeef32156443b3c96c5e2.gif",
    "https://i.pinimg.com/originals/28/b4/2d/28b42d9172a7b03691d0453f213ee5e4.gif"
  ];

  const NotificationSetting({super.key}) : super(name: "Push notifications");

  @override
  List<Widget> buildContent(BuildContext context) {
    final random = Random();
    return [
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
    ];
  }
}
