import 'package:cradle/widgets/display_albumCard/display_album.dart';
import 'package:flutter/material.dart';

class DisplayAlbumAsGrid extends DisplayAlbum {
  final double? width;
  final double? height;

  const DisplayAlbumAsGrid({
    super.key,
    required super.album,
    required super.date,
    required super.lightColorScheme,
    required super.darkColorScheme,
    this.width,
    this.height,
  });

  @override
  Widget displayAlbum(BuildContext context) {
    return SizedBox(
      width: width ?? 60,
      height: height ?? 60,
      child: InkWell(
          onTap: () => openMoreInfo(context),
          child: Hero(
            tag: album.cover,
            child: album.cover == 'assets/default.png'
                ? Image.asset(
              album.cover,
              fit: BoxFit.fitWidth,
            )
                : Image.network(
              album.cover,
              fit: BoxFit.fitWidth,
            ),
          ),
      ),
    );
  }
}
