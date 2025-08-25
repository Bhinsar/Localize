import 'dart:async';

import 'package:app/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimensions(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/main_logo.png',
          width: d.width * 0.6,
          height: d.height * 0.6,
        ),
      ),
    );
  }
}