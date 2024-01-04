import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  int currentPageIndex = 0;
  final Function callBack;

  Navigation({super.key, required this.callBack});

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: widget.currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          widget.currentPageIndex = index;
          widget.callBack(index);
        });
      },
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
