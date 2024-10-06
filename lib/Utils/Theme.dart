import 'package:flutter/material.dart';

import 'ColorsApp.dart';

class MyThemes {
  static ThemeData LightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,

      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: ColorsApp.primary, size: 30),
          backgroundColor: Colors.transparent,
          elevation: 0.0),
    );
}