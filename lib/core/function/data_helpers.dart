
import '../constants/class/status_request.dart';

handeldata(responses) {
  if (responses is STATUSREQUEST) {
    return responses;
  } else {
    return STATUSREQUEST.success;
  }
}

// أضف أي دوال أخرى لمعالجة البيانات هنا
