import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/core/constants/class/status_request.dart';
import 'package:manadeebapp/routes/app_pages.dart';
import '../../data/models/auth/login_response_model.dart';
import '../../data/models/box_inventory_model.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_respone.dart';
import '../../services/server_shared.dart';
import '../../view/screen/tabs/add_order_editpage.dart';
import '../home_controller.dart';

// كلاس لتحكم بقائمة الطلبات
class OrdersListController extends GetxController {
  final orders = <Order>[].obs;
  final filteredOrders = <Order>[].obs;
  final _isLoading = false.obs;
  final isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();
  bool get isLoading => _isLoading.value;
  final AddOrderRespone addOrderRespone = AddOrderRespone(Get.find());
  final MyServices _myServices = Get.find<MyServices>();
  final Rx<STATUSREQUEST> statusrequest = STATUSREQUEST.none.obs;
  final RxList<BoxInventory> boxInventoryorder = <BoxInventory>[].obs;
  @override
  void onInit() {
    super.onInit();
    inzalized();
  }

  Future<void> inzalized()async {
    loadMockOrders();
    loadBoxInvertoy();
  }

  Future<void> loadBoxInvertoy() async {
    try {
      statusrequest.value = STATUSREQUEST.loading;
      _isLoading.value = true;
      update();

      final response = await addOrderRespone.getboxInventory();

      print("تم استلام البيانات: ${response.length} عنصر");

      if (response.isNotEmpty) {
        boxInventoryorder.assignAll(response);
        statusrequest.value = STATUSREQUEST.success;

        // طباعة البيانات للتأكد
        for (var box in boxInventoryorder) {
          print("الصندوق: ${box.boxType.name}, الكمية: ${box.quantity}");
        }
      } else {
        statusrequest.value = STATUSREQUEST.failure;
      }
    } catch (e) {
      print("خطأ في تحميل البيانات: $e");
      statusrequest.value = STATUSREQUEST.servicefailer;
    } finally {
      _isLoading.value = false;
      update();
    }
  }
//==================================================== boxInverty

  int getAvailableQuantityByBoxName(String boxName) {
    try {
      var matchingBoxes = boxInventoryorder
          .where((box) => box.boxType.name == boxName)
          .toList();

      if (matchingBoxes.isEmpty) {
        return 0;
      }

      return matchingBoxes.fold(0, (sum, box) => sum + box.quantity);
    } catch (e) {
      print("خطأ في حساب الكمية المتوفرة: $e");
      return 0;
    }
  }

//====================================================
  // دالة لإضافة طلب جديد
  void addOrder() {
    // Get.toNamed(AppRoutes.addOrder);
    Get.to(() => OrderForm());
  }

  // دالة لتحميل الطلبات من المocker
  Future<void> loadMockOrders() async {
    statusrequest.value = STATUSREQUEST.loading;
    update();
    try {
      final userData = _myServices.sharedPreferences.getString('userData');
      if (userData == null) {
        statusrequest.value = STATUSREQUEST.failure;
        update();
        return;
      }

      final userId =
          Representative.fromJson(jsonDecode(userData)).id.toString();
      var responsev = await addOrderRespone.getorderapi(userId);

      if (responsev.isNotEmpty) {
        orders.assignAll(responsev);
        statusrequest.value = STATUSREQUEST.success;
      } else {
        statusrequest.value = STATUSREQUEST.failure;
      }
    } catch (e) {
      print('Error loading orders: $e');
      statusrequest.value = STATUSREQUEST.servicefailer;
    } finally {
      filteredOrders.value = orders;
      _isLoading.value = false;
      update();
    }
  }

  // دالة لفلترة الطلبات حسب الاستعلام
  void filteroreder(String query) {
    query = query.toLowerCase();
    isSearching.value = query.isNotEmpty;
    if (isSearching.value) {
      filteredOrders.value = orders.where((order) {
        final nameMatch = order.nameCline.toLowerCase().contains(query);
        final boxTypeMatch = order.orderItems.first.boxType?.name
                .toLowerCase()
                .contains(query) ??
            false;
        final idMatch = order.id.toString().contains(query);

        return nameMatch || boxTypeMatch || idMatch;
      }).toList();
    } else {
      filteredOrders.value = orders;
    }
  }

  // دالة للتنقل إلى تفاصيل الطلب
  void navigateToOrderDetails(Order order) {
    print('Navigating to order details with order ID: ${order.id}');
    Get.toNamed(AppRoutes.orderDetail, arguments: {'order': order});
  }

  // دالة لتحديث الطلبات
  Future<void> refreshOrders() async {
    loadMockOrders();
  }

  getFileType(File file) {}
}
