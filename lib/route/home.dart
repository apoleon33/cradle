import 'package:cradle/navigation.dart';
import 'package:cradle/route/settings.dart';
import 'package:cradle/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'albumCard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        isCard: isCard,
        key: ValueKey(timeNow),
      ),
    ];

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
        key: ValueKey(DateTime.now()),
      ));
    }
    albumList = albumCards;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _createAlbumList();
  }

  callBack(int index) {
    setState(() {
      indexPage = index;
    });
  }

  Future _refreshData() async {
    _createAlbumList();
  }

  @override
  Widget build(BuildContext context) {
    _createAlbumList();
    List<Widget> albumCards = albumList;

    return ChangeNotifierProvider(
      create: (context) => ServiceNotifier(),
      child: Scaffold(
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
                    onPressed: () {
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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                albumCards,
                [const Settings()]
              ][indexPage],
            ),
          ),
        ),
        bottomNavigationBar: Navigation(
          callBack: callBack,
          currentPageIndex: indexPage,
        ),
      ),
    );
  }
}
