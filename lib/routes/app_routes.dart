import 'package:get/get.dart';
import 'package:manadeebapp/view/screen/order_details_view.dart';
import 'package:manadeebapp/view/screen/tabs/orders_list_view.dart';
import '../middleware/my_middleware.dart';
import '../view/screen/auth/login_page_view.dart';
import '../view/screen/home_page1.dart';
import '../view/screen/login_finger_view.dart';
import '../bindings/initial_binding.dart';
import '../view/screen/search_page.dart';
import 'app_pages.dart';

List<GetPage> getPages = [
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginPage(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: AppRoutes.home,
    page: () => const Homepagemanadeep(),
    binding: Bindin(),
  ),
  GetPage(
    name: AppRoutes.checkFinger,
    page: () => LoginFingerView(),
  ),
  // GetPage(name: AppRoutes.addOrder, page: () => AddOrderView()),
  GetPage(
    name: AppRoutes.orderDetail,
    page: () => OrderDetailsView(),
  ),
  GetPage(
    name:AppRoutes.orders, 
    page: ()=>OrdersListView()),
    GetPage(
  name: '/search', 
  page: () => DynamicSearchPage(),

)
];
