import 'package:cradle/albumCard/albumCard.dart';
import 'package:cradle/theme_manager.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      child: const MyHomePage(title: 'CRADLE'),
    );
  }
}
