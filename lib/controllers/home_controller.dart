import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:manadeebapp/services/server_shared.dart';

import '../core/constants/class/status_request.dart';
import '../data/models/box_inventory_model.dart';
import '../data/models/communicationlog.dart';
import '../data/repositories/order_respone.dart';

// فئة لتحكم الصفحة الرئيسية
class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final _selectedIndex = 0.obs;
  final _username = ''.obs;
  final _usersemail = ''.obs;
  // final _titles = ['supportAgent', 'Orders', 'Add Order', 'Notes'];
  final MyServices _myServices = Get.find<MyServices>();

  // الحصول على عنوان الصفحة الحالية
  // String get currentTitle => _titles[_selectedIndex.value];
  // الحصول على فهرس الصفحة الحالية
  int get selectedIndex => _selectedIndex.value;
  // الحصول على اسم المستخدم
  String get username => _username.value;
  // الحصول على بريد المستخدم
  String get email => _usersemail.value;
  // ignore: unused_field
  final _logger = Logger();
  final Rx<STATUSREQUEST> statusRequest = STATUSREQUEST.none.obs;
  final _isLoading = false.obs;
  final AddOrderRespone addOrderRespone = AddOrderRespone(Get.find());
  final RxList<BoxInventory> boxInventory = <BoxInventory>[].obs;
  @override
  void onInit() {
    super.onInit();
    _initializeUserData();
    _initializeAnimationController();
    loadBoxInvertoy();
    print(_myServices.sharedPreferences.getString('userData'));
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

  // تهيئة بيانات المستخدم
  void _initializeUserData() {
    try {
      final userData = _myServices.sharedPreferences.getString('userData');
      if (userData != null) {
        final representative = Representative.fromJson(jsonDecode(userData));
        _username.value = representative.name.toString();
        _usersemail.value = representative.email.toString();
      } else {
        _username.value = 'Guest';
        _usersemail.value = 'No Email';
      }
    } catch (e) {
      debugPrint('Error initializing user data: $e');
      _username.value = 'Guest';
      _usersemail.value = 'No Email';
    }
  }

  // تهيئة محرك الرسوم المتحركة
  void _initializeAnimationController() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  // تغيير لون التبديل
  void changeTab(int index) {
    _selectedIndex.value = index;
  }

  // تغيير الوضع بين النهار والليل
  // void toggleTheme() {
  //   Get.changeThemeMode(
  //     Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
  //   );
  // }
}
