import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/class/status_request.dart';
import '../../data/models/auth/login_response_model.dart';
import '../../data/models/box_inventory_model.dart';
import '../../data/repositories/order_respone.dart';
import '../../services/server_shared.dart';

class OrderController extends GetxController {
  var formData = {
    'customerName': '',
    'phone': '',
    'address': '',
    'boxType': '',
    'quantity': '',
    'price': '',
    'delivery': '',
    'date': '',
    'notes': '',
    'items': <Map<String, dynamic>>[],
  }.obs;

  // إضافة متغير لحالة التحميل
  final Rx<STATUSREQUEST> statusRequest = STATUSREQUEST.none.obs;
  final MyServices _myServices = Get.find<MyServices>();
  final _isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final AddOrderRespone addOrderRespone = AddOrderRespone(Get.find());
  final RxList<BoxInventory> boxInventory = <BoxInventory>[].obs;
  void updateItems(List<Map<String, dynamic>> items) {
    formData['items'] = items;
  }

  void submitForm() async {
    try {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();

      statusRequest.value = STATUSREQUEST.loading;

      final userData = _myServices.sharedPreferences.getString('userData');
      if (userData == null) return;

      final representative = Representative.fromJson(jsonDecode(userData));

      final items =
          (formData['items'] as List<Map<String, dynamic>>).map((item) {
        return {
          'box_type_id': _getBoxTypeId(item['type'] ?? ''),
          'quantity': int.tryParse(item['quantity']?.toString() ?? '0') ?? 0,
          'price': double.tryParse(item['price']?.toString() ?? '0.0') ?? 0.0,
        };
      }).toList();

      final success = await addOrderRespone.addOrder(
          representative.id,
          formData['date'].toString(),
          formData['delivery'].toString(),
          formData['customerName'].toString(),
          formData['phone'].toString(),
          formData['address'].toString(),
          formData['notes'].toString(),
          items);

      if (success) {
        statusRequest.value = STATUSREQUEST.success;
        Get.snackbar(
          'نجاح',
          'تم إضافة الطلب بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(closeOverlays: true); // للرجوع للشاشة السابقة
      } else {
        statusRequest.value = STATUSREQUEST.failure;
        Get.snackbar(
          'خطأ',
          'فشل في إضافة الطلب',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error submitting form: $e');
      statusRequest.value = STATUSREQUEST.servicefailer;
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إضافة الطلب',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
   Future<void> loadBoxInvertoy() async {
    try {
      statusRequest.value = STATUSREQUEST.loading;
      _isLoading.value = true;
      update();

      final response = await addOrderRespone.getboxInventory();

      print("تم استلام البيانات: ${response.length} عنصر");

      if (response.isNotEmpty) {
        boxInventory.assignAll(response);
        statusRequest.value = STATUSREQUEST.success;

        // طباعة البيانات للتأكد
        for (var box in boxInventory) {
          print("الصندوق: ${box.boxType.name}, الكمية: ${box.quantity}");
        }
      } else {
        statusRequest.value = STATUSREQUEST.failure;
      }
    } catch (e) {
      print("خطأ في تحميل البيانات: $e");
      statusRequest.value = STATUSREQUEST.servicefailer;
    } finally {
      _isLoading.value = false;
      update();
    }
  }
//==================================================== boxInverty

  int getAvailableQuantityByBoxName(String boxName) {
    try {
      var matchingBoxes =
          boxInventory.where((box) => box.boxType.name == boxName).toList();

      if (matchingBoxes.isEmpty) {
        return 0;
      }

      return matchingBoxes.fold(0, (sum, box) => sum + box.quantity);
    } catch (e) {
      print("خطأ في حساب الكمية المتوفرة: $e");
      return 0;
    }
  }

  int _getBoxTypeId(String boxTypeName) {
    // Implement your box type ID mapping logic here
    // Example:
    switch (boxTypeName) {
      case 'B1':
        return 1;
      case 'B2':
        return 2;
      case 'B3':
        return 3;
      default:
        return 0;
    }
  }
  @override
  void onInit() {
    super.onInit();
    loadBoxInvertoy();
  }
  bool get hasItems {
    final items = formData['items'] as List<Map<String, dynamic>>;
    return items.isNotEmpty;
  }
}
