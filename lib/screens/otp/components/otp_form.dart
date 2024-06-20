import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../otp_service.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  bool isVerify = false ;
  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin1Controller.dispose();
    pin2Controller.dispose();
    pin3Controller.dispose();
    pin4Controller.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }
  String _getOtp() {
    return pin1Controller.text + pin2Controller.text + pin3Controller.text + pin4Controller.text;
  }
  void _verifyOtp (BuildContext context) async {
    String otp = _getOtp();
      try {
        OtpResponse response = await verifyOtp(otp);
        if (response.success) {
          isVerify = true ;
          showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Notification'),
                  content: Text('Verify OPT success , *note* : this is OTP test while no server to send OTP'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error!)),
          );
        }
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error! An error occurred. Please try again later: $e')),
          );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: pin1Controller,
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: pin2Controller,
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: pin3Controller,
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: pin4Controller,
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                        _verifyOtp(context);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          ElevatedButton(
            onPressed: () {
              if (isVerify) {
                Navigator.pushNamed( context, '/');
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
