import 'package:cradle/moreInfoMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';

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

  bool _dateIsToday(DateTime date) {
    DateTime timeNow = DateTime.now();
    return ((date.year == timeNow.year) &&
        (date.month == timeNow.month) &&
        (date.day == timeNow.day));
  }

  bool _dateIsYesterday(DateTime date) {
    DateTime timeNow = DateTime.now();
    return ((date.year == timeNow.year) &&
        (date.month == timeNow.month) &&
        (date.day == (timeNow.day - 1)));
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCard ? displayAsCard(context) : displayAsList();
  }

  Widget displayAsList() {
    return ListTile(
      leading: cover == 'assets/default.png'
          ? Image.asset(
              cover,
              fit: BoxFit.fitWidth,
            )
          : Image.network(
              cover,
              fit: BoxFit.fitWidth,
            ),
      title: Text(name),
      subtitle: Text(artist),
      trailing: Text(
        (_dateIsToday(date))
            ? "today"
            : (_dateIsYesterday(date))
                ? "yesterday"
                : "${date.day}/${date.month}/${date.year}",
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.right,
      ),
      style: ListTileStyle.list,
      isThreeLine: true,
    );
  }

  Widget displayAsCard(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                  elevation: 0,
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
                              child: cover == 'assets/default.png'
                                  ? Image.asset(
                                      cover,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : Image.network(
                                      cover,
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
                                        name.length > 18
                                            ? '${name.substring(0, 15)}...'
                                            : name,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8),
                                      child: Text(
                                        (_dateIsToday(date))
                                            ? "today"
                                            : (_dateIsYesterday(date))
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
                                      "by $artist",
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
                                        genre,
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
                                        "$averageRating/5",
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
        ));
  }
}