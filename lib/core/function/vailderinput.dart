import 'package:get/get.dart';

String? vailder(String val, int min, int max, String type) {
  // Check for empty value first
  if (val.isEmpty) {
    return type == 'password' ? "97".tr : "90".tr;
  }

  // Check length constraints
  if (val.length < min) {
    return type == 'password' ? "98".tr + " $min" + " 92".tr : "91".tr + " $min" + " 92".tr;
  }
  
  if (val.length > max) {
    return "93".tr + " $max" + " 92".tr;
  }

  // Validate based on type
  switch (type) {
    case 'name':
      final arabicRegex = RegExp(r'^[\u0621-\u064A\s]+$');
      if (!GetUtils.isUsername(val) && !arabicRegex.hasMatch(val)) {
        return "94".tr;
      }
      break;
      
    case 'email':
      if (!GetUtils.isEmail(val)) {
        return "95".tr;
      }
      break;
      
    case 'number':
      if (!GetUtils.isPhoneNumber(val)) {
        return "96".tr;
      }
      break;
      
    case 'password':
      if (!GetUtils.isUsername(val)) {
        return '99'.tr;
      }
      break;
  }

  return null;
}
