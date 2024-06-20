import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/otp_form.dart';
import 'otp_service.dart';

class OtpScreen extends StatefulWidget {
  static String routeName = "/otp";
  
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? phoneNumber = arguments?['phoneNumber'];
    final String? otpCode = arguments?['otpCode'];// tobe delete only test
    UniqueKey animationKey = UniqueKey();;
    
    void _resetTimer() {
      setState(() {
      });
    }
    void _reSendOtp (BuildContext context) async {
      try {
        OtpResponse response = await getOtp(phoneNumber.toString());
        if (response.success) {
          showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Notification'),
                  content: Text('Otp has been sent back successfully! OTP: ${response.response?.data["otpCode"]}'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                Text("NOTE: This is the otp code to test without registering for the OPT server: $otpCode"),
                Text("We sent your code to phoneNumber $phoneNumber"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("This code will expired in "),
                    TweenAnimationBuilder(
                      key: ValueKey(animationKey),
                      tween: Tween(begin: 60.0, end: 0.0),
                      duration: const Duration(seconds: 60),
                      builder: (_, dynamic value, child) => Text(
                        "00:${value.toInt()}",
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                      onEnd: () {
                        
                      },
                    ),
                  ],
                ),
                const OtpForm(),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                     _resetTimer();
                     _reSendOtp(context);
                  },
                  child: const Text(
                    "Resend OTP Code",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
