

import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_client.dart';
import '../../services/api_otp.dart';

import 'package:dio/dio.dart';

class OtpResponse {
  final bool success;
  final Response? response;
  final String? error;

  OtpResponse({
    required this.success,
    this.response,
    this.error,
  });
}

final ApiOtp _apiOtp = ApiOtp(ApiClient());

Future<OtpResponse> getOtp(String phoneNumber) async {
  try {
    final response = await _apiOtp.getOtp(phoneNumber);

    if (response.statusCode != 200) {
      return OtpResponse(
        success: false,
        response: response,
        error: 'Server error: ${response.statusCode}',
      );
    }
    final Map<String, dynamic> data = response.data; 
    final tokenOtp = data['token'] as String?; 
    if (tokenOtp == null || tokenOtp.isEmpty) {
      return OtpResponse(
        success: false,
        response: response,
        error: 'Invalid OTP token from server',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokenOtp', tokenOtp);
    return OtpResponse(success: true, response: response);

  } on DioException catch (e) {
    final errorMessage = e.response?.data ?? e.message;
    print('Error getting OTP: ${errorMessage["error"]}');
    return OtpResponse(success: false, response: e.response, error: errorMessage["error"]);
  }
}
Future<OtpResponse> verifyOtp(String otpCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenOtp = prefs.getString('tokenOtp');

      if (tokenOtp == null) {
        return OtpResponse(
          success: false,
          error: 'Missing OTP token. Please request a new OTP.',
        );
      }

      final response = await _apiOtp.verifyOtp(tokenOtp, otpCode,);
      if (response.statusCode == 200) {
        await prefs.remove('tokenOtp'); 
        return OtpResponse(success: true, response: response);
      } else {
        final errorMessage = response.data ?? 'OTP verification failed';
        return OtpResponse(
          success: false,
          response: response,
          error: errorMessage,
        );
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data ?? e.message;
      print('Error verifying OTP: ${errorMessage["error"]}');
      return OtpResponse(success: false, response: e.response, error: errorMessage["error"]);
    }
  }