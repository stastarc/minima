import 'package:flutter/material.dart';

class AnimatedRoute<T> extends MaterialPageRoute<T> {
  AnimatedRoute({required super.builder});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

Route fade(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Route slideRTL(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      var begin = const Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
