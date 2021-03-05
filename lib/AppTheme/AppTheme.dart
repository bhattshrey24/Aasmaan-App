import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._(); 
  static const Color _iconColor = Colors.white;
  static const Color _alternateTextColor = Colors.white;

  static const Color _lightPrimaryColor = Colors.white;
  static const Color _lightPrimaryVarientColor =
      Colors.blue; 
  static const Color _lightSecondaryColor = Colors.white;
  static const Color _lightOnPrimaryColor = Colors.yellow;

  static const Color _darkPrimaryColor = Colors.black;
  static Color _darkPrimaryVarientColor =
      Colors.blue[300]; 
  static const Color _darkSecondaryColor = Colors.purple;
  static const Color _darkOnPrimaryColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightPrimaryVarientColor,
    appBarTheme: AppBarTheme(
      color: _lightPrimaryVarientColor,
      iconTheme: IconThemeData(
      
        color: _lightOnPrimaryColor,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: _lightPrimaryColor,
        primaryVariant: _lightPrimaryVarientColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor),
    iconTheme: IconThemeData(color: _iconColor),
    textTheme: _lightTextTheme,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    headline5: _lightHeadlineHeadingTextStyle,
    headline2: _lightHeadline2HeadingTextStyle,
    bodyText2: _lightBodyText2HeadingTextStyle,
    bodyText1: _lightBodyText1HeadingTextStyle,
  );

  static final TextStyle _lightHeadlineHeadingTextStyle = GoogleFonts.workSans(
      fontSize: 30, fontWeight: FontWeight.w400, color: _alternateTextColor);
  static final TextStyle _lightHeadline2HeadingTextStyle = GoogleFonts.workSans(
      fontSize: 25, fontWeight: FontWeight.w400, color: _alternateTextColor);
  static final TextStyle _lightBodyText2HeadingTextStyle = GoogleFonts.workSans(
      fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25);
  static final TextStyle _lightBodyText1HeadingTextStyle = GoogleFonts.workSans(
      fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5);

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkPrimaryVarientColor,
    appBarTheme: AppBarTheme(
      color: _darkPrimaryVarientColor,
      iconTheme: IconThemeData(
       
        color: _darkOnPrimaryColor,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: _darkPrimaryColor,
        primaryVariant: _darkPrimaryVarientColor,
        secondary: _darkSecondaryColor,
        onPrimary: _darkOnPrimaryColor,
        onSecondary: _alternateTextColor),
    iconTheme: IconThemeData(color: _iconColor),
    textTheme: _darkTextTheme,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline5: _darkHeadlineHeadingTextStyle,
    headline2: _darkHeadline2HeadingTextStyle,
    bodyText2: _darkBodyText2HeadingTextStyle,
    bodyText1: _darkBodyText1HeadingTextStyle,
  );

  static final TextStyle _darkHeadlineHeadingTextStyle =
      _lightHeadlineHeadingTextStyle.copyWith(
          color:
              _alternateTextColor);
  static final TextStyle _darkHeadline2HeadingTextStyle =
      _lightHeadlineHeadingTextStyle.copyWith(color: _alternateTextColor);

  static final TextStyle _darkBodyText2HeadingTextStyle =
      _lightBodyText2HeadingTextStyle.copyWith(color: _darkPrimaryColor);

  static final TextStyle _darkBodyText1HeadingTextStyle =
      _lightBodyText1HeadingTextStyle.copyWith(color: Colors.grey);
}
