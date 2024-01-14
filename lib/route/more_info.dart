import 'package:cradle/album.dart';
import 'package:cradle/api/lastfm_api.dart';
import 'package:cradle/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class MoreInfo extends StatefulWidget {
  Album album;

  MoreInfo({super.key, required this.album});

  @override
  State<StatefulWidget> createState() => _MoreInfo();
}

class _MoreInfo extends State<MoreInfo> {
  late Album album;
  late String albumDescription;
  late ColorScheme actualColorScheme;

  @override
  void initState() {
    super.initState();
    album = widget.album;
    albumDescription = "";
    actualColorScheme = const ColorScheme.dark();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setCustomTheme();
      _getAlbumDescription();
    });
  }

  void _setCustomTheme() async {
    final ColorScheme newColorScheme = await ColorScheme.fromImageProvider(
        provider: NetworkImage(album.cover));
    setState(() {
      actualColorScheme = newColorScheme;
    });
  }

  void _getAlbumDescription() async {
    LastFmApi api = LastFmApi();
    Map result = await api.getAlbum(album);

    String convertedDescription = '';
    if (result['album']["wiki"] != null) {
      String description = result['album']["wiki"]["content"];
      description = description.replaceAll('Read more', '\n\nRead more');
      description = description.replaceAll('\n', '465416');
      convertedDescription = html2md.convert(description);
      convertedDescription = convertedDescription.replaceAll('465416', '\\\n');
    } else {
      convertedDescription = 'No description available';
    }

    setState(() {
      albumDescription = convertedDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeTheme>(builder: (context, modeTheme, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: actualColorScheme,
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            title: Text(
              album.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      child: Hero(
                        tag: album.name,
                        child: Image.network(album.cover),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 32.0,
                    left: 32.0,
                    top: 16.0,
                  ),
                  child: Text(
                    album.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Text(
                    album.artist,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    right: 16.0,
                    left: 16.0,
                    bottom: 60.0,
                  ),
                  child: MarkdownBody(
                    data: albumDescription,
                    selectable: true,
                    onTapLink: (text, url, title) {
                      launchUrl(Uri.parse(url!));
                    },
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text("Listen to ${album.artist}"),
          ),
        ),
      );
    });
  }
}
