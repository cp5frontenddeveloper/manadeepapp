import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/class/status_request.dart';
import '../../data/models/communicationlog.dart';
import '../../data/repositories/auth/login_repositories.dart';
import '../../routes/app_pages.dart';
import '../../services/server_shared.dart';
import '../../view/widget/sharedwidget/dialogs/custom_alert_dialog.dart';

class LoginPageController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final LoginRepositories loginRepositories;
  final statusRequest = STATUSREQUEST.none.obs;
  final MyServices _myServices;
  bool _isDisposed = false;
  STATUSREQUEST get state => statusRequest.value;
  LoginPageController({
    required this.loginRepositories,
    required MyServices myServices,
  }) : _myServices = myServices;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    try {
      if (!_myServices.sharedPreferences.containsKey('userData')) {
        // Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      debugPrint('Error initializing controller: $e');
    }
  }

  void safeSetState(Function() updateFn) {
    if (!_isDisposed) {
      updateFn();
      update();
    }
  }

  Future<void> login() async {
    if (!_isFormValid) return;
    try {
      safeSetState(() => statusRequest.value = STATUSREQUEST.loading);

      final response = await loginRepositories.Loginfunction(
          emailController.text, passwordController.text);

      if (_isDisposed) return;

      if (response.status) {
        await _myServices.sharedPreferences.setString('token', response.token);
        if (response.representative != null) {
          await _myServices.sharedPreferences.setString(
              'userData', jsonEncode(response.representative?.toJson()));
        }
        safeSetState(() => statusRequest.value = STATUSREQUEST.success);
        _showMessage('Success', response.message);
       emailController.clear();
       passwordController.clear();
        Get.offAllNamed(AppRoutes.home);
      } else {
        safeSetState(() => statusRequest.value = STATUSREQUEST.failure);
        _showMessage('Error', response.message, isSuccess: false);
        await Future.delayed(const Duration(seconds: 2));
        _resetLoginForm();
      }
    } catch (e) {
      if (!_isDisposed) {
        safeSetState(() => statusRequest.value = STATUSREQUEST.failure);
        _showMessage('Error', 'Login failed: $e', isSuccess: false);
        await Future.delayed(const Duration(seconds: 2));
        _resetLoginForm();
      }
    }
  }

  void showdilaog(BuildContext context) {
    if (!_isDisposed && context.mounted) {
      CustomAlertDialog.show(
        context: context,
        title: "94".tr,
        label: "6".tr,
        hint: "95".tr,
        confirmButtonText: '96'.tr,
        cancelButtonText: '79'.tr,
        onConfirm: (value) {
          if (!_isDisposed && value.isNotEmpty) {
            updatePassword(value['main']!);
          }
        },
      );
    }
  }

  Future<void> updatePassword(String password) async {
    if (_isDisposed) return;

    try {
      safeSetState(() => statusRequest.value = STATUSREQUEST.loading);

      final userData = _myServices.sharedPreferences.getString('userData');
      if (userData == null) {
        throw Exception('User data not found');
      }

      final representative = Representative.fromJson(jsonDecode(userData));
      // ignore: unnecessary_null_comparison
      if (representative.email == null) {
        throw Exception('Email not found in user data');
      }

      final response = await loginRepositories.updatepassword(
          representative.email, password);

      if (_isDisposed) return;

      if (response != null && response['status'] == true) {
        _handleSuccessfulUpdate(response);
      } else {
        _handleFailedUpdate(response);
      }
    } catch (e) {
      _handleUpdateError(e);
    }
  }

  void _handleSuccessfulUpdate(Map<String, dynamic> response) {
    safeSetState(() => statusRequest.value = STATUSREQUEST.success);
    Get.back();
    _showMessage('Success', response['message'] ?? '97'.tr);
  }

  void _handleFailedUpdate(Map<String, dynamic>? response) {
    safeSetState(() => statusRequest.value = STATUSREQUEST.failure);
    _showMessage('Error', response?['message'] ?? '98'.tr, isSuccess: false);
  }

  void _handleUpdateError(dynamic error) {
    if (!_isDisposed) {
      safeSetState(() => statusRequest.value = STATUSREQUEST.failure);
      _showMessage('Error', '99'.tr + ': $error', isSuccess: false);
    }
  }

  void _showMessage(String title, String message, {bool isSuccess = true}) {
    if (!_isDisposed) {
      Get.snackbar(
        title,
        message,
        backgroundColor:
            isSuccess ? const Color(0xFF00FF00) : const Color(0xFFFF0000),
        colorText: const Color(0xFF000000),
      );
    }
  }

  bool get _isFormValid => formkey.currentState?.validate() ?? false;

  void _resetLoginForm() {
    if (!_isDisposed) {
      emailController.clear();
      passwordController.clear();
      safeSetState(() => statusRequest.value = STATUSREQUEST.none);
    }
  }
}
