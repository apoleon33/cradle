import 'package:cradle/albumCard/albumCard.dart';
import 'package:cradle/theme_manager.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      child: const MyHomePage(title: 'CRADLE'),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    DateTime timeNow = DateTime.now();
    List<Widget> albumCards = [
      const SizedBox(height: 16),
      AlbumCard(time: timeNow, isCard: isCard),
    ];

    DateTime deadline = DateTime.parse('2023-12-31');

    // formating so that it looks like 'year-month-day'
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
      albumCards.add(const SizedBox(height: 13));
      albumCards.add(AlbumCard(
        time: date,
        isCard: isCard,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.surface,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(
            child: Text(
          widget.title,
          style: const TextStyle(fontFamily: 'Cloister'),
        )),

        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isCard = !isCard;
                });
              },
              icon: (!isCard)
                  ? const Icon(Icons.view_list)
                  : const Icon(Icons.grid_view))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: albumCards,
        ),
      ),
    );
  }
}
