import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final TextStyle title = GoogleFonts.lato(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle headline = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w400
  );

  static final TextStyle body = GoogleFonts.lato(
    fontSize: 18,
  );

  static final TextStyle subtext = GoogleFonts.lato(
    fontSize: 12,
  );

  static final TextStyle button = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}