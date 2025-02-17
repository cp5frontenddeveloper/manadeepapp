import 'package:get/get.dart';
import 'package:manadeebapp/controllers/dataLoader_controller.dart';
import 'package:manadeebapp/controllers/orders/order_details_controller.dart';
import 'package:manadeebapp/data/providers/crud.dart';
import '../controllers/authcontroller/login_page_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/orders/orders_list_controller.dart';
import '../controllers/notes/notes_controller.dart';
import '../data/repositories/admin_communication_logs.dart';
import '../data/repositories/auth/login_repositories.dart';
import '../services/server_shared.dart';
import '../controllers/admin_communication_controller.dart';

class Bindin extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put(MyServices());
    Get.put(CRUD());

    // Initialize LoginRepositories
    final crud = Get.find<CRUD>();
    Get.put(LoginRepositories(crud));

    // Initialize AdminCommunicationController first
    final adminCommunicationLogs = AdminCommunicationLogs(crud);
    Get.put(AdminCommunicationController(
        adminCommunicationLogs, Get.find<MyServices>()));

    // Initialize LoginPageController with dependencies
    Get.put(LoginPageController(
      loginRepositories: Get.find<LoginRepositories>(),
      myServices: Get.find<MyServices>(),
    ));

    // Other Controllers
    Get.put(HomeController());
    Get.put(DataLoaderController());
    Get.lazyPut(() => OrdersListController());
    // Get.lazyPut(() => AddOrderController());
    Get.lazyPut(() => NotesController());
    Get.lazyPut(() => OrderDetailsController(), fenix: true);
  }
}
