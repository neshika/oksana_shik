// lib/screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:oksana_shik/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oksana_shik/services/firestore_service.dart'; // Импортируем сервис Firestore

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    Future<void> signUp() async {
      try {
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

        // 1.Регистрируем нового пользователя в Firebase Auth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // 2. Получаем UID пользователя из Firebase Auth
        String uid = userCredential.user!.uid;

        // 3. Создаем запись пользователя в Firestore
        // Вызываем метод из сервиса, который создаст документ в коллекции 'users'
        await FirestoreService.createUser(
          uid: uid, // UID пользователя из Firebase Auth
          email: emailController.text, // Email из формы регистрации
          fullName: nameController.text, // Полное имя из формы регистрации
          phoneNumber:
              '', // Пустая строка, так как телефон не обязателен для регистрации
        );

        // 4. Показываем уведомление об успешной регистрации
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Регистрация успешна!')),
        );

        // 5. Возвращаемся на экран входа
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email уже используется';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Неверный формат email';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Пароль слишком слабый';
        } else {
          errorMessage = 'Ошибка регистрации: ${e.message}';
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
        title: const Text('Регистрация'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          icon: Icon(Icons.arrow_back),
        ),
      ),

      // Основное содержимое экрана с прокруткой
      body: SingleChildScrollView(
        // Отступы вокруг содержимого
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // Выравнивание по центру вертикально
            mainAxisAlignment: MainAxisAlignment.center,
            // Выравнивание по центру горизонтально
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Отступ сверху
              // Заголовок формы регистрации
              Center(
                child: Text(
                  'Регистрация',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController, //контроллер
                decoration: const InputDecoration(
                  labelText: 'Полное имя',
                  border: OutlineInputBorder(), //рамка
                  prefixIcon: Icon(Icons.person), //иконка
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController, //контроллер
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
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Подтвердите пароль',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 20),

              //кнопка регистрации
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: signUp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.backgroundColor),
                  child: const Text('Зарегистрироваться'),
                ),
              ),
              // const SizedBox(height: 2),
              TextButton(
                onPressed: () {
                  // Переход на экран политики
                  // Navigator.pop(context);
                },
                child: const Text('Политика конфиденциальности'),
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
      ),
    );
  }
}
