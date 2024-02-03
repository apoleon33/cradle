
import 'package:cradle/navigation.dart';
import 'package:cradle/route/settings.dart';
import 'package:flutter/material.dart';

import 'albumCard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isCard = true;

  int indexPage = 0;

  late List<Widget> albumList;

  void _createAlbumList() {
    DateTime timeNow = DateTime.now();
    List<Widget> albumCards = [
      AlbumCard(
        date: timeNow,
        // TODO replace this callback with a consumer/provider
        isCard: isCard,
        key: ValueKey(timeNow),
      ),
    ];

    int keyCount = 1;

    DateTime deadline = DateTime.parse('2023-12-31');

    // formatting so that it looks like 'year-month-day'
    String formattedDate = '${timeNow.year}-';
    if (timeNow.month < 10) {
      formattedDate += '0';
    }
    formattedDate += '${timeNow.month}-';
    if (timeNow.day < 10) {
      formattedDate += '0';
    }
    formattedDate += '${timeNow.day}';

    DateTime date = DateTime.parse(formattedDate);

    while (date.isAfter(deadline)) {
      date = DateTime(date.year, date.month, date.day - 1);
      albumCards.add(AlbumCard(
        date: date,
        isCard: isCard,
        key: ValueKey(keyCount),
      ));
      keyCount++;
    }

    setState(() {
      albumList = albumCards;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _createAlbumList();
    });
  }

  Future _refreshData() async {
    _createAlbumList();
  }

  @override
  Widget build(BuildContext context) {
    _createAlbumList();
    List<Widget> albumCards = albumList;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: const TextStyle(fontFamily: 'Cloister', fontSize: 24.0),
            )),
        actions: (indexPage == 0)
            ? [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      isCard = !isCard;
                    });
                  },
                  icon: (!isCard)
                      ? const Icon(Icons.view_list)
                      : const Icon(Icons.grid_view),
                )
              ]
            : [],
      ),
      body: [
        RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Column(
                children: albumCards,
              ))
            ],
          ),
        ),
        const Settings(),
      ][indexPage],
      bottomNavigationBar: Navigation(
        callBack: (int index) async {
          setState(() {
            indexPage = index;
          });
        },
        currentPageIndex: indexPage,
      ),
    );
  }
}
