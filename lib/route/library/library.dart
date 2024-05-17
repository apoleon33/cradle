import 'package:cradle/album.dart';
import 'package:cradle/api/cradle_api.dart';
import 'package:cradle/music_library.dart';
import 'package:cradle/widgets/display_albumCard/display_as_grid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MusicLibrary extends StatefulWidget {
  const MusicLibrary({super.key});

  @override
  State<StatefulWidget> createState() => _MusicLibraryState();
}

class _MusicLibraryState extends State<MusicLibrary> {
  late final Library lib;
  List<Widget> libraryList = [];
  bool _libIsLoaded = false;
  late ScrollController scrollController;

  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      lib = await Library.createFromCache();

      _createAlbumList();
    });
  }

  Future<void> _createAlbumList() async {
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
    // if (kDebugMode) print(lib.albums);
    for (var i = (albumList.length % 2 == 0) ? 0 : 1;
        i < albumList.length;
        i++) {
      if (kDebugMode) print(i);
      libraryList.add(
        _formatAsRow(
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

  Widget _formatAsRow({
    required List<Album> albums,
    required List<DateTime> dates,
  }) =>
      Row(
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

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [
      const Padding(padding: EdgeInsets.all(8.0))
    ];
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
                    ))
        ],
      ),
    );
  }
}
