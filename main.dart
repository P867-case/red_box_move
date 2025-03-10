import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Основное приложение, которое запускает главный виджет.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Создание MaterialApp без отображения баннера debug.
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

/// Виджет, управляющий анимацией квадрата.
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

/// Состояние виджета SquareAnimation, содержащее логику анимации.
class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  static const _squareSize = 50.0; /// Размер квадрата.
  late AnimationController _controller; /// Контроллер анимации.
  late Animation<double> _animation; /// Анимация для перемещения квадрата.
  double _position = 0.0; /// Текущая позиция квадрата.
  bool _isAnimating = false; /// Флаг, указывающий, выполняется ли анимация.

  @override
  void initState() {
    super.initState();

    /// Инициализация контроллера анимации.
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    /// Инициализация анимации.
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller)
      ..addListener(() {
        /// Обновление состояния при изменении значения анимации.
        setState(() {
          _position = _animation.value;
        });
      })
      ..addStatusListener((status) {
        /// Обработка завершения анимации.
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false; /// Сброс флага анимации.
          });
        }
      });
  }

  /// Запуск анимации для перемещения квадрата в заданную позицию.
  void _moveSquare(double targetPosition) {
    if (_isAnimating) return; /// Если анимация уже выполняется, выход.

    setState(() {
      _isAnimating = true; /// Установка флага анимации.
    });

    /// Создание новой анимации для перемещения квадрата.
    _animation = Tween<double>(begin: _position, end: targetPosition).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    /// Запуск анимации.
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    /// Освобождение ресурсов контроллера анимации.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Ширина экрана с учетом padding.
    final screenWidth = MediaQuery.of(context).size.width - 64;
    /// Максимальное смещение квадрата от центра.
    final maxPosition = (screenWidth - _squareSize) / 2;

    return Column(
      children: [
        /// Виджет для отображения квадрата с анимацией перемещения.
        Transform.translate(
          offset: Offset(_position, 0),
          child: Container(
            width: _squareSize,
            height: _squareSize,
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        /// Кнопки для управления анимацией.
        Row(
          children: [
            ElevatedButton(
              onPressed: _position <= -maxPosition || _isAnimating
                  ? null
                  : () => _moveSquare(-maxPosition),
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _position >= maxPosition || _isAnimating
                  ? null
                  : () => _moveSquare(maxPosition),
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}
