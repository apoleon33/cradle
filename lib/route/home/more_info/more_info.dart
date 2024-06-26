import 'package:cradle/album.dart';
import 'package:cradle/api/lastfm_api.dart';
import 'package:cradle/music_library.dart';
import 'package:cradle/services.dart';
import 'package:cradle/share.dart';
import 'package:cradle/widgets/theme_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfo extends StatefulWidget {
  final Album album;
  final DateTime date;

  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;

  const MoreInfo({
    super.key,
    required this.album,
    required this.lightColorScheme,
    required this.darkColorScheme,
    required this.date,
  });

  @override
  State<StatefulWidget> createState() => _MoreInfo();
}

class _MoreInfo extends State<MoreInfo> {
  late Album album;
  late String albumDescription;
  late ColorScheme actualColorScheme;
  late ColorScheme actualDarkColorScheme;
  late List<String> genres;
  late Service service;

  late Library lib;
  bool _addedStatus = false;

  bool get addedStatus => _addedStatus;

  set addedStatus(bool value) {
    _addedStatus = value;

    if (value) {
      lib.addToLibrary(date: widget.date);
      if (kDebugMode) print("added album's ${widget.date} to library");
    } else {
      lib.removeFromLibrary(widget.date);
      if (kDebugMode) print("removed album's ${widget.date} to library");
    }
  }

  ScrollController scrollController = ScrollController();
  bool isNameHidden = false;

  @override
  void initState() {
    super.initState();
    album = widget.album;
    albumDescription = "";
    genres = [""];
    actualColorScheme = const ColorScheme.light().copyWith(
      secondaryContainer: const ColorScheme.light().background,
    );
    actualDarkColorScheme = const ColorScheme.dark().copyWith(
      secondaryContainer: const ColorScheme.dark().background,
    );
    service = Service.spotify;

    scrollController.addListener(() {
      double offset = scrollController.offset;
      setState(() {
        isNameHidden = offset > 343;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      lib = await Library.createFromCache();

      _getAlbumDescription();
      _getService();
      _initAddedStatus();
    });
  }

  Future<void> _getAlbumDescription() async {
    LastFmApi api = LastFmApi();
    Map result = await api.getAlbum(album);

    String convertedDescription = '';
    List<String> lastfmGenres = [];
    if (result['album']["wiki"] != null) {
      String description = result['album']["wiki"]["content"];
      description = description.replaceAll('\n', '465416');
      convertedDescription = html2md.convert(description);
      convertedDescription = convertedDescription.replaceAll(
        '[Read more',
        '465416465416[Read more',
      );
      convertedDescription = convertedDescription.replaceAll('465416', '\n');
    } else {
      convertedDescription = 'No description available';
    }
    if (result['album']['tags'] is! String) {
      if (result['album']['tags']['tag'].runtimeType == List<dynamic>) {
        for (final genre in result['album']['tags']['tag']) {
          lastfmGenres.add(genre['name']);
        }
      } else {
        lastfmGenres.add(result['album']['tags']['tag']['name']);
      }
    }

    setState(() {
      albumDescription = convertedDescription;
      genres = lastfmGenres;
    });

    if (kDebugMode) print('addedStatus status: $addedStatus');
  }

  bool _isSametag(String tag1, String tag2) =>
      tag1.toUpperCase() == tag2.toUpperCase();

  Future<void> _getService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int serviceIndex = prefs.getInt('service') ?? 0;
    final Service usedService = Service.values[serviceIndex];

    service = usedService;
  }

  Future<void> _initAddedStatus() async {
    setState(() {
      _addedStatus = lib.isInLibrary(widget.date);
    });
  }

  void onClickLibrary() {
    setState(() {
      addedStatus = !addedStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Successfully ${(addedStatus) ? 'added' : 'removed'} ${album.name} ${(addedStatus) ? 'to' : 'from'} your music library'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: onClickLibrary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context).copyWith(
      colorScheme: (Theme.of(context).brightness == Brightness.dark)
          ? widget.darkColorScheme
          : widget.lightColorScheme,
      brightness: Theme.of(context).brightness,
    );

    List<Widget> tagsList = [
      styledActionChip(
        theme,
        const Icon(Icons.music_note),
        album.genre,
      ),
    ];
    for (var element in genres) {
      if (!_isSametag(album.genre, element)) {
        tagsList.add(
          styledActionChip(
            theme,
            (int.tryParse(element) is! int)
                ? const Icon(Icons.music_note)
                : const Icon(Icons.event),
            element,
          ),
        );
      }
    }
    tagsList = tagsList.sublist(0, (tagsList.length < 3) ? tagsList.length : 3);
    tagsList.add(
      styledActionChip(
        theme,
        SvgPicture.asset("assets/rym.svg"),
        "${album.averageRating}/5",
      ),
    );

    return Consumer<ModeTheme>(builder: (context, modeTheme, child) {
      return Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: theme.colorScheme.secondaryContainer,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.secondaryContainer,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            title: Text(
              (isNameHidden) ? album.name : "",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
            ),
            actions: [
              IconButton(
                onPressed: onClickLibrary,
                icon: (addedStatus)
                    ? const Icon(Icons.library_add_check)
                    : const Icon(Icons.library_add),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                color: theme.colorScheme.onSecondaryContainer,
                onPressed: () {
                  shareAlbum(album);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                          child: Hero(
                            tag: album.cover,
                            child: Image.network(
                              album.cover,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                    ),
                    child: Text(
                      album.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      album.artist,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                    ),
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: tagsList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 32.0,
                      right: 10.0,
                      left: 10.0,
                    ),
                    child: MarkdownBody(
                      data: albumDescription,
                      styleSheet:
                          MarkdownStyleSheet(textAlign: WrapAlignment.start),
                      selectable: true,
                      onTapLink: (text, url, title) {
                        launchUrl(Uri.parse(url!));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              String initialUrl = service.searchUrl;
              String url =
                  Uri.encodeFull('$initialUrl${album.name} - ${album.artist}');
              final uri = Uri.parse(url);
              if (!await launchUrl(uri)) {
                throw Exception('Could not launch $uri');
              }
            },
            child: SvgPicture.asset(
              service.iconPath,
              color: theme.colorScheme.onPrimaryContainer,
              width: 24,
              height: 24,
            ),
          ),
        ),
      );
    });
  }

  Widget styledActionChip(ThemeData theme, Widget avatar, String text) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
      ),
      child: ActionChip(
        avatar: avatar,
        label: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        onPressed: () {},
        backgroundColor: theme.colorScheme.secondaryContainer,
      ),
    );
  }
}