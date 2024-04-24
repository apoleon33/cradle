import 'package:cradle/album.dart';
import 'package:cradle/api/cradle_api.dart';
import 'package:cradle/api/lastfm_api.dart';
import 'package:cradle/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cradle/widgets/albumCard/display_as_card.dart';
import 'package:cradle/widgets/albumCard/display_as_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumCard extends StatefulWidget {
  final DateTime date;
  final bool isCard;

  const AlbumCard({super.key, required this.date, required this.isCard});

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  late DateTime date;

  String cover = 'assets/default.png';
  String name = "album";
  String artist = "artist";
  String genre = "genre";
  double averageRating = 5.0;
  ColorScheme lightAlbumColorScheme = const ColorScheme.light();
  ColorScheme darkAlbumColorScheme = const ColorScheme.dark();

  Service currentService = Service.spotify;

  @override
  void initState() {
    super.initState();
    date = widget.date;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCurrentService();
    });
    _getAlbumByDate();
  }

  void _getCurrentService() async {
    final prefs = await SharedPreferences.getInstance();
    int serviceNumber = prefs.getInt('service') ?? 0;
    if (mounted) {
      setState(() {
        currentService = Service.values[serviceNumber];
      });
    }
  }

  void _getAlbumByDate() async {
    Album result = await _getAlbumFromCache(date);

    if (mounted) {
      precacheImage(NetworkImage(result.cover), context);

      setState(() {
        cover = result.cover;
        name = result.name;
        artist = result.artist;
        genre = result.genre;
        averageRating = result.averageRating;
      });

      // preload color theme for the "more info" page
      _getAlbumColorScheme();
    }
  }

  Future<void> _getAlbumColorScheme() async {
    // preload color theme for the "more info" page
    if (kDebugMode) print("getting color scheme: $cover");

    final ColorScheme lightColorScheme = await ColorScheme.fromImageProvider(
      provider: NetworkImage(cover),
      brightness: Theme.of(context).brightness,
    );
    if (kDebugMode) print("got color scheme");

    if (mounted) {
      setState(() {
        if (Theme.of(context).brightness == Brightness.light) {
          lightAlbumColorScheme = lightColorScheme;
        } else {
          darkAlbumColorScheme = lightColorScheme;
        }
      });
    }
  }

  Future<Album> _getAlbumFromCache(DateTime date) async {
    final pref = await SharedPreferences.getInstance();
    Album album = Album(
      cover: 'assets/default.png',
      name: "album",
      artist: "artist",
      genre: 'genre',
      averageRating: 5.0,
    );

    if ((pref.getBool('${date.year}-${date.month}-${date.day}') ?? false)) {
      // The album has been cached
      List<String> albumData = pref.getStringList(
        '${date.year}-${date.month}-${date.day}-data',
      )!;

      album.cover = albumData[0];
      album.name = albumData[1];
      album.artist = albumData[2];
      album.genre = albumData[3];

      album.averageRating = pref.getDouble(
        '${date.year}-${date.month}-${date.day}-averageRating',
      )!;
    } else {
      CradleApi api = CradleApi();
      album = await api.getAlbumByDate(date);

      LastFmApi lastfmApi = LastFmApi();
      var lastfmCover = await lastfmApi.getCover(album);

      album.cover = (lastfmCover == null) ? album.cover : lastfmCover;

      // caching
      pref.setStringList(
        '${date.year}-${date.month}-${date.day}-data',
        [album.cover, album.name, album.artist, album.genre],
      );

      pref.setDouble('${date.year}-${date.month}-${date.day}-averageRating',
          album.averageRating);

      pref.setBool('${date.year}-${date.month}-${date.day}', true);
    }

    return album;
  }

  @override
  Widget build(BuildContext context) {
    final Album album = Album(
      cover: cover,
      name: name,
      artist: artist,
      genre: genre,
      averageRating: averageRating,
    );

    return widget.isCard
        ? DisplayAlbumAsCard(
            album: album,
            date: date,
            service: currentService,
            lightColorScheme: lightAlbumColorScheme,
            darkColorScheme: darkAlbumColorScheme,
          )
        : DisplayAsList(
            key: ValueKey(album),
            album: album,
            date: date,
            lightColorScheme: lightAlbumColorScheme,
            darkColorScheme: darkAlbumColorScheme,
          );
  }
}
