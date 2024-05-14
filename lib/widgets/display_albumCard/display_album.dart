import 'package:cradle/album.dart';
import 'package:cradle/route/home/more_info/more_info.dart';
import 'package:flutter/material.dart';

abstract class DisplayAlbum extends StatelessWidget {
  final Album album;
  final DateTime date;

  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;

  const DisplayAlbum({
    super.key,
    required this.album,
    required this.date,
    required this.lightColorScheme,
    required this.darkColorScheme,
  });

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

  /// Open the "more info" page about the album
  void openMoreInfo(BuildContext context) {
    Navigator.push(
      context,
      createRoute(
        MoreInfo(
          album: album,
          lightColorScheme: lightColorScheme,
          darkColorScheme: darkColorScheme,
          date: date,
        ),
      ),
    );
  }

  Route createRoute(Widget children) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => children,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => displayAlbum(context);

  Widget displayAlbum(BuildContext context);
}
