import 'package:flutter/material.dart';

abstract class DisplayAlbum extends StatelessWidget {
  const DisplayAlbum({super.key});

  bool dateIsToday(DateTime date) {
    DateTime timeNow = DateTime.now();
    return ((date.year == timeNow.year) &&
        (date.month == timeNow.month) &&
        (date.day == timeNow.day));
  }

  bool dateIsYesterday(DateTime date) {
    DateTime timeNow = DateTime.now();
    return ((date.year == timeNow.year) &&
        (date.month == timeNow.month) &&
        (date.day == (timeNow.day - 1)));
  }

  @override
  Widget build(BuildContext context) => displayAlbum(context);

  Widget displayAlbum(BuildContext context);
}
