import 'package:flutter/material.dart';

void slideNavigateStateful(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        fullscreenDialog: false),
  );
}