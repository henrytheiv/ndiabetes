import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndiabetes/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

import 'introduction.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool _goToIntro = true;

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (!_seen) {
      await prefs.setBool('seen', true);
    }
    setState(() {
      _goToIntro = !_seen;
    });
  }

  @override
  void initState() {
    super.initState();
    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return SplashView(
        backgroundColor: Colors.blue,
        loadingIndicator: CircularProgressIndicator(color: Color(0xffbbdefb),),
        logo: Image.asset("assets/ndiabetes.png"),
        done: _goToIntro ? Done(IntroductionPage()) : Done(Homepage()),
      showStatusBar: true,
    );
  }



}
