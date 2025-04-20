import 'package:flutter/material.dart';

class TalentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int level;
  final int cost;
  final VoidCallback onPressed;
  final Animation<double>? glowAnimation;

  const TalentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.level,
    required this.cost,
    required this.onPressed,
    this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    Widget tile = Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.cyanAccent, size: 30),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      fontFamily: "Cinzel",
                    ),
                  ),
                  Text(
                    "Nível: $level",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _UpgradeButton(cost: cost, onPressed: onPressed),
        ],
      ),
    );

    if (glowAnimation != null) {
      return AnimatedBuilder(
        animation: glowAnimation!,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(
                  glowAnimation!.value * 0.5,
                ),
                width: 2,
              ),
            ),
            child: child,
          );
        },
        child: tile,
      );
    }

    return tile;
  }
}

class _UpgradeButton extends StatefulWidget {
  final int cost;
  final VoidCallback onPressed;

  const _UpgradeButton({required this.cost, required this.onPressed});

  @override
  _UpgradeButtonState createState() => _UpgradeButtonState();
}

class _UpgradeButtonState extends State<_UpgradeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Melhorar ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Cinzel",
                    ),
                  ),
                  Text(
                    "${widget.cost}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Cinzel",
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    'assets/icons/permCoin.png',
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
