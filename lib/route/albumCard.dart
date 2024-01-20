import 'package:cradle/album.dart';
import 'package:cradle/api/cradle_api.dart';
import 'package:cradle/api/lastfm_api.dart';
import 'package:flutter/material.dart';

import 'package:cradle/albumCard/display_as_card.dart';
import 'package:cradle/albumCard/display_as_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumCard extends StatefulWidget {
  late DateTime date;
  bool isCard;

  AlbumCard({super.key, required this.date, required this.isCard});

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

  @override
  void initState() {
    super.initState();
    date = widget.date;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getAlbumByDate();
    });
  }

  void _getAlbumByDate() async {
    // Dio dio = Dio();
    // String website =
    //     'https://cradle-api.vercel.app/album/${date.year}/${date.month}/${date.day}';
    // Response apiCall = await dio.get(website);
    // Map result = apiCall.data;
    Album result = await _getAlbumFromCache(date);

    LastFmApi lastfmApi = LastFmApi();
    var lastfmCover = await lastfmApi.getCover(result);
    if (mounted) {
      setState(() {
        cover = (lastfmCover == null) ? result.cover : lastfmCover;
        name = result.name;
        artist = result.artist;
        genre = result.genre;
        averageRating = result.averageRating;
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
            key: ValueKey(album),
          )
        : DisplayAsList(album: album, date: date);
  }
}
