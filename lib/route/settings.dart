import 'package:cradle/route/settings/theme_mode_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cradle/services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  int colorMode = 0;
  Service? selectedService = Service.spotify;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSavedColorMode();
      _getSavedServices();
    });
  }

  void _getSavedColorMode() async {
    final prefs = await SharedPreferences.getInstance();
    // if it has never been set, default to 0
    setState(() {
      colorMode = prefs.getInt('color') ?? 0;
    });
  }

  void _getSavedServices() async {
    final prefs = await SharedPreferences.getInstance();
    int serviceNumber = prefs.getInt('service') ?? 0;
    setState(() {
      selectedService = Service.values[serviceNumber];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          buildThemeMode(),
          const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Divider(
              indent: 16.0,
              endIndent: 16.0,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              bottom: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Default music provider"),
              ],
            ),
          ),
          buildServiceSelection(),
        ],
      ),
    );
  }

  Widget buildThemeMode() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 8.0,
      ),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThemeModeSetting()));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: Icon(
                    Icons.settings_brightness,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  "Theme Mode",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildServiceSelection() {
    return Consumer<ServiceNotifier>(
      builder: (context, serviceNotifier, child) {
        List<ButtonSegment> servicesList = [];
        for (var element in Service.values) {
          servicesList.add(
            ButtonSegment(
              value: element,
              label: Text(
                element.name,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              icon: SvgPicture.asset(
                element.iconPath,
                width: 18.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: SegmentedButton(
            segments: servicesList,
            selected: {serviceNotifier.currentService},
            onSelectionChanged: (Set newSelection) async {
              serviceNotifier.currentService = newSelection.first;
              final pref = await SharedPreferences.getInstance();
              setState(() {
                selectedService = newSelection.first;
              });
              await pref.setInt('service', newSelection.first.index);
            },
          ),
        );
      },
    );
  }
}
