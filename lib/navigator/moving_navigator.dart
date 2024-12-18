import 'package:flutter/material.dart';

void slideNavigateStateful(BuildContext context, Widget screen, {Function()? backFunction}) {
  Navigator.push(
    context,
    PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        fullscreenDialog: false),
  ).then((_) {
    backFunction?.call();
  });
}

void centerNavigateStateful(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      // 열릴 때 애니메이션 시간
      reverseTransitionDuration: const Duration(milliseconds: 100),
      // 닫힐 때 애니메이션 시간
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.linear;
        var tween = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return ScaleTransition(
          scale: tween,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      fullscreenDialog: false,
    ),
  );
}
