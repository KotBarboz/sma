import 'package:flutter/material.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media APP',
      theme: ThemeData.dark(),
      home: SignUpScreen(),
    );
  }
}
