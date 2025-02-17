import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/localization/change_language.dart';
import 'package:manadeebapp/routes/app_routes.dart';
import 'bindings/initial_binding.dart';
import 'core/themes/app_theme.dart';
import 'localization/translation.dart';
import 'services/server_shared.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServices();
  Get.testMode = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService());
    final languageController = Get.put(LanguageController());

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: themeService.lightTheme,
      darkTheme: themeService.darkTheme,
      themeMode: themeService.getThemeMode(),
      locale: languageController.currentLocale ?? const Locale('en', 'US'),
      translations: MyTranslations(),
      debugShowCheckedModeBanner: false,
      initialBinding: Bindin(),
      getPages: getPages,
      // home: OrderForm(),
      defaultTransition: Transition.fade,
    );
  }
}
