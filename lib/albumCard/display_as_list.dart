import 'package:cradle/albumCard/display_album.dart';
import 'package:cradle/route/more_info.dart';
import 'package:flutter/material.dart';
import '../album.dart';

class DisplayAsList extends DisplayAlbum {
  Album album;
  DateTime date;

  DisplayAsList({super.key, required this.album, required this.date});

  @override
  Widget displayAlbum(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Hero(
            tag: album.name,
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
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MoreInfo(album: album)));
          },
        ),
        const Divider(indent: 16.0, endIndent: 16.0),
      ],
    );
  }
}
