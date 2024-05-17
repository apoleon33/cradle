import 'dart:async';

// import 'package:flutter/foundation.dart';
import 'package:cradle/custom_date.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Library {
  late final SharedPreferences prefs;
  List<DateTime> albums = [];

  Library._create() {
    albums = [];
  }

  /// Create an empty [Library] object
  static Future<Library> create() async {
    var lib = Library._create();
    await lib._initPrefs();

    return lib;
  }

  /// Create a [Library] object from albums stored in the cache
  static Future<Library> createFromCache() async {
    var lib = Library._create();

    await lib._initPrefs();
    await lib._addAlbumsFromCache();

    return lib;
  }

  Future<void> _addAlbumsFromCache() async {
    List<String> previousAlbums = prefs.getStringList('library') ?? [];

    // formatting so that it looks like 'YYYY-MM-DD'
    for (String date in previousAlbums) {
      albums.add(FormattedDateTime.parseAndFormat(date));
    }
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void addToLibrary({required DateTime date}) {
    albums.add(date);

    List<String> previousAlbums = prefs.getStringList('library') ?? [];
    previousAlbums.add("${date.year}-${date.month}-${date.day}");

    prefs.setStringList('library', previousAlbums);
  }

  void removeFromLibrary(DateTime date) {
    albums.remove(date);

    List<String> previousAlbums = prefs.getStringList('library') ?? [];
    previousAlbums.remove("${date.year}-${date.month}-${date.day}");

    prefs.setStringList('library', previousAlbums);
  }

  bool isInLibrary(DateTime date) {
    final DateTime clearedDate = DateTime(date.year, date.month, date.day);
    if (kDebugMode) print('date to search: $date');
    for (DateTime element in albums) {
      if (element.isAtSameMomentAs(clearedDate)) {
        return true;
      }
    }
    if (kDebugMode) print(albums);
    return false;
  }
}
