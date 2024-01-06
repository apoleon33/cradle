import 'package:cradle/album.dart';
import 'package:cradle/albumCard/display_album.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../moreInfoMenu.dart';

class DisplayAlbumAsCard extends DisplayAlbum {
  late Album album;
  late DateTime date;

  DisplayAlbumAsCard({super.key, required this.album, required this.date});

  @override
  Widget displayAlbum(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                  elevation: (dateIsToday(date))? 1: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                              child: album.cover == 'assets/default.png'
                                  ? Image.asset(
                                      album.cover,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : Image.network(
                                      album.cover,
                                      fit: BoxFit.fitWidth,
                                    ),
                            )),
                      ),
                      Expanded(
                          flex: 45,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 8, top: 8),
                                    child: Text(
                                        album.name.length > 18
                                            ? '${album.name.substring(0, 15)}...'
                                            : album.name,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                  ),
                                  Padding(
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
                                      ))
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
                                      onPressed: () {},
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
                                    const MoreInfoMenu(),

                                    // new Spacer(),
                                    FilledButton.icon(
                                      icon: SvgPicture.asset(
                                        "assets/spotify.svg",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        width: 18,
                                        height: 18,
                                      ),
                                      onPressed: null,
                                      label: const Text("Listen on Spotify"),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ))),
        ),
      ],
    );
  }
}