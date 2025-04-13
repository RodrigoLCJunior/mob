import 'package:flutter/material.dart';

class TalentTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int level;
  final int cost;
  final VoidCallback onPressed;
  final Animation<double> glowAnimation;

  const TalentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.level,
    required this.cost,
    required this.onPressed,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: glowAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color: Colors.cyanAccent.withOpacity(
                      glowAnimation.value * 0.5,
                    ),
                    shadows: [
                      Shadow(
                        blurRadius: 10.0 * glowAnimation.value,
                        color: Colors.cyanAccent,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        blurRadius: 5.0 * glowAnimation.value,
                        color: Colors.white,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.cyanAccent.withOpacity(glowAnimation.value),
                          Colors.white.withOpacity(0.5),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Icon(icon, size: 30, color: Colors.white),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: glowAnimation,
                  builder: (context, child) {
                    return Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: "Cinzel",
                        shadows: [
                          Shadow(
                            blurRadius: 10.0 * glowAnimation.value,
                            color: Colors.cyanAccent,
                            offset: const Offset(0, 0),
                          ),
                          Shadow(
                            blurRadius: 5.0 * glowAnimation.value,
                            color: Colors.white,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  "Nível: $level",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              AnimatedBuilder(
                animation: glowAnimation,
                builder: (context, child) {
                  return Row(
                    children: [
                      Image.asset(
                        'assets/icons/permCoin.png',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$cost",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: "Cinzel",
                          shadows: [
                            Shadow(
                              blurRadius: 10.0 * glowAnimation.value,
                              color: Colors.cyanAccent,
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 5.0 * glowAnimation.value,
                              color: Colors.white,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onPressed,
                child: AnimatedBuilder(
                  animation: glowAnimation,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 10 * glowAnimation.value,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        "UPGRADE",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Cinzel",
                          shadows: [
                            Shadow(
                              blurRadius: 10.0 * glowAnimation.value,
                              color: Colors.cyanAccent,
                              offset: const Offset(0, 0),
                            ),
                            Shadow(
                              blurRadius: 5.0 * glowAnimation.value,
                              color: Colors.white,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
