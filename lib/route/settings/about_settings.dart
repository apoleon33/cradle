import 'package:cradle/route/settings/abstract_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSettings extends StatelessWidget {
  const AboutSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingPage(
      name: "About",
      childs: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Text(
              "Cradle is an application designed to recommend you one album per day.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FilledButton.icon(
              onPressed: () {
                launchUrl(Uri.parse("https://github.com/apoleon33/cradle"));
              },
              label: const Text("get the source code"),
              icon: SvgPicture.asset(
                "assets/github-mark.svg",
                width: 24,
                height: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        )
      ],
    );
  }
}
