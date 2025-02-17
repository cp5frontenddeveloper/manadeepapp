// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/home_controller.dart';

// class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const HomeAppBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<HomeController>();

//     return AppBar(
//       title: Obx(() => Text(
//             controller.currentTitle,
//             style: Get.textTheme.titleLarge?.copyWith(
//               color: Get.theme.colorScheme.onSurface,
//             ),
//           )),
//       centerTitle: true,
//       elevation: 0,
//       // actions: [
//       //   IconButton(
//       //     icon: Icon(Icons.search, color: Get.theme.colorScheme.primary),
//       //     onPressed: () {},
//       //   ),
//         // IconButton(
//         //   icon: Icon(
//         //     Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
//         //     color: Get.theme.colorScheme.primary,
//         //   ),
//         //   onPressed: () {
//         //     Get.changeThemeMode(
//         //       Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
//         //     );
//         //   },
//         // ),
//       // ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
