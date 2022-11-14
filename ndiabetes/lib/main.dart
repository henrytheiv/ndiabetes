import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndiabetes/rating.dart';
import 'package:ndiabetes/scan_food.dart';
import 'package:ndiabetes/sign_up.dart';
import 'package:splash_view/splash_view.dart';


import 'home.dart';
import 'introduction.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
        title: 'Introduction screen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashView(
          backgroundColor: Colors.white,
          loadingIndicator: CircularProgressIndicator(color: Color(0xffbbdefb),),
          logo: Image.asset("assets/ndiabetes.png"),
          done: Done(IntroductionPage())
        ),
        // home: IntroductionPage(),
        routes: {
          '/homepage': (context) => const Homepage(),
          '/sign_up': (context) => const SignUpPage(),
          '/scan_food': (context) => const ScanFoodPage(),
          '/rating': (context) => const RatingPage(),
        });
  }
}

// class Logo extends StatelessWidget {
//   const Logo({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.asset("ndiabetes.png");
//   }
// }

