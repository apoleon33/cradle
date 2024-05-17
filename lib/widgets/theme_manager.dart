import 'package:cradle/album.dart';
import 'package:cradle/api/cradle_api.dart';
import 'package:cradle/api/lastfm_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicTheme extends StatefulWidget {
  final Widget child;
  ImageProvider image = const AssetImage("assets/default.png");

  DynamicTheme({super.key, required this.child});

  @override
  State<DynamicTheme> createState() => _DynamicTheme();
}

class _DynamicTheme extends State<DynamicTheme> {
  ColorScheme currentColorScheme = const ColorScheme.light();
  ColorScheme currentDarkColorScheme = const ColorScheme.dark();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _getTodayImage();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //createTheme(widget.image);
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

    widget.image = NetworkImage(
      (lastfmCover == null) ? result.cover : lastfmCover,
    );

    createTheme(widget.image);
  }

  Future<void> createTheme(ImageProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    final DateTime date = DateTime.now();
    final List<String>? theme = prefs.getStringList(
        '${date.year}-${date.month}-${date.day}-theme');

    final ColorScheme newLightColorScheme;
    final ColorScheme newDarkColorScheme;
    if (theme == null) {
      newLightColorScheme = await ColorScheme.fromImageProvider(
          provider: provider, brightness: Brightness.light);

      newDarkColorScheme = await ColorScheme.fromImageProvider(
          provider: provider, brightness: Brightness.dark);

      final Color mainColor = newLightColorScheme.primary;
      prefs.setStringList('${date.year}-${date.month}-${date.day}-theme',
        <String>[
          mainColor.red.toString(),
          mainColor.green.toString(),
          mainColor.blue.toString(),
        ],);
    } else {
      if (kDebugMode) print("theme found in cache");

      newLightColorScheme = ColorScheme.fromSeed(
        seedColor: Color.fromRGBO(
          int.parse(theme[0]),
          int.parse(theme[1]),
          int.parse(theme[2]),
          1.0,
        ),
        brightness: Brightness.light,
      );

      newDarkColorScheme = ColorScheme.fromSeed(
        seedColor: Color.fromRGBO(
          int.parse(theme[0]),
          int.parse(theme[1]),
          int.parse(theme[2]),
          1.0,
        ),
        brightness: Brightness.dark,
      );
    }
    setState(() {
      currentColorScheme = newLightColorScheme;
      currentDarkColorScheme = newDarkColorScheme;
    });
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
          debugShowCheckedModeBanner: true,
          // easier to know which version im running
          home: widget.child,
        );
      },
    );
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
