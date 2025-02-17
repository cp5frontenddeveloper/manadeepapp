import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

/// مكتبة للتحقق من البصمة والمصادقة البيومترية
class FingerprintAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  /// دالة للتحقق من دعم الجهاز للبصمة
  /// تعيد true إذا كان الجهاز يدعم البصمة، و false إذا لم يكن يدعمها
  Future<bool> isBiometricsSupported() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      print("Error checking biometrics support: $e");
      return false;
    }
  }

  /// دالة للمصادقة باستخدام البصمة
  /// تأخذ نص السبب الذي سيظهر للمستخدم
  /// تعيد true إذا نجحت المصادقة، و false إذا فشلت
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'المصادقة مطلوبة',
            cancelButton: 'إلغاء',
          ),
          IOSAuthMessages(
            cancelButton: 'إلغاء',
          ),
        ],
      );
    } catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}
