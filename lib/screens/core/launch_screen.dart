import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app/firebase/fb_auth_controller.dart';
import 'package:firebase_app/firebase/fb_notifications.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with FbNotifications{

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    initializedForegroundNotificationForAndroid();
    manageNotificationAction();
    // throw Exception('Test - Crashlytics Exception Reported');
    Future.delayed(const Duration(seconds: 3),(){
      String route = FbAuthController().loggedIn ? '/home_screen':'/login_screen';
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
        'Firebase App',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.black,
        ),
      ),
      ),
    );
  }
}