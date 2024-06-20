import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';
//import 'package:shop_app/main.dart';

class ApiClient {
  late final Dio dio;
  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api/', 
        connectTimeout: Duration(seconds: 5), 
        receiveTimeout: Duration(seconds: 3),
        headers: {
        HttpHeaders.userAgentHeader: 'dio',
        'common-header': 'xx',
        },
      ),
    ); 
    dio.options.extra = {'withCredentials': true};
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {         
        return handler.next(options);
      },

      onResponse: (response, handler) async {
        return handler.next(response); 
      },
      onError: (DioException e, handler) {        

        if (e.response?.statusCode == 400) {
          print('Lỗi 400 Bad Request: ${e.response?.data}');
        }
        if (e.response?.statusCode == 401) {
          print('Lỗi 401 Bad Request: ${e.response?.data}');
          if (!e.response?.data['success']) {
            //navigatorKey.currentState?.pushNamedAndRemoveUntil('/sign_in', (Route<dynamic> route) => false);

          }
        }
        return handler.next(e);
      },
    ));
  }
    Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.put(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.delete(endpoint, data: data);
      return response;
    } catch (e) {
      // Xử lý lỗi nếu có
      rethrow;
    }
  }
}
