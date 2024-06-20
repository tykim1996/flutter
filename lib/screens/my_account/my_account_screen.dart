import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/services/api_client.dart';
import 'package:shop_app/services/api_userProfile.dart';

import '../../models/UserProfile.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});
  static String routeName = "/myAccount";
  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final ApiUserProfile _apiUserProfile = ApiUserProfile(ApiClient());
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    getProfile(); 
  }
  Future<UserProfile?> getProfile() async {
    try {
        final response = await _apiUserProfile.getProfile();

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonData = response.data;
          final fetchedProfile = UserProfile.fromJson(jsonData);
          setState(() {
            userProfile = fetchedProfile;
          });
          return userProfile; 
        } else {
          return null;
        }   

    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data['msg']); 
      }
      return null; 
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userProfile != null
          ? Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800), // Giới hạn chiều rộng tối đa cho container
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Để column chỉ chiếm không gian cần thiết
                      children: [
                        ListTile(
                          title: Text('First Name:'),
                          trailing: Text(userProfile!.firstName ?? ''),
                        ),
                        ListTile(
                          title: Text('Last Name:'),
                          trailing: Text(userProfile!.lastName ?? ''),
                        ),
                        ListTile(
                          title: Text('Phone Number:'),
                          trailing: Text(userProfile!.phoneNumber ?? ''),
                        ),
                        ListTile(
                          title: Text('Address:'),
                          trailing: Text(userProfile!.address ?? ''),
                        ),
                        ListTile(
                          title: Text('email:'),
                          trailing: Text(userProfile!.email ?? ''),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}