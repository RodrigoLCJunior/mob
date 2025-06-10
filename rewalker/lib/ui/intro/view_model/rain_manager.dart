// Este arquivo isola a lógica de gerenciamento das gotas de chuva para a tela de introdução (IntroScreen), facilitando a manutenção.
// Fornece métodos para inicializar e atualizar as gotas de chuva, usados pelo IntroViewModel.

// Nota: A lógica de chuva foi movida do IntroViewModel para cá conforme solicitado, para manter o IntroViewModel focado na lógica da tela.
// Não há dependências externas além do Dart puro, e a classe RainDrop é definida aqui para encapsular os dados das gotas.

// Classe auxiliar para gotas de chuva
import 'dart:math';
import 'package:flutter/material.dart';

class RainDrop {
  final double x;
  final double y;
  final double length;
  final double velocity;
  final double thickness;
  final Color color;

  RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.velocity,
    required this.thickness,
    this.color = Colors.white,
  });

  RainDrop copyWith({
    double? x,
    double? y,
    double? length,
    double? velocity,
    double? thickness,
    Color? color,
  }) {
    return RainDrop(
      x: x ?? this.x,
      y: y ?? this.y,
      length: length ?? this.length,
      velocity: velocity ?? this.velocity,
      thickness: thickness ?? this.thickness,
      color: color ?? this.color,
    );
  }
}

class RainManager {
  final int dropCount;
  final Size screenSize;
  final Random _random = Random();

  RainManager({required this.dropCount, required this.screenSize});

  List<RainDrop> generateRainDrops() {
    return List.generate(dropCount, (_) => _randomRainDrop());
  }

  RainDrop _randomRainDrop() {
    final x = _random.nextDouble() * screenSize.width;
    final y = _random.nextDouble() * screenSize.height;
    final length = 10.0 + _random.nextDouble() * 15.0;
    final velocity = 2.0 + _random.nextDouble() * 4.0;
    final thickness = 1.0 + _random.nextDouble() * 1.5;
    return RainDrop(
      x: x,
      y: y,
      length: length,
      velocity: velocity,
      thickness: thickness,
      color: Colors.white.withOpacity(0.7 + _random.nextDouble() * 0.3),
    );
  }
}

class RainPainter extends CustomPainter {
  final List<RainDrop> drops;
  final Size screenSize;

  RainPainter({required this.drops, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    for (final drop in drops) {
      paint.color = drop.color;
      paint.strokeWidth = drop.thickness;
      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(drop.x, drop.y + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RainPainter oldDelegate) {
    return true;
  }
}
