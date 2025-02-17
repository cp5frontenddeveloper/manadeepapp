// استيراد المكتبات اللازمة
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_communication_controller.dart';

// قائمة وجهات التنقل في التطبيق
final navigationDestinations = [
  // وجهة التواصل الإداري مع عرض شارة للإشعارات غير المقروءة
  NavigationDestination(
    icon: Obx(() {
      final controller = Get.find<AdminCommunicationController>();
      return Badge(
        isLabelVisible: controller.unreadCount > 0,
        label: Text('${controller.unreadCount}'),
        child: Icon(Icons.support_agent_outlined,
            color: Get.theme.colorScheme.onSurface),
      );
    }),
    selectedIcon: Obx(() {
      final controller = Get.find<AdminCommunicationController>();
      return Badge(
        isLabelVisible: controller.unreadCount > 0,
        label: Text('${controller.unreadCount}'),
        child: Icon(Icons.support_agent, color: Get.theme.colorScheme.primary),
      );
    }),
    label: '91'.tr,
  ),
  // وجهة عرض الطلبات
  NavigationDestination(
    icon: Icon(Icons.list_outlined, color: Get.theme.colorScheme.onSurface),
    selectedIcon: Icon(Icons.list, color: Get.theme.colorScheme.primary),
    label: '92'.tr,
  ),
  // وجهة إضافة طلب جديد
  NavigationDestination(
    icon:
        Icon(Icons.add_circle_outline, color: Get.theme.colorScheme.onSurface),
    selectedIcon: Icon(Icons.add_circle, color: Get.theme.colorScheme.primary),
    label: '78'.tr,
  ),
  // وجهة عرض الملاحظات
  NavigationDestination(
    icon: Icon(Icons.note_outlined, color: Get.theme.colorScheme.onSurface),
    selectedIcon: Icon(Icons.note, color: Get.theme.colorScheme.primary),
    label: '93'.tr,
  ),
];
