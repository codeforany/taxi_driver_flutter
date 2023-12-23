import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopupLayout extends ModalRoute {

  EdgeInsets? margin;
  Color? bgColor;
  final Widget child;


  PopupLayout({Key? key, this.bgColor, required this.child, this.margin});

  @override
  // TODO: implement barrierColor
  Color? get barrierColor => bgColor ?? Colors.black.withOpacity(0.5);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => false;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      margin ??= const EdgeInsets.all(0);

      return GestureDetector(
        onTap: (){
          SystemChannels.textInput.invokeMethod("TextInput.hide");
        },
        child: Material(
          type: MaterialType.transparency,
          child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5,), child: buildOverlayContent(context), ),
        ),
      );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => false;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 100);

  Widget buildOverlayContent(BuildContext context) {
    return Container(
      margin: margin,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
  
}