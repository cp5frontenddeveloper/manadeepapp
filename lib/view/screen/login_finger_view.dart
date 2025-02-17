import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/controllers/login_finger_controller.dart';

class LoginFingerView extends StatelessWidget {
  LoginFingerView({super.key});
  final LoginFingerController controller = Get.put(LoginFingerController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  // AppBar widget
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('8'.tr),
      automaticallyImplyLeading: false,
    );
  }

  // Body widget with fingerprint authentication
  Widget _buildBody() {
    return Center(
      child: FutureBuilder<bool>(
        future: controller.fingerprintLogin(),
        builder: _buildFingerprintState,
      ),
    );
  }

  // Builder for fingerprint authentication states
  Widget _buildFingerprintState(
      BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoadingState();
    } else if (snapshot.hasError) {
      return _buildErrorState(snapshot.error);
    } else {
      return _buildAuthenticationResult(snapshot.data);
    }
  }

  // Loading state widget
  Widget _buildLoadingState() {
    return const CircularProgressIndicator();
  }

  // Error state widget
  Widget _buildErrorState(Object? error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('9: $error'), const SizedBox(height: 20)],
    );
  }

  // Authentication result widget
  Widget _buildAuthenticationResult(bool? isAuthenticated) {
    if (isAuthenticated == true) {
      return Text('10'.tr);
    }
    if (!controller.myServices.isFingerprintEnabled.value) {
      return Text('11'.tr);
    }
    return Text('12'.tr);
  }
}
