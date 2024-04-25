import 'package:flutter/material.dart';

abstract class SettingPage extends StatelessWidget {
  final String name;
  const SettingPage({super.key, required this.name});

  List<Widget> buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: Column(
          children: buildContent(context),
        ),
      ),
    );
  }
}