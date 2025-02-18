import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,

  // appBarTheme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    surfaceTintColor: Colors.black,
    elevation: 0,
  ),

  // colorScheme
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
    brightness: Brightness.dark,
    surfaceTint: Colors.black,
  ),

  // elevatedButtonTheme
  elevatedButtonTheme:  ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.black),
      foregroundColor: const WidgetStatePropertyAll(Colors.black),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),

  navigationBarTheme: const NavigationBarThemeData(
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
    height: 60,
    indicatorColor: Colors.transparent,
    backgroundColor: Colors.black,
    iconTheme: WidgetStatePropertyAll<IconThemeData>(
      IconThemeData(
        color: Colors.white,
        size: 27
      )
    ),
  ),
);