// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Вход")),
      body: const Center(child: Text("Экран входа")),
    );
  }
}
