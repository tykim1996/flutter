import 'package:dio/dio.dart';
import './api_client.dart'; 

class ApiOtp {
  final ApiClient _apiClient;

  ApiOtp(this._apiClient); // Constructor

  Future<Response> getOtp(String phoneNumber) async {
    return _apiClient.post('user/get-otp',data:{
      'phoneNumber': phoneNumber,
    });
  }
  Future<Response> verifyOtp(String token, String otpCode) async {
    return _apiClient.post('user/verify-Otp',data:{
      'token': token,
      'otpCode': otpCode,
    });
  }
}
