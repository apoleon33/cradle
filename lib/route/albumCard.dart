import 'package:cradle/album.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../albumCard/display_as_card.dart';
import '../albumCard/display_as_list.dart';

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
    Dio dio = Dio();
    String website =
        'https://cradle-api.vercel.app/album/${date.year}/${date.month}/${date.day}';
    Response apiCall = await dio.get(website);
    Map result = apiCall.data;

    List genres = result['genre'];
    setState(() {
      cover = result['image'];
      name = result['name'];
      artist = result['artist'];
      genre = genres[0];
      averageRating = result['average_rating'];
    });
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
