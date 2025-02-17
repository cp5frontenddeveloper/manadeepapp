import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/server_shared.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int get priority => 1;
  final MyServices myServices = Get.find<MyServices>();

  @override
  RouteSettings? redirect(String? route) {
    String? token = myServices.sharedPreferences.getString('token');
    // تجاهل التحقق لصفحة البصمة نفسها
    if (route == AppRoutes.checkFinger) {
      return null;
    }

    // التحقق من تفعيل البصمة
    if (token != null && myServices.isFingerprintEnabled.value) {
      return RouteSettings(name: AppRoutes.checkFinger);
    }

    // إذا البصمة غير مفعلة، اسمح بالوصول للصفحة المطلوبة
    return null;
  }
}
