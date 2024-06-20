import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/services/api_auth.dart';
import 'package:shop_app/services/api_client.dart';

class ProfileProvider with ChangeNotifier {
    final ApiAuth _apiAuth = ApiAuth(ApiClient());

    Future<bool> signOut (BuildContext context) async {
      try {
        final response = await _apiAuth.signOut();
        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, "/sign_in");
          return true;
        } 
        return false ;

      } on DioException catch (e) {
        if (e.response != null) {
          print(e.response);
        }
         return false ;
      }
    }
}