import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension Poppins on num {
  TextStyle sp(
      {FontWeight weight = FontWeight.w500, Color color = Colors.black}) {
    return GoogleFonts.poppins(
        fontSize: toDouble(), fontWeight: weight, color: color);
  }
}
