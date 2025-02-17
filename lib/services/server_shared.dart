import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
   var isFingerprintEnabled = false.obs;
  Future<MyServices> init() async {
  try {
    sharedPreferences = await SharedPreferences.getInstance();
    // Initialize the fingerprint state based on SharedPreferences
      isFingerprintEnabled.value =
          sharedPreferences.getString('fingerprint')?.isNotEmpty ?? false;
    return this;
  } catch (e) {
    throw Exception('Failed to initialize SharedPreferences: $e');
  }
}
void toggleFingerprint(bool value) async {
    if (value) {
      await sharedPreferences.setString('fingerprint', 'checked');
      isFingerprintEnabled.value = true;
      Get.snackbar("finget", "تم تفعيل البصمة");
    } else {
      await sharedPreferences.remove('fingerprint');
      isFingerprintEnabled.value = false;
      Get.snackbar("finget", "تم الغا ء البصمة ");
    }
  }
}

Future<void> initializeServices() async {
  await Get.putAsync(() => MyServices().init());
}