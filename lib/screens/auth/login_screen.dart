// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> signIn() async {
      try {
        // Проверяем, что поля не пустые
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Заполните все поля')),
          );
          return;
        }

        // // Пытаемся войти через Firebase Auth
        // UserCredential userCredential =
        //     await FirebaseAuth.instance.signInWithEmailAndPassword(
        //   email: emailController.text,
        //   password: passwordController.text,
        // );

        // Успешный вход
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'invalid-email') {
          errorMessage = 'Неверный формат email';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'Пользователь не найден';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Неверный пароль';
        } else {
          errorMessage = 'Ошибка входа: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Произошла ошибка: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход /login'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        leading: Container(), //кнопка возврата скрыта
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Отступ сверху
              // Заголовок формы регистрации
              const Text(
                'Вход в приложение',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // onPressed: handleLogin,
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.backgroundColor,
                  ),
                  child: const Text('Войти'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Переход на регистрацию
                  Navigator.pushNamed(context, '/register');
                },
                style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor),
                child: const Text('Зарегистрироваться'),
              ),
              // Новая кнопка для перехода на экран Test
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Переход на экран Test
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(builder: (context) => const TestScreen()),
                    //);
                    Navigator.pushNamed(context, '/test');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Зеленый цвет для тестовой кнопки
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Перейти к тесту базы данных'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
