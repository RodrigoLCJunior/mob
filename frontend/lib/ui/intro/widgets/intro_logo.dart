import 'package:flutter/material.dart';

class IntroLogo extends StatelessWidget {
  final double width;
  final Alignment alignment;

  const IntroLogo({
    super.key,
    this.width = 320,
    this.alignment = const Alignment(0, -0.7), // padrão mais pra cima
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        'assets/images/re_walker.png',
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }
}
