// lib/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
//import 'package:oksana_shik/utils/constants.dart';
import 'package:oksana_shik/utils/theme.dart';

// Определите класс StatefulWidget SplashScreen
class SplashScreen extends StatefulWidget {
  // Конструктор без const, так как это StatefulWidget
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Определите внутренний класс состояния _SplashScreenState
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Объявляем контроллер анимации для логотипа
  late AnimationController _logoController;
  // Объявляем анимацию масштабирования логотипа
  late Animation<double> _logoScaleAnimation;
  // Объявляем анимацию сдвига текста
  late Animation<Offset> _textSlideAnimation;

  /* ====================================== Вызываем родительский метод initState */
  @override
  void initState() {
    super.initState();
    // Создаем контроллер анимации с продолжительностью 1 секунду
    _logoController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this, // Необходимо для работы анимаций
    );
    // Создаем анимацию масштабирования логотипа
    // Начальное значение 0.8, конечное 1.0
    // Используется кривая elasticOut для эффекта "прыжка"
    _logoScaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    // Создаем анимацию сдвига текста
    // Начальное положение снизу (0, 0.3), конечное - центр (0, 0)
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.decelerate),
    );
    // Запускаем анимацию вперед
    _logoController.forward();
    // После 2 секунд переходим на экран входа
    Future.delayed(const Duration(seconds: 2), () {
      // Переход на экран логина с заменой текущего экрана
      Navigator.pushReplacementNamed((context), '/login');
    });
  }

  /*====================== Метод, который выполняется при уничтожении состояния */
  @override
  void dispose() {
    // Освобождаем ресурсы контроллера анимации
    _logoController.dispose();
    // Вызываем родительский метод dispose
    super.dispose();
  }

  // Метод для построения интерфейса
  @override
  Widget build(BuildContext context) {
    // Возвращаем Scaffold (основная структура экрана)
    return Scaffold(
      // Устанавливаем цвет фона из темы приложения
      backgroundColor: AppTheme.primaryColor,
      // Центрируем содержимое по горизонтали и вертикали
      body: Center(
        child: Column(
          // Выравнивание элементов по центру вертикально
          mainAxisAlignment: MainAxisAlignment.center,
          // Список дочерних элементов
          children: [
            // Анимированный логотип с масштабированием
            ScaleTransition(
              // Применяем анимацию масштабирования
              scale: _logoScaleAnimation,
              // Дочерний элемент - контейнер с логотипом
              child: Container(
                // Размер контейнера
                width: 120,
                height: 120,
                // Стилизация контейнера
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // Круглая форма
                  color: Colors.white, // Белый цвет фона
                  // Здесь можно добавить изображение вместо текста
                  // image: DecorationImage(image: AssetImage('assets/images/logo.png'))
                ),
                // Центрированный текст внутри контейнера
                child: const Center(
                  child: Text(
                    "O", // Текст логотипа
                    style: TextStyle(
                      fontSize: 60, // Размер шрифта
                      fontWeight: FontWeight.bold, // Жирный шрифт
                      color: AppTheme.accentColor, // Цвет текста из темы
                    ),
                  ),
                ),
              ),
            ),
            // Отступ между логотипом и текстом
            const SizedBox(height: 30),
            // Анимированный текст с движением
            SlideTransition(
              // Применяем анимацию сдвига
              position: _textSlideAnimation,
              // Дочерний элемент - текст названия
              child: Text(
                "Оксана Шик", // Текст названия
                style: AppTheme.heading1.copyWith(
                  fontSize: 32, // Изменяем размер шрифта
                  color: Colors.white, // Белый цвет текста
                ),
              ),
            ),
            // Отступ между названием и подтекстом
            const SizedBox(height: 10),
            // Анимированный подтекст с изменением прозрачности
            FadeTransition(
              // Применяем анимацию изменения прозрачности
              opacity: _logoController,
              // Дочерний элемент - подтекст
              child: Text(
                "Красота начинается здесь", // Текст подзаголовка
                style: AppTheme.bodyText.copyWith(
                  color: Colors.white, // Полупрозрачный белый цвет
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
