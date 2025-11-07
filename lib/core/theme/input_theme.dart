import 'package:flutter/material.dart';
import 'app_colors.dart';


InputDecorationTheme buildLoginInputTheme() {
return InputDecorationTheme(
filled: true,
fillColor: Colors.white,
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: kBorderColor),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: kBorderColor),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(color: kPrimaryColor, width: 1.6),
),
hintStyle: const TextStyle(color: kHintColor),
labelStyle: const TextStyle(color: kLabelColor),
);
}