/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Widgets da chuva
 ** Obs...:
 */

import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/intro/rain_drop.dart';

class RainPainter extends CustomPainter {
  final List<RainDrop> drops;
  final Size screenSize;

  RainPainter({required this.drops, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xB3E0F7FA) // Cor gelo com 70% de opacidade
          ..strokeWidth =
              0.5 // Pingos finos
          ..style = PaintingStyle.stroke;

    for (var drop in drops) {
      double xPos = drop.x * screenSize.width;
      double yPos = drop.y * screenSize.height;
      canvas.drawLine(
        Offset(xPos, yPos),
        Offset(xPos, yPos + drop.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
