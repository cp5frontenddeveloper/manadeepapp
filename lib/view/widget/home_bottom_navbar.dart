import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/controllers/home_controller.dart';
import 'package:manadeebapp/view/widget/navigation_destinations.dart';

class HomeBottomNavbar extends StatelessWidget {
  const HomeBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            indicatorColor: Get.theme.colorScheme.primary.withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.all(Get.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.bold))),
        child: Obx(() => NavigationBar(
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: controller.changeTab,
            destinations: navigationDestinations)));
  }
}
