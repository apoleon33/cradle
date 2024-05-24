import 'package:cradle/widgets/setting_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSettings extends StatelessWidget {
  final String _licenseContent =
      """     Cradle is an application designed to recommend you one album per day. Copyright (C) 2024 apoleon33

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program.  If not, see """;

  final String _licenseUrl = "https://www.gnu.org/licenses/";

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
            child: Column(
              children: <Widget>[
                Text(
                  "Cradle is an application designed to recommend you one album per day.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "License",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: _licenseContent,
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: _licenseUrl,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(_licenseUrl));
                            },
                        ),
                        const TextSpan(text: ".")
                      ],
                    ),
                  ),
                ),
              ],
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
