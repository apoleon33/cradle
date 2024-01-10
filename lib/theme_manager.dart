import 'package:cradle/album.dart';
import 'package:cradle/api/cradle_api.dart';
import 'package:cradle/api/lastfm_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicTheme extends StatefulWidget {
  Widget child;
  ImageProvider image = const AssetImage("assets/default.png");

  DynamicTheme({super.key, required this.child});

  @override
  State<DynamicTheme> createState() => _DynamicTheme();
}

class _DynamicTheme extends State<DynamicTheme> {
  late ColorScheme currentColorScheme;
  late ColorScheme currentDarkColorScheme;
  late int themeMode;

  @override
  void initState() {
    super.initState();
    _getTodayImage();
    currentColorScheme = const ColorScheme.light();
    currentDarkColorScheme = const ColorScheme.dark();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createTheme(widget.image);

      _getThemeModeFromSettings();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _getThemeModeFromSettings() async {
    final prefs = await SharedPreferences.getInstance();

    themeMode = prefs.getInt('color') ?? 0;
  }

  void _getTodayImage() async {
    DateTime todayDate = DateTime.now();
    // Dio dio = Dio();
    // String website =
    //     "https://cradle-api.vercel.app/album/${todayDate.year}/${todayDate.month}/${todayDate.day}";
    //
    // Response apiCall = await dio.get(website);
    // Map result = apiCall.data;
    CradleApi api = CradleApi();
    Album result = await api.getAlbumByDate(todayDate);

    LastFmApi lastfmApi = LastFmApi();
    var lastfmCover = await lastfmApi.getCover(result);

    widget.image =
        NetworkImage((lastfmApi == null) ? result.cover : lastfmCover);
    createTheme(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme lightColorScheme = currentColorScheme;
    final ColorScheme darkColorScheme = currentDarkColorScheme;
    return Consumer<ModeTheme>(
      builder: (context, modeTheme, child) {
        return MaterialApp(
            title: 'Cradle',
            theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
            darkTheme:
                ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
            themeMode: (modeTheme.themeMode == 0)
                ? ThemeMode.system
                : (modeTheme.themeMode == 1)
                    ? ThemeMode.light
                    : ThemeMode.dark,
            debugShowCheckedModeBanner: false,
            home: widget.child);
      },
    );
  }

  Future<void> createTheme(ImageProvider provider) async {
    final ColorScheme newLightColorScheme = await ColorScheme.fromImageProvider(
        provider: provider, brightness: Brightness.light);

    final ColorScheme newDarkColorScheme = await ColorScheme.fromImageProvider(
        provider: provider, brightness: Brightness.dark);

    setState(() {
      currentColorScheme = newLightColorScheme;
      currentDarkColorScheme = newDarkColorScheme;
    });
  }
}

class ModeTheme extends ChangeNotifier {
  int _themeMode = 0;

  ModeTheme() {
    _initThemeMode();
  }

  void _initThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    themeMode = prefs.getInt('color') ?? 0;
  }

  int get themeMode => _themeMode;

  set themeMode(int newThemeMode) {
    _themeMode = newThemeMode;
    notifyListeners();
  }
}
