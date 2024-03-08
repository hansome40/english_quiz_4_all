import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: const Color(0xffeeee44),
          child: const Center(
            child: Text(
              'Quiz',
              style: TextStyle(fontSize: 40, color:Colors.black87, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}