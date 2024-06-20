import 'package:dio/dio.dart';
import './api_client.dart';

class ApiUserProfile {
  final ApiClient _apiClient;

  ApiUserProfile(this._apiClient); // Constructor

  // Hàm getProfile lấy thông tin profile của người dùng
  Future<Response> getProfile() async {
    return _apiClient.get('user-profile/get-profile'); // Giả sử endpoint là '/users/my-profile'
  }

  // Hàm setProfile cập nhật hoặc tạo profile người dùng
  Future<Response> setProfile(Map<String, dynamic> profileData) async {
    return _apiClient.post('user-profile/set-profile', data: profileData); 
  }
}
