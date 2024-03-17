import 'package:cradle/widgets/navigation.dart';
import 'package:cradle/route/settings.dart';
import 'package:flutter/foundation.dart';
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

  late ScrollController _scrollController;
  bool isBackToTopButtonShown = false;
  DateTime deadline = DateTime.parse('2023-12-31');

  void _createAlbumList() {
    if (kDebugMode) print("deadline: ${deadline}");
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

    bool deadlineIs30DaysAgo = deadline.isBefore(
      timeNow.subtract(
        const Duration(days: 30),
      ),
    );

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

    if (deadline.isAfter(DateTime.parse('2023-12-31'))) {
      albumCards.add(
        FilledButton.icon(
          onPressed: upgradeDeadline,
          label: const Text("Load more albums"),
          icon: const Icon(Icons.post_add),
        ),
      );
    }

    setState(() {
      albumList = albumCards;
    });
  }

  void upgradeDeadline() {
    DateTime newDeadline = deadline;
    if (deadline
        .subtract(const Duration(days: 30))
        .isBefore(DateTime.parse('2023-12-31'))) {
      newDeadline = DateTime.parse('2023-12-31');
    } else {
      newDeadline = deadline.subtract(const Duration(days: 30));
    }

    if (kDebugMode) {
      print(newDeadline);
      print(deadline);
    }

    int key = 1;
    deadline = newDeadline;
    albumList.removeLast(); // remove button
     setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    albumList = [];
    // _scrollController.addListener(() {
    //   setState(() {
    //     isBackToTopButtonShown = _scrollController.offset >= 400;
    //   });
    // });

    deadline = DateTime.now().subtract(const Duration(days: 30));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _createAlbumList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInOutQuart);
    if (kDebugMode) print("successfully scrolled up to the top!");
  }

  Future _refreshData() async {
    _createAlbumList();
  }

  void _changeView() async {
    _scrollToTop();
    setState(() {
      isCard = !isCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode){
      print(isCard);
    }

    _createAlbumList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: _scrollToTop,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Cloister',
                    fontSize: 24.0,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ))),
        actions: (indexPage == 0)
            ? [
                IconButton(
                  onPressed: _changeView,
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
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                  child: Column(
                children: albumList,
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
