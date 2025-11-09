import 'package:flutter/material.dart';

ThemeData apptheme = ThemeData(

colorSchemeSeed: Colors.indigo,

appBarTheme: AppBarTheme(
  backgroundColor: Colors.indigo,
  foregroundColor: Colors.white,
  centerTitle: true
),

elevatedButtonTheme: ElevatedButtonThemeData(
  style : ElevatedButton.styleFrom(backgroundColor: Colors.indigo,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  textStyle: TextStyle(fontSize: 18),
  ) 

),

inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(

  )
),
floatingActionButtonTheme: FloatingActionButtonThemeData(
  backgroundColor: Colors.indigo,
  foregroundColor: Colors.white
)
);