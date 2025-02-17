import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<bool> chickInternet() async {
  if (kIsWeb) {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  } else {
    try {
      var result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
