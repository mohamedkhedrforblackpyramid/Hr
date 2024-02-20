import 'dart:io';
import 'package:dio/dio.dart';

import '../local/cache_helper.dart';
class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
          connectTimeout: Duration(
            seconds: 10
          ),

          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          receiveDataWhenStatusError: true,
          //  baseUrl: 'http://192.168.1.135:8000/')
          //  baseUrl: 'http://localhost:8000/')
        //  baseUrl: 'http://192.168.1.142:8000/',
         //   baseUrl: 'http://192.168.1.135:8000/'
        baseUrl: 'https://hr-api.alex4prog.com/'
      ),

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
    print(url);
    /* print(url);
    print(query);*/
    if (CacheHelper.getData(key: "token") != null) {
      dio.options.headers['Authorization'] = "Bearer ${CacheHelper.getData(key: "token")}";
    }
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> formData,
  }) async {
    if (CacheHelper.getData(key: "token") != null) {
      dio.options.headers['Authorization'] = "Bearer ${CacheHelper.getData(key: "token")}";
    }
    return await dio.post(url, queryParameters: query, data: formData);
  }

  static Future<Response> postFormData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> formData,
  }) async {
    if (CacheHelper.getData(key: "token") != null) {
      dio.options.headers['Authorization'] = "Bearer ${CacheHelper.getData(key: "token")}";
    }
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    return await dio.post(url,
        queryParameters: query, data: FormData.fromMap(formData));
  }
  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> formData,
  }) async {
    if (CacheHelper.getData(key: "token") != null) {
      dio.options.headers['Authorization'] = "Bearer ${CacheHelper.getData(key: "token")}";
    }
    return await dio.patch(url,
        queryParameters: query, data: FormData.fromMap(formData));
  }
}
