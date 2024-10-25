
import 'package:flutter/material.dart';

const lightBackgroundColor = Colors.white;
const lightOnBackgroundColor = Color.fromRGBO(25, 35, 66, 1);
const lightPrimaryColor = Color.fromRGBO(86, 125, 244, 1);
const lightOnPrimaryColor = Colors.white;
const lightSecondaryColor = Color.fromRGBO(255, 49, 123, 1);
const lightOnSecondaryColor = Colors.white;
const lightFocusColor = Color.fromRGBO(250, 105, 158, 1.0);
const lightErrorColor = Color.fromRGBO(244, 67, 54, 1);
const lightOnErrorColor = Colors.white;
const lightSurfaceColor = Color.fromRGBO(243, 246, 255, 1);
const lightOnSurfaceColor = Color.fromRGBO(103, 113, 145, 1);
const lightTitleColor = Color.fromRGBO(25, 35, 66, 1);
const lightCardColor = Color.fromRGBO(58, 130, 225, 1); // Puedes ajustar los valores RGB según tu preferencia


const darkBackgroundColor = Color.fromRGBO(16, 22, 41, 1);
const darkOnBackgroundColor = Colors.white;
const darkPrimaryColor = lightPrimaryColor;
const darkOnPrimaryColor = Colors.white;
const darkSecondaryColor = lightSecondaryColor;
const darkOnSecondaryColor = Colors.white;
const darkFocusColor = Color.fromRGBO(255, 49, 123, 0.6);
const darkErrorColor = Color.fromRGBO(244, 67, 54, 1);
const darkOnErrorColor = Colors.white;
const darkSurfaceColor = Color.fromRGBO(25, 35, 66, 1);
const darkOnSurfaceColor = Color.fromRGBO(226, 233, 253, 1);
const darkTitleColor = Colors.white;

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Lato',
  focusColor: lightCardColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    background: lightBackgroundColor,
    onBackground: lightOnBackgroundColor,
    primary: lightPrimaryColor,
    onPrimary: lightOnPrimaryColor,
    secondary: lightSecondaryColor,
    onSecondary: lightSecondaryColor,
    surface: lightSurfaceColor,
    onSurface: lightOnSurfaceColor,
    error: lightErrorColor,
    onError: lightOnErrorColor,
  ),
  textTheme: TextTheme(
      titleSmall: _titleFontBuilder(18.0, lightTitleColor),
      titleMedium: _titleFontBuilder(24.0, lightTitleColor),
      titleLarge: _titleFontBuilder(32.0, lightTitleColor),
      bodySmall: _titleFontBuilder(16, lightOnSurfaceColor)
  ),

);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Lato',
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    background: darkBackgroundColor,
    onBackground: darkOnBackgroundColor,
    primary: darkPrimaryColor,
    onPrimary: darkOnPrimaryColor,
    secondary: darkSecondaryColor,
    onSecondary: darkSecondaryColor,
    surface: darkSurfaceColor,
    onSurface: darkOnSurfaceColor,
    error: darkErrorColor,
    onError: darkOnErrorColor,
  ),
  textTheme: TextTheme(
      titleSmall: _titleFontBuilder(18.0, darkTitleColor),
      titleMedium: _titleFontBuilder(24.0, darkTitleColor),
      titleLarge: _titleFontBuilder(32.0, darkTitleColor),
      bodySmall: _titleFontBuilder(16, darkOnSurfaceColor)
  ),

);

TextStyle _titleFontBuilder(double size, Color fontColor) {
  return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: size,
      color: fontColor
  );
}