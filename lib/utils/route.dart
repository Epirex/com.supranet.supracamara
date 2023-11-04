import 'package:flutter/material.dart';

PageRouteBuilder<dynamic> ruta(Widget child, Offset offset,{int transitionDuration=600}) {
  return PageRouteBuilder(
     barrierColor: Colors.transparent,
    opaque: false,
    fullscreenDialog: true,
    barrierDismissible: true,
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        child, 
    transitionDuration: Duration(milliseconds: transitionDuration),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic,reverseCurve: Curves.ease);
      return SlideTransition(
        position: Tween<Offset>(begin: offset, end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}