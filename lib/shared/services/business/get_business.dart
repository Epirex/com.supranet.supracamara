import 'package:dio/dio.dart';

class BusinessService {
  final Dio _dio = Dio();
  Future<dynamic> business(String id) async {
    try {
      Response response = await _dio.get(
        'https://api.videoon.app/api/business/$id',
      );
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }
}