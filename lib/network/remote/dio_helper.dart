import 'dart:io';
import 'package:dio/dio.dart';

import '../local/cache_helper.dart';
class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
          receiveDataWhenStatusError: true,
          //  baseUrl: 'http://192.168.1.135:8000/')
          //   baseUrl: 'http://192.168.1.135:8000/')
         // baseUrl: 'http://192.168.1.142:8000/'),
          baseUrl: 'http://192.168.1.135:8000/'),
    );
    /*   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };*/
  }
  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    int? id,
    bool auth = false
  }) async {
    /* print(url);
    print(query);*/
    if (CacheHelper.getData(key: "token") != null) {
      print('got token');
      dio.options.headers = {
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
      };
      dio.options.headers['Authorization'] = "Bearer ${CacheHelper.getData(key: "token")}";
    }
    print(dio.options);

    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> formData,
  }) async {  if (CacheHelper.getData(key: "token") != null) {
    print('got token');
    dio.options.headers = {
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/json',
    };
    dio.options.headers['Authorization'] = "Bearer ${CacheHelper.getData(key: "token")}";
  }

    // print(formData);
    return await dio.post(url, queryParameters: query, data: formData);
  }

  static Future<Response> postFormData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> formData,
  }) async {
    // print(FormData.fromMap(formData));
    return await dio.post(url,
        queryParameters: query, data: FormData.fromMap(formData));
  }
  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> formData,
  }) async {
    return await dio.patch(url,
        queryParameters: query, data: FormData.fromMap(formData));
  }
}
