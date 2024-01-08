import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Service {
  spotify(
    name: "Spotify",
    iconPath: "assets/spotify.svg",
    fullName: "Spotify",
    searchUrl: 'https://open.spotify.com/search/',
  ),
  apple(
    name: "Apple",
    iconPath: "assets/apple.svg",
    fullName: "Apple Music",
    searchUrl: 'https://music.apple.com/us/search?term=',
  ),
  deezer(
    name: "Deezer",
    iconPath: "assets/deezer.svg",
    fullName: "Deezer",
    searchUrl: 'https://www.deezer.com/search/',
  );

  const Service({
    required this.name,
    required this.iconPath,
    required this.fullName,
    required this.searchUrl,
  });

  final String name;
  final String iconPath;
  final String fullName;
  final String searchUrl;
}

class ServiceNotifier extends ChangeNotifier {
  Service _currentService = Service.spotify;

  ServiceNotifier() {
    _initCurrentService();
  }

  void _initCurrentService() async {
    final prefs = await SharedPreferences.getInstance();

    int i = prefs.getInt('service') ?? 0;

    for (Service element in Service.values) {
      if (element.index == i) {
        currentService = element;
        break;
      }
    }
  }

  Service get currentService => _currentService;

  set currentService(Service newService) {
    _currentService = newService;
    notifyListeners();
  }
}
