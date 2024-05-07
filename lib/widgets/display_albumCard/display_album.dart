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
