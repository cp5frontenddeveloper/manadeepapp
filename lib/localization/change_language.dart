/// مراقب اللغة المسؤول عن تغيير وإدارة لغة التطبيق
/// يستخدم GetX للتحكم في حالة اللغة
///
/// الخصائص:
/// * [currentLocale] - يحفظ اللغة الحالية للتطبيق
/// * [_services] - خدمة للوصول إلى التخزين المشترك
///
/// الوظائف الرئيسية:
/// * [onInit] - تهيئة المراقب وتحميل اللغة المحفوظة
/// * [changeLanguage] - تغيير لغة التطبيق إلى اللغة المحددة
/// * [_initializeLanguage] - تهيئة اللغة من التخزين المشترك
/// * [_getLocaleFromCode] - تحويل رمز اللغة إلى كائن Locale
/// * [_updateLocale] - تحديث لغة التطبيق الحالية
///
/// يدعم اللغات:
/// * العربية (ar)
/// * الإنجليزية (en)
/// * لغة الجهاز الافتراضية إذا لم يتم تحديد لغة
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/services/server_shared.dart';

class LanguageController extends GetxController {
  Locale? currentLocale;
  final MyServices _services = Get.find<MyServices>();

  @override
  void onInit() {
    super.onInit();
    _initializeLanguage();
  }

  void changeLanguage(String languageCode) {
    final newLocale = Locale(languageCode);
    _services.sharedPreferences.setString('lang', languageCode);
    _updateLocale(newLocale);
  }

  void _initializeLanguage() {
    final savedLang = _services.sharedPreferences.getString("lang");
    currentLocale = _getLocaleFromCode(savedLang);
    _updateLocale(currentLocale!);
  }

  Locale _getLocaleFromCode(String? languageCode) {
    switch (languageCode) {
      case "ar":
        return const Locale("ar");
      case "en":
        return const Locale("en");
      default:
        return Locale(Get.deviceLocale!.languageCode);
    }
  }

  void _updateLocale(Locale locale) {
    currentLocale = locale;
    Get.updateLocale(locale);
  }

  /// تقوم هذه الدالة بتبديل لغة التطبيق بين العربية والإنجليزية
  /// إذا كانت اللغة الحالية هي العربية، سيتم التبديل إلى الإنجليزية والعكس صحيح
  /// في حالة عدم وجود لغة محددة، سيتم اعتبار اللغة الإنجليزية هي الافتراضية
  void toggleLanguage() {
    final currentLang = currentLocale?.languageCode ?? 'en';
    final newLang = currentLang == 'ar' ? 'en' : 'ar';
    changeLanguage(newLang);
  }
}
