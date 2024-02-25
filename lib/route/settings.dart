import 'package:cradle/route/settings/about_settings.dart';
import 'package:cradle/route/settings/notifications_settings.dart';
import 'package:cradle/route/settings/service_settings.dart';
import 'package:cradle/route/settings/theme_mode_settings.dart';
import 'package:flutter/material.dart';
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
    return const Center(
      child: Column(
        children: [
          SettingButton(
            icon: Icons.settings_brightness,
            name: "Theme Mode",
            page: ThemeModeSetting(),
          ),
          SettingButton(
            icon: Icons.music_note,
            name: "Default music provider",
            page: ServiceSetting(),
          ),
          SettingButton(
            icon: Icons.notifications,
            name: "Push notifications",
            page: NotificationSetting(),
          ),
          SettingButton(
            icon: Icons.info,
            name: "About",
            page: AboutSettings(),
          ),
        ],
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  final IconData icon;
  final String name;
  final Widget page;

  const SettingButton({
    super.key,
    required this.icon,
    required this.name,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
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
                context, MaterialPageRoute(builder: (context) => page));
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
                    icon,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
