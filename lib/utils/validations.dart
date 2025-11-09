import 'package:flutter/material.dart';

class FormValidations {
  /// Name Validation
  static String? validateName(String? input) {
    if (input == null || input.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  /// Email Validation
  static String? validateEmail(String? input) {
    if (input == null || input.isEmpty) {
      return "Email is required";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(input)) {
      return "Email is not valid";
    }
    return null;
  }
  static String? validateaddress(String? input) {
   if (input == null || input.isEmpty) {
      return "address is required";
    }
    return null;
  }

  /// Pakistani Phone Number Validation
  static String? validatePhone(String? input) {
    final pakistanRegex = RegExp(r'^(?:\+92|0)3[0-9]{2}-?[0-9]{7}$');
    if (input == null || input.isEmpty) {
      return "Phone is required";
    } else if (!pakistanRegex.hasMatch(input)) {
      return "Phone number is not valid (e.g. 03001234567 or +923001234567)";
    }
    return null;
  }
  static String? validateGender(String? input) {
   if(input == null || input.isEmpty){
    return "Please Select Gender";
   }
   return null;
  }

  /// Password Validation
  static String? validatePassword(String? input) {
    if (input == null || input.isEmpty) {
      return "Password is required";
    } else if (input.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  /// Confirm Password Validation
  static String? confirmPassword(String? confirm, String? original) {
    if (confirm == null || confirm.isEmpty) {
      return "Please confirm your password";
    } else if (confirm != original) {
      return "Passwords do not match";
    }
    return null;
  }
}
