import 'package:get/get.dart';
import 'package:manadeebapp/data/models/order_model.dart';

// كلاس لتحكم بتفاصيل الطلب
// هذا الكلاس مسؤول عن إدارة تفاصيل الطلب في التطبيق. يحتوي على متغير للاحتفاظ بتفاصيل الطلب
// ويقوم بتحميل هذه التفاصيل من الحجج الممررة إليه. كما يحتوي على دالة لتنسيق التاريخ من صيغة ISO 8601
// إلى صيغة YYYY-MM-DD. يضمن هذا الكلاس أن تفاصيل الطلب محدثة دائماً من خلال إضافة مستمع للتغييرات
// في متغير تفاصيل الطلب.

class OrderDetailsController extends GetxController {
  final Rx<Order?> orderDetails = Rx<Order?>(null);
  Worker? _orderWorker;

  @override
  void onInit() {
    super.onInit();
    // إضافة مستمع للتغييرات في تفاصيل الطلب
    _orderWorker = ever(orderDetails, (order) {
      print('Order details updated: ${order?.id}');
    });
    _loadOrderDetails();
  }

  @override
  void onClose() {
    _orderWorker?.dispose();
    super.onClose();
  }

  // دالة لتحميل تفاصيل الطلب
  void _loadOrderDetails() {
    try {
      if (Get.arguments != null && Get.arguments['order'] != null) {
        final order = Get.arguments['order'] as Order;
        print('Loading order details: ${order.id}');
        orderDetails.value = order;
      } else {
        print('No order details provided in arguments');
      }
    } catch (e) {
      print('Error loading order details: $e');
    }
  }

  // دالة لتنسيق التاريخ
  // دالة لتنسيق التاريخ من صيغة ISO 8601 إلى صيغة YYYY-MM-DD
  String formatDate(String dateString) {
    try {
      // إذا كان التاريخ فارغا، إرجاع سلسلة فارغة
      if (dateString.isEmpty) return '';
      // تحويل السلسلة إلى كائن تاريخ
      DateTime dateTime = DateTime.parse(dateString);
      // إرجاع التاريخ بتنسيق YYYY-MM-DD
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      // في حالة حدوث خطأ أثناء تنسيق التاريخ، طباعة الخطأ وإرجاع التاريخ الأصلي
      print('Error formatting date: $e');
      return dateString;
    }
  }
}
