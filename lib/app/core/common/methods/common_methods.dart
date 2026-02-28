import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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

  static Future<bool> requestCallPermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  static Future<void> makeDirectCall(String phoneNumber) async {
    final hasPermission = await requestCallPermission();

    if (!hasPermission) {
      throw Exception("Call permission denied");
    }

    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }
}
