// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    void handleRegister() {
      // Проверяем, что все поля заполнены
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заполните все поля')),
        );
        return;
      }

      // Проверяем совпадение паролей
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пароли не совпадают')),
        );
        return;
      }

      // Проверяем длину пароля
      if (passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Пароль должен быть не менее 6 символов')),
        );
        return;
      }

      // Успешная регистрация (фейковая)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Регистрация успешна!')),
      );

      // Возвращаемся на экран входа
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация /register'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Регистрация в приложении',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Полное имя',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Подтвердите пароль',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: handleRegister,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.backgroundColor),
                //),
                //   // Обработка регистрации
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Регистрация успешна!')),
                //   );
                // },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: AppTheme.primaryColor,
                //   foregroundColor: AppTheme.backgroundColor,
                // ),
                child: const Text('Зарегистрироваться'),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Переход на экран входа
                Navigator.pop(context);
              },
              child: const Text('Уже есть аккаунт? Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
