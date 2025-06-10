import 'dart:async';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/intro/view_model/rain_manager.dart';

class IntroRain extends StatefulWidget {
  final List<RainDrop> rainDrops;
  final Size? screenSize;

  const IntroRain({
    super.key,
    required this.rainDrops,
    required this.screenSize,
  });

  @override
  State<IntroRain> createState() => _IntroRainState();
}

class _IntroRainState extends State<IntroRain>
    with SingleTickerProviderStateMixin {
  late List<RainDrop> _rainDrops;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _rainDrops = List.from(widget.rainDrops);
    _startRainAnimation();
  }

  @override
  void didUpdateWidget(IntroRain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rainDrops != widget.rainDrops) {
      _rainDrops = List.from(widget.rainDrops);
    }
  }

  void _startRainAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        for (int i = 0; i < _rainDrops.length; i++) {
          final drop = _rainDrops[i];
          double newY = drop.y + drop.velocity;
          if (widget.screenSize != null && newY > widget.screenSize!.height) {
            // reinicia o pingo de chuva no topo
            newY = 0.0;
          }
          _rainDrops[i] = drop.copyWith(y: newY);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screenSize == null) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: RainPainter(drops: _rainDrops, screenSize: widget.screenSize!),
        willChange: true,
      ),
    );
  }
}
