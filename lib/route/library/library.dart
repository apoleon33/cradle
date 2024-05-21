import 'package:cradle/album.dart';
import 'package:cradle/api/cradle_api.dart';
import 'package:cradle/music_library.dart';
import 'package:cradle/widgets/display_albumCard/display_as_grid.dart';
import 'package:flutter/material.dart';

class MusicLibrary extends StatefulWidget {
  const MusicLibrary({super.key});

  @override
  State<StatefulWidget> createState() => _MusicLibraryState();
}

class _MusicLibraryState extends State<MusicLibrary> {
  late Library lib;
  List<Widget> libraryList = [];
  bool _libIsLoaded = false;
  late ScrollController scrollController;

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _createAlbumList();
    });
  }

  Future<void> _createAlbumList() async {
    lib = await Library.createFromCache();
    List<Album> albumList = [];
    CradleApi cradleApi = CradleApi();
    List<DateTime> dateList = lib.albums;

    for (DateTime date in dateList) {
      albumList.add(
        await cradleApi.getAlbumByDate(
          date,
        ),
      );
      setState(() {
        progress += 1 / dateList.length;
      });
    }

    libraryList = [];
    int startIndex = 0;
    // If the number of albums is an odd number -> add first element, then format as usual
    if (albumList.length % 2 != 0) {
      libraryList.add(
        _FormatAsRow(
          albums: <Album>[albumList[0]],
          dates: <DateTime>[dateList[0]],
        ),
      );
      startIndex = 1;
    }

    for (var i = startIndex; i < albumList.length; i++) {
      libraryList.add(
        _FormatAsRow(
          albums: <Album>[
            albumList[i],
            (i < albumList.length + 1) ? albumList[i + 1] : albumList[i],
          ],
          dates: [
            dateList[i],
            (i < albumList.length + 1) ? dateList[i + 1] : dateList[i],
          ],
        ),
      );
      i++;
    }

    setState(() {
      _libIsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [const Padding(padding: EdgeInsets.all(8.0))];
    content.addAll(libraryList);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _libIsLoaded = false;
          progress = 0.0;
        });
        await _createAlbumList();
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: (_libIsLoaded)
                ? Column(
                    children: content,
                  )
                : LinearProgressIndicator(
                    value: progress,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Small [StatelessWidget] to format a row of [DisplayAlbumAsGrid] widgets
class _FormatAsRow extends StatelessWidget {
  final List<Album> albums;
  final List<DateTime> dates;

  const _FormatAsRow({super.key, required this.albums, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < albums.length; i++)
          DisplayAlbumAsGrid(
            album: albums[i],
            date: dates[i],
            lightColorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
            ),
            darkColorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            width: 200,
            height: 200,
          ),
      ],
    );
  }
}
