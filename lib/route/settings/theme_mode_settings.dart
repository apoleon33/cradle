import 'package:cradle/widgets/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeSetting extends StatefulWidget {
  const ThemeModeSetting({super.key});

  @override
  State<StatefulWidget> createState() => _ThemeModeSetting();
}

class _ThemeModeSetting extends State<ThemeModeSetting> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Theme Mode",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildThemeMode(),
        ],
      ),
    );
  }

  Widget buildThemeMode() {
    return Consumer<ModeTheme>(builder: (context, themeMode, child) {
      return SegmentedButton(
        segments: const [
          ButtonSegment(
            value: 0,
            label: Text("system"),
            icon: Icon(Icons.settings_brightness),
          ),
          ButtonSegment(
            value: 1,
            label: Text("light"),
            icon: Icon(Icons.light_mode),
          ),
          ButtonSegment(
            value: 2,
            label: Text("dark"),
            icon: Icon(Icons.dark_mode),
          )
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
    });
  }
}
