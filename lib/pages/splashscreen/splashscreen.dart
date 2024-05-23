import 'package:flutter/material.dart';
import 'package:gadc/pages/pages.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "/splashscreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 4)).then((value) => Navigator.of(context)
        .pushNamedAndRemoveUntil(
            Homepage.routeName, (Route<dynamic> route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/splash_screen.json',
            backgroundLoading: true, frameRate: const FrameRate(144)),
      ),
    );
  }
}
