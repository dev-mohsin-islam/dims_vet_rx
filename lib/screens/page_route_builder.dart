
import 'package:flutter/material.dart';

Route createRoute(Page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>   Page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.7, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

popupTransition(BuildContext context, widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>   widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.7, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
