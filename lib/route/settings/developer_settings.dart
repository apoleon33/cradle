import 'package:cradle/widgets/setting_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeveloperSettings extends StatelessWidget {
  const DeveloperSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingPage(
      name: "Developer Settings",
      childs: <Widget>[
        const Padding(
          padding: EdgeInsets.only(right: 8.0, left: 8.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0, left: 8.0),
                child: Icon(Icons.cached),
              ),
              Text(
                "Cache management",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        const Cache(name: "Clear entire cache", onClick: Cache.clearAll),
        const Cache(name: "Clear albums cache", onClick: Cache.deleteAlbumsCache),
        const Cache(name: "Clear UI theme cache", onClick: Cache.deleteUIThemeCache),
      ],
    );
  }
}

class Cache extends StatefulWidget {
  final String name;
  final Future<bool> Function() onClick;

  const Cache({
    super.key,
    required this.name,
    required this.onClick,
  });

  static Future<bool> test() async => false;

  static Future<bool> clearAll() async {
    try{
      Cache.deleteAlbumsCache();
      Cache.deleteUIThemeCache();
    } on Exception catch (e) {
      if (kDebugMode) print("An error happened during clear: $e");
      return false;
    }
    return true;
  }

  static Future<bool> deleteAlbumsCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime todaysDate = DateTime.now();
    DateTime deadline = DateTime.parse('2023-12-31');

    try {
      while (deadline.isBefore(todaysDate)) {
        // clearing info that cache has been done for that album
        prefs
            .remove('${todaysDate.year}-${todaysDate.month}-${todaysDate.day}');

        // clear album infos
        prefs.remove(
            '${todaysDate.year}-${todaysDate.month}-${todaysDate.day}-data');
        prefs.remove(
            '${todaysDate.year}-${todaysDate.month}-${todaysDate.day}-averageRating');

        if (kDebugMode) print("cleared album cache of $todaysDate");
        todaysDate =
            DateTime(todaysDate.year, todaysDate.month, todaysDate.day - 1);
      }
    } on Exception catch (e) {
      if (kDebugMode) throw 'failed to clear cache: $e';
    }
    return true;
  }

  static Future<bool> deleteUIThemeCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime date = DateTime.now();
    try {
      prefs.remove('${date.year}-${date.month}-${date.day}-theme');
    } on Exception catch (e) {
      if (kDebugMode) throw 'failed to clear cache: $e';
    }
    return true;
  }

  @override
  State<StatefulWidget> createState() => _CacheState();
}

class _CacheState extends State<Cache> {
  late Widget onClickWidget;
  Widget icon = const Icon(Icons.delete_forever);

  @override
  void initState() {
    super.initState();
  }

  void onClick(BuildContext context) {
    setState(() {
      icon = const SizedBox(
        height: 24.0,
        width: 24.0,
        child: Center(child: CircularProgressIndicator()),
      );
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      bool cacheOperationStatus = await widget.onClick();

      setState(() {
        icon = cacheOperationStatus
            ? const Icon(Icons.done)
            : Icon(
                Icons.error,
                color: Theme.of(context).colorScheme.error,
              );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 48.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          IconButton(
            onPressed: () => {onClick(context)},
            icon: icon,
          ),
        ],
      ),
    );
  }
}
