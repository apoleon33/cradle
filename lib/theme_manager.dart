import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _getTodayImage();
    currentColorScheme = const ColorScheme.light();
    currentDarkColorScheme = const ColorScheme.dark();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createTheme(widget.image);
    });
  }

  void _getTodayImage() async {
    DateTime todayDate = DateTime.now();
    Dio dio = Dio();
    String website =
        "https://cradle-api.vercel.app/album/${todayDate.year}/${todayDate.month}/${todayDate.day}";

    Response apiCall = await dio.get(website);
    Map result = apiCall.data;

    widget.image = NetworkImage(result['image']);
    createTheme(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme lightColorScheme = currentColorScheme;
    final ColorScheme darkColorScheme = currentDarkColorScheme;
    return MaterialApp(
        title: 'Cradle',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: widget.child);
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
