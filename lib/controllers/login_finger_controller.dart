import 'package:get/get.dart';
import 'package:manadeebapp/core/constants/fingerprint_auth.dart';
import 'package:manadeebapp/routes/app_pages.dart';
import 'package:manadeebapp/services/server_shared.dart';

class LoginFingerController extends GetxController {
  // Dependencies
  final FingerprintAuth _fingerprintAuth = FingerprintAuth();
  final MyServices myServices = Get.find<MyServices>();

  // Authentication Methods
  Future<bool> fingerprintLogin() async {
    try {
      if (!myServices.isFingerprintEnabled.value) {
        // await Get.offAllNamed(AppRoutes.login);
        return false;
      }

      final isBiometricsSupported =
          await _fingerprintAuth.isBiometricsSupported();
      if (!isBiometricsSupported) {
        print("Biometrics not supported");
        // await Get.offAllNamed(AppRoutes.login);
        return false;
      }

      final result =
          await _fingerprintAuth.authenticate("تسجيل الدخول بالبصمة");
      print("Authentication result: $result");

      if (result) {
        await Get.offAllNamed(AppRoutes.home);
      }
      return result;
    } catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}
