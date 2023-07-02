import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app/bloc/bloc/images_bloc.dart';
import 'package:firebase_app/bloc/states/image_state.dart';
import 'package:firebase_app/firebase/fb_notifications.dart';
import 'package:firebase_app/screens/app/home_screen.dart';
import 'package:firebase_app/screens/app/images/images_screen.dart';
import 'package:firebase_app/screens/app/images/upload_image_screen.dart';
import 'package:firebase_app/screens/auth/login_screen.dart';
import 'package:firebase_app/screens/auth/register_screen.dart';
import 'package:firebase_app/screens/core/launch_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FbNotifications.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ImagesBloc>(
            create: (context) => ImagesBloc(LoadingState())),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/launch_screen',
        routes: {
          '/launch_screen': (context) => const LaunchScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/register_screen': (context) => const RegisterScreen(),
          '/home_screen': (context) => const HomeScreen(),
          '/upload_image_screen': (context) => const UploadImageScreen(),
          '/images_screen': (context) => const ImagesScreen(),
        },
      ),
    );
  }
}
