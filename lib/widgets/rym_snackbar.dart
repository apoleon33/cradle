import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RymSnackbar extends SnackBar {
  RymSnackbar({super.key})
      : super(
          content: const Text(
            "RYM is one of the largest music databases and communities online",
          ),
          duration: const Duration(milliseconds: 1500),
          action: SnackBarAction(
            label: 'Open RYM',
            onPressed: () {
              launchUrl(Uri.parse("https://rateyourmusic.com/"));
            },
          ),
        );
}
