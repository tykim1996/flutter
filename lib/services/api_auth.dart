import 'package:dio/dio.dart';
import './api_client.dart'; 

class ApiAuth {
  final ApiClient _apiClient;

  ApiAuth(this._apiClient); // Constructor

  Future<Response> signIn(String email, String password) async {
    return _apiClient.post('auth/sign-in',data:{
      'email': email,
      'password': password,
    });
  }

  Future<Response> signUp(String email, String password) async {
    return _apiClient.post('auth/sign-up', data:{
      'email': email,
      'password': password,
    });
  }
  Future<Response> checkEmailConfirmation(String token) async {
    return _apiClient.get('user/checkemail-Confirmation/$token');
  }

  Future<Response> signOut () async {
    return _apiClient.get('user/sign-out');
  }

}
