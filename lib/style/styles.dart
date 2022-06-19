import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color quizMainPanelColor = Colors.amber;
const Color quizMainTextColor = Colors.black;
const Color quizListTextColor = Colors.white;
const Color quizMainBackColor = Color(0xFF202020);
const Color quizHighScoreColor = Color(0xFF4CB050);
const Color quizMiddleScoreColor = Color(0xFF2196F3);
const Color quizLowScoreColor = Color(0xFFF44236);
const Color quizIconColor = Colors.black;

const Shadow mainShadow = Shadow(color: Colors.black, offset: Offset(1.0, 1.0), blurRadius: 5.0);

TextStyle bigFont = GoogleFonts.roboto(
    textStyle: TextStyle(color: quizListTextColor, fontSize: 24.0, fontWeight: FontWeight.bold, shadows: [mainShadow]));
TextStyle middleFont = GoogleFonts.roboto(
    textStyle: TextStyle(color: quizListTextColor, fontSize: 20.0, fontWeight: FontWeight.bold, shadows: [mainShadow]));
TextStyle smallFont = GoogleFonts.roboto(
    textStyle: TextStyle(color: quizListTextColor, fontSize: 12.0, fontWeight: FontWeight.bold, shadows: [mainShadow]));
TextStyle menuFont = GoogleFonts.roboto(
    textStyle: TextStyle(color: quizListTextColor, fontSize: 16.0, fontWeight: FontWeight.normal, shadows: [mainShadow]));





//underdog
//russoOne
//roboto
//ptSansCaption
//marmelad
//jura
