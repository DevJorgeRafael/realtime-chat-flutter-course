import 'package:flutter/material.dart';

class AppTheme {
  final ColorScheme colorScheme = ColorScheme.fromSwatch().copyWith(
    primary: const Color.fromARGB(255, 209, 10, 17),
  );

  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'HelveticaNeue',
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontFamily: 'HelveticaNeue'),
        bodyLarge: TextStyle(
            fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal),
        titleLarge: TextStyle(
            fontFamily: 'HelveticaNeue', fontWeight: FontWeight.normal),
      ),
    );
  }
}
