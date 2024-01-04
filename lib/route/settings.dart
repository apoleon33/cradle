import 'package:cradle/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  int colorMode = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSavedColorMode();
    });
  }

  void _getSavedColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    // if it has never been set, default to 0
    setState(() {
      colorMode = prefs.getInt('color') ?? 0;
    });

    print("theme mode: $colorMode");
  }

  void changeColorMode(int newColorMode) async {}

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Theme mode"),
          Consumer<ModeTheme>(builder: (context, themeMode, child) {
            return SegmentedButton(
              segments: const [
                ButtonSegment(
                    value: 0,
                    label: Text("system"),
                    icon: Icon(Icons.settings_brightness)),
                ButtonSegment(
                    value: 1,
                    label: Text("light"),
                    icon: Icon(Icons.light_mode)),
                ButtonSegment(
                    value: 2, label: Text("dark"), icon: Icon(Icons.dark_mode))
              ],
              selected: <int>{themeMode.themeMode},
              onSelectionChanged: (Set<int> newSelection) async {
                themeMode.themeMode = newSelection.first;
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  colorMode = newSelection.first;
                });
                await prefs.setInt('color', newSelection.first);
              },
            );
          })
        ],
      ),
    );
  }
}
