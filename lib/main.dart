
import 'package:cradle/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'route/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ModeTheme(),
      child: DynamicTheme(
        child: const MyHomePage(title: 'CRADLE'),
      ),
    );
  }
}
