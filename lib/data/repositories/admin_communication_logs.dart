// استيراد المكتبات اللازمة
import 'package:manadeebapp/data/providers/crud.dart';

import '../models/communicationlog.dart';
import '../providers/link/api_endpoints.dart';

// فئة للتعامل مع سجلات التواصل الإدارية
class AdminCommunicationLogs {
  // متغير للتعامل مع عمليات CRUD
  final CRUD crud;

  // منشئ الفئة
  AdminCommunicationLogs(this.crud);

  // دالة لجلب سجلات التواصل لمستخدم معين
  Future<List<CommunicationLog>> getLogs(String iduser) async {
    try {
      // جلب البيانات من API
      final response =
          await crud.getdata(getAdminConnectNotificationEndpoint(iduser));
      // معالجة الاستجابة باستخدام Either
      return response.fold(
        // في حالة حدوث خطأ
        (error) {
          print('Error fetching logs: $error');
          return [];
        },
        // في حالة نجاح العملية
        (data) {
          print('Raw API response: $data');
          // تحويل البيانات إلى كائن ApiResponse
          final apiResponse =
              ApiResponse.fromJson(data as Map<String, dynamic>);
          return apiResponse.notifications;
        },
      );
    } catch (e) {
      // التقاط أي استثناءات غير متوقعة
      print('Exception in getLogs: $e');
      return [];
    }
  }

  Future<bool> updatelogs(String id, String note) async {
    try {
      final Response =
          await crud.updatedata(updateNotificationEndpoint(id), {'note': note});
      return Response.fold((error) {
        print('Error update logs:$error');
        return false;
      }, (data) {
        print("update successful:$data");
        return true;
      });
    } catch (e) {
      print("Exception in updatelogs:$e");
      return false;
    }
  }

}
