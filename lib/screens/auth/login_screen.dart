import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app/firebase/fb_auth_controller.dart';
import 'package:firebase_app/firebase/fb_notifications.dart';
import 'package:firebase_app/models/fb_response.dart';
import 'package:firebase_app/utils/context_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FbNotifications{
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    requestNotificationPermissions();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'LOGIN',
          style: GoogleFonts.actor(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back...',
              style: GoogleFonts.actor(
                  fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1),
            ),
            Text(
              'Enter email & password',
              style: GoogleFonts.actor(
                fontWeight: FontWeight.w300,
                color: Colors.black45,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailTextController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordTextController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => await _performLogin(),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('LOGIN'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register_screen');
                    },
                    child: Text('Create Now!'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    // throw Exception('Test - Crashlytics Exception Reported');
    initializedForegroundNotificationForAndroid();
    manageNotificationAction();
    if (_checkData()) {
      await _login();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    context.showSnackBar( message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _login() async {
    FbResponse fbResponse = await FbAuthController().signIn(_emailTextController.text, _passwordTextController.text);
    if(fbResponse.success){
      Navigator.pushReplacementNamed(context, '/home_screen');
    }
    context.showSnackBar(message: fbResponse.message,error: !fbResponse.success);
    }
  }
