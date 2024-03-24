import 'package:cradle/album.dart';
import 'package:cradle/route/more_info.dart';
import 'package:cradle/widgets/albumCard/display_album.dart';
import 'package:cradle/widgets/rym_snackbar.dart';
import 'package:cradle/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../moreInfoMenu.dart';

class DisplayAlbumAsCard extends DisplayAlbum {
  final Album album;
  final DateTime date;
  final Service service;
  Uri _url = Uri.parse('https://flutter.dev');

  DisplayAlbumAsCard(
      {super.key,
      required this.album,
      required this.date,
      required this.service}) {
    const String initialUrl = "https://open.spotify.com/search/";
    String url = Uri.encodeFull('$initialUrl${album.name} - ${album.artist}');
    _url = Uri.parse(url);
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget displayAlbum(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          height: 425,
          child: Card(
              elevation: (dateIsToday(date)) ? 1 : 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context, createRoute(MoreInfo(album: album)),
                    );
                  },
                  child: Column(
                    children: [
                      Expanded(
                        flex: 55,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
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
                        ),
                      ),
                      Expanded(
                          flex: 45,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, top: 8),
                                      child: Text(
                                        //album.name.length > 18
                                        //   ? '${album.name.substring(0, 15)}...'
                                        album.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8, left: 8),
                                          child: Text(
                                            (dateIsToday(date))
                                                ? "today"
                                                : (dateIsYesterday(date))
                                                    ? "yesterday"
                                                    : "${date.day}/${date.month}/${date.year}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                          )))
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      "by ${album.artist}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ActionChip(
                                      avatar: const Icon(Icons.music_note),
                                      label: Text(
                                        album.genre,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ),
                                      onPressed: () {},
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ActionChip(
                                      avatar:
                                          SvgPicture.asset("assets/rym.svg"),
                                      label: Text(
                                        "${album.averageRating}/5",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondaryContainer),
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          RymSnackbar(),
                                        );
                                      },
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, top: 16, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MoreInfoMenu(
                                      album: album,
                                    ),
                                    FilledButton.icon(
                                      icon: SvgPicture.asset(
                                        service.iconPath,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        width: 18,
                                        height: 18,
                                      ),
                                      onPressed: () {
                                        String initialUrl = service.searchUrl;
                                        String url = Uri.encodeFull(
                                            '$initialUrl${album.name} - ${album.artist}');
                                        _url = Uri.parse(url);
                                        _launchUrl();
                                      },
                                      label: Text(
                                        "Listen on ${service.fullName}",
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ))),
        )),
      ],
    );
  }
}
