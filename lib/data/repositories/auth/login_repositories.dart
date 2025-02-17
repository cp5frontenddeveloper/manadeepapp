import 'package:manadeebapp/data/models/auth/login_response_model.dart';

import '../../providers/crud.dart';
import '../../providers/link/api_endpoints.dart';

class LoginRepositories {
  final CRUD crud;
  LoginRepositories(this.crud);

  Future<LoginResponse> Loginfunction(String email, String password) async {
    var response = await crud
        .postdata(loginPageLink, {'email': email, 'password': password});

    return response.fold(
        (error) => LoginResponse(
              status: false,
              message: error.toString(),
              token: '',
            ),
        (data) => LoginResponse.fromJson(data.cast<String, dynamic>()));
  }

  Future<Map<String, dynamic>>? updatepassword(
      String email, String newPassword) async {
    var respones = await crud.postdata(
        resetPasswordEndpoint, {"email": email, "new_password": newPassword});
    return respones.fold((error) => {
          "status": false,
          "message": error.toString(),
        }, (data) {
          return data.cast<String, dynamic>();
        });
  }
}
