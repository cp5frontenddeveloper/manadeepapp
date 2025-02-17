import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../core/constants/class/status_request.dart';
import '../data/models/communicationlog.dart';
import '../data/repositories/admin_communication_logs.dart';
import '../services/server_shared.dart';
import '../view/widget/sharedwidget/dialogs/custom_alert_dialog.dart';

class AdminCommunicationController extends GetxController {
  final AdminCommunicationLogs _repository;
  final MyServices _myServices;

  // متغيرات الحالة المدمجة
  final RxList<CommunicationLog> logs = <CommunicationLog>[].obs;
  final Rx<STATUSREQUEST> status = STATUSREQUEST.none.obs;
  var isDialogOpen = false.obs;
  var selectedNotification = <String, dynamic>{}.obs;
  var newNote = ''.obs;

  AdminCommunicationController(this._repository, this._myServices);

  @override
  void onInit() {
    super.onInit();
    // fetchLogsdata();
    fetchLogs();
  }

  // Future<void> fetchLogsdata() async {
  //   logs.value = [
  //     CommunicationLog(
  //       id: 1,
  //       representativeId: 101,
  //       title:
  //           '"تمت متابعة العميل وأبدى اهتمامه بالخدمة، وقد طلب مزيدًا من المعلومات حول الخدمة وسيتم إرسالها إليه خلال اليوم.',
  //       date: DateTime.now().subtract(Duration(days: 2)),
  //       isNew: true,
  //       note: null,
  //       createdAt: DateTime.now().subtract(Duration(days: 2, hours: 3)),
  //       updatedAt: DateTime.now().subtract(Duration(days: 1, hours: 1)),
  //       representative: Representative(
  //         id: 101,
  //         name: 'أحمد محمد',
  //         phoneNumber: '0123456789',
  //         email: 'ahmed@example.com',
  //         createdAt: DateTime.now().subtract(Duration(days: 100)),
  //         updatedAt: DateTime.now().subtract(Duration(days: 1)),
  //       ),
  //     ),
  //     CommunicationLog(
  //       id: 2,
  //       representativeId: 102,
  //       title: 'اجتماع مع العميل',
  //       date: DateTime.now().subtract(Duration(days: 5)),
  //       isNew: false,
  //       note: 'تمت مناقشة الشروط وتم الاتفاق على التواصل لاحقًا.',
  //       createdAt: DateTime.now().subtract(Duration(days: 5, hours: 2)),
  //       updatedAt: DateTime.now().subtract(Duration(days: 4, hours: 3)),
  //       representative: Representative(
  //         id: 102,
  //         name: 'سالم علي',
  //         phoneNumber: '0987654321',
  //         email: 'salem@example.com',
  //         createdAt: DateTime.now().subtract(Duration(days: 150)),
  //         updatedAt: DateTime.now().subtract(Duration(days: 2)),
  //       ),
  //     ),
  //     CommunicationLog(
  //       id: 3,
  //       representativeId: 103,
  //       title: 'استفسار عن المنتج',
  //       date: DateTime.now().subtract(Duration(days: 1)),
  //       isNew: true,
  //       note: 'العميل استفسر عن المزايا التقنية وتم الرد عليه.',
  //       createdAt: DateTime.now().subtract(Duration(days: 1, hours: 5)),
  //       updatedAt: DateTime.now().subtract(Duration(hours: 12)),
  //       representative: Representative(
  //         id: 103,
  //         name: 'نورة عبدالله',
  //         phoneNumber: '01122334455',
  //         email: 'noura@example.com',
  //         createdAt: DateTime.now().subtract(Duration(days: 200)),
  //         updatedAt: DateTime.now().subtract(Duration(days: 3)),
  //       ),
  //     ),
  //   ];

  //   // **ترتيب الرسائل حسب التاريخ الأحدث**
  //   logs.sort((a, b) => b.date.compareTo(a.date));
  // }

  Future<void> fetchLogs() async {
    try {
      status.value = STATUSREQUEST.loading;
      final userData = _myServices.sharedPreferences.getString('userData');
      print('UserData from SharedPreferences: $userData');

      if (userData == null) {
        print('No userData found in SharedPreferences');
        status.value = STATUSREQUEST.failure;
        return;
      }

      final userId =
          Representative.fromJson(jsonDecode(userData)).id.toString();
      print('Fetching logs for userId: $userId');

      final result = await _repository.getLogs(userId);
      print('Fetched logs: ${result.length}');

      logs.value = result;
      status.value = STATUSREQUEST.success;
    } catch (e, stackTrace) {
      print('Error fetching logs: $e');
      print('Stack trace: $stackTrace');
      status.value = STATUSREQUEST.servicefailer;
    }
  }

  // إضافة خاصية محسوبة للإشعارات غير المقروءة
  int get unreadCount =>
      logs.where((log) => log.isNew || log.note == null).length;

  void handleNotificationClick(CommunicationLog log) {
    // السماح بالنقر إذا كان إما جديدًا أو لا يوجد ملاحظة
    if (!log.isNew && log.note != null) return;
    CustomAlertDialog.show(
      context: Get.context!,
      title: log.title,
      label: 'الرد',
      hint: 'يرجى الرد على الرساله ',
      confirmButtonText: 'ارسال',
      barrierDismissible: false,
      showCancelButton: false,
      onConfirm: (values) async {
        await updateNote(log.id, values['main'] ?? '');
      },
    );
  }

  final _logger = Logger();

  Future<void> updateNote(int logId, String note) async {
    try {
      final success = await _repository.updatelogs(logId.toString(), note);
      if (success) {
         await fetchLogs();
        // await fetchLogsdata();
      }
    } catch (e) {
      _logger.e('Error updating note: $e');
    }
    // سيتم تنفيذ استدعاء API
    // // تحديث السجلات بعد التحديث
  }

  void refreshLogs() async {
    status.value = STATUSREQUEST.loading;
    try {
      logs.value = await _repository
          .getLogs(_myServices.sharedPreferences.getString('userId')!);
      status.value = STATUSREQUEST.success;
    } catch (e) {
      status.value = STATUSREQUEST.failure;
    }
  }
}

Color getNotificationColor(Map<String, dynamic> notification) {
  if (notification['note'] != null && notification['note'].isNotEmpty) {
    return Colors.green[50]!;
  }
  if (notification['isNew']) {
    return Colors.blue[50]!;
  }
  return Colors.grey[50]!;
}
