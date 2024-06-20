import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_client.dart';
import '../../../services/api_auth.dart';

class EmailVerificationDialog extends StatefulWidget {
  @override
  _EmailVerificationDialogState createState() => _EmailVerificationDialogState();
}

class _EmailVerificationDialogState extends State<EmailVerificationDialog> {
  bool isVerifying = true;
  Timer? _timer;
  final ApiAuth _apiAuth = ApiAuth(ApiClient());


  @override
  void initState() {
    super.initState();
    handleEmailConfirmation();
  }
Future<bool> checkEmailConfirmation(String token) async {
  try {
    final response = await _apiAuth.checkEmailConfirmation(token);
    if (response.statusCode == 200) {
      return response.data!['isVerified'] as bool;
    } else {
      return false; 
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print("err log : ${e.response!.data["msg"]}");
    }
    return false;
  }
}

  Future<void> handleEmailConfirmation() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');

  if (token != null) {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      final isVerified = await checkEmailConfirmation(token);
      if (isVerified) {
        await prefs.remove('authToken');
        timer.cancel(); 
        setState(() {
          isVerifying = false;
        });
      }
    });
  }
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Waiting Confirm Email'),
      content: isVerifying
          ? CircularProgressIndicator()
          : Text('Your email has been confirmed!'),
      actions: [
        if (!isVerifying)
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/complete_profile');
            },
          ),
      ],
    );
  }
}
