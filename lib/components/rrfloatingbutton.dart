import 'package:flutter/material.dart';
import 'package:quiflutter/style/styles.dart';

class RoundedRectangleFloatingButton extends FloatingActionButton{
  RoundedRectangleFloatingButton({Widget child, Function() onPressed})
      : super(
      child: child,
      onPressed: onPressed,
      backgroundColor: quizMainPanelColor,
      foregroundColor: quizMainTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      )
  );
}
