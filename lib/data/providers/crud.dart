import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../core/function/check_internet.dart';
import '../../core/constants/class/status_request.dart';

// فئة لتنفيذ عمليات CRUD الأساسية (إنشاء، قراءة، تحديث، حذف)
class CRUD {
  // رؤوس HTTP الأساسية
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // معالج استجابة HTTP العام
  Either<STATUSREQUEST, T> _handleResponse<T>(
      http.Response response, T Function(String) parser) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(parser(response.body));
    }
    return Left(STATUSREQUEST.servicefailer);
  }

  // التحقق من اتصال الإنترنت
  Future<Either<STATUSREQUEST, T>> _withInternetCheck<T>(
      Future<Either<STATUSREQUEST, T>> Function() operation) async {
    if (!await chickInternet()) {
      return Left(STATUSREQUEST.offlinefailer);
    }
    return operation();
  }

  // طلب POST لإرسال البيانات
  Future<Either<STATUSREQUEST, Map>> postdata(String url, Map data) async {
    try {
      return await _withInternetCheck(() async {
        final response = await http.post(
          Uri.parse(url),
          headers: _headers,
          body: jsonEncode(data),
        );
        return _handleResponse(response, (body) => jsonDecode(body) as Map);
      });
    } catch (e) {
      print('Error in postdata: $e');
      return Left(STATUSREQUEST.servicefailer);
    }
  }

  // طلب DELETE لحذف البيانات
  Future<Map<String, dynamic>> deletePosts(String url) async {
    try {
      final response = await http.delete(Uri.parse(url));

      return switch (response.statusCode) {
        200 => jsonDecode(response.body),
        401 => {'error': STATUSREQUEST.error},
        _ => {'error': STATUSREQUEST.servicefailer}
      };
    } catch (e) {
      return {'error': STATUSREQUEST.servicefailer};
    }
  }

  // طلب PUT لتحديث البيانات
  Future<Either<STATUSREQUEST, Map>> updatedata(String url, Map data) async {
    try {
      return await _withInternetCheck(() async {
        final response = await http.put(Uri.parse(url), body: data);
        return _handleResponse(response, (body) => jsonDecode(body) as Map);
      });
    } catch (e) {
      return Left(STATUSREQUEST.servicefailer);
    }
  }

  // طلب GET لجلب البيانات
  Future<Either<STATUSREQUEST, dynamic>> getdata(String url) async {
    try {
      return await _withInternetCheck(() async {
        final response = await http.get(Uri.parse(url));
        return _handleResponse(response, (body) => jsonDecode(body));
      });
    } catch (e) {
      print('Exception in getdata: $e');
      return Left(STATUSREQUEST.servicefailer);
    }
  }
}
