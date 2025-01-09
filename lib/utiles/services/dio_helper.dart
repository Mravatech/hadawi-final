
import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static dioInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://didagptmodule-e6itil5y3q-uc.a.run.app/api/v1/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    dio!.options.headers = {
      'Authorization': 'Bearer ',
      'Content-Type': 'application/json',
    };
    final res = await dio!.get(url, queryParameters: query,);
    return res;
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    dio!.options.headers = {
      'Authorization': 'Bearer ',
      'Content-Type': 'application/json',
    };
    final res= dio!.post(url,data: body);
    return res;
  }
}