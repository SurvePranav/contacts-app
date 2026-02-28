import 'dart:developer';

import 'package:flutter/material.dart';

abstract class CommonMethods {
  static String colorToString(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  // Convert hex string back to Color
  static Color stringToColor(String hexString) {
    try {
      if (hexString == '') return Colors.white;
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      log('error parsing color: $hexString :$e');
      return Colors.white;
    }
  }
}
