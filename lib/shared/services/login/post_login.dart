import 'package:dio/dio.dart';

class LoginService {
  final Dio _dio = Dio();
  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'https://api.videoon.app/api/login',
        data: {
          "email": email,
          "password": password
        },
      );
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }
}