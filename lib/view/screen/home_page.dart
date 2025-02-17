// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/home_controller.dart';
// import '../../core/function/alert_dialog.dart';
// import '../widget/custom_drawer.dart';
// import '../widget/home_appbar.dart';
// import '../widget/home_bottom_navbar.dart';
// import 'tabs/add_order_view.dart';
// import 'tabs/admin_communication_view.dart';
// import 'tabs/notes_view.dart';
// import 'tabs/orders_list_view.dart';

// class HomePage extends GetView<HomeController> {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//         appBar: HomeAppBar(),
//         drawer: CustomDrawer(
//           username: controller.username,
//           email: controller.email,
//         ),
//         body: PopScope(
//           canPop: false,
//           onPopInvoked: (didPop) async {
//             if (didPop) return;
//             final bool shouldPop = await alertExitapp();
//             if (shouldPop) {
//               Get.back();
//             }
//           },
//           child: _buildBody(),
//         ),
//         bottomNavigationBar: HomeBottomNavbar(),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     final tabs =  [
//       AdminCommunicationView(),
//       OrdersListView(),
//       AddOrderView(),
//       NotesView(),
//     ];

//     return Obx(() => AnimatedSwitcher(
//           duration: const Duration(milliseconds: 300),
//           child: tabs[controller.selectedIndex],
//         ));
//   }
// }
