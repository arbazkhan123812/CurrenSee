import 'package:flutter/material.dart';

// Define a common, strong color for the theme
const Color kPrimaryColor = Color.fromARGB(255, 56, 18, 123);

ThemeData apptheme = ThemeData(
  // 1. Enable Material 3 features fully. This is best practice when using colorSchemeSeed.
  useMaterial3: true,
  
  // 2. Set the seed color. This generates the entire color palette (primary, secondary, etc.)
  colorSchemeSeed: kPrimaryColor, // Using deepPurple as primary color base
  
  // Set the overall brightness (dark or light theme)
  brightness: Brightness.light, 
  
  // 3. AppBar Theme: Consistent look and color
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2.0, // Add subtle shadow
  ),

  // 4. ElevatedButton Theme: Set style for all ElevatedButtons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Increased radius for modern look
      ),
      textStyle: const TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.bold, // Bolder text for visibility
      ),
      padding: const EdgeInsets.symmetric(vertical: 10), // Add vertical padding
    ),
  ),

  // 5. Input Decoration Theme: Consistent, modern text field styling
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.auto, // Labels move up when focused
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0), // Consistent rounding
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: kPrimaryColor, width: 2.0), // Purple accent on focus
    ),
    labelStyle: const TextStyle(color: kPrimaryColor), // Purple label text
    prefixIconColor: kPrimaryColor, // Purple icon color
  ),
  
  // 6. Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
  ),
  
  // 7. Text Selection Color: Uses the primary color when highlighting text
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kPrimaryColor,
    selectionColor: kPrimaryColor,
    selectionHandleColor: kPrimaryColor,
  ),
);