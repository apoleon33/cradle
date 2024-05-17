import 'package:cradle/route/home/more_info/more_info.dart';
import 'package:flutter/material.dart';

import 'display_album.dart';

class DisplayAsList extends DisplayAlbum {
  const DisplayAsList({
    super.key,
    required super.album,
    required super.date,
    required super.lightColorScheme,
    required super.darkColorScheme,
  });

  @override
  Widget displayAlbum(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Hero(
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
          title: Text(album.name),
          subtitle: Text(album.artist),
          trailing: Text(
            (dateIsToday(date))
                ? "today"
                : (dateIsYesterday(date))
                    ? "yesterday"
                    : "${date.day}/${date.month}/${date.year}",
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.right,
          ),
          style: ListTileStyle.list,
          isThreeLine: false,
          onTap: () => openMoreInfo(context),
        ),
        const Divider(indent: 16.0, endIndent: 16.0),
      ],
    );
  }
}
