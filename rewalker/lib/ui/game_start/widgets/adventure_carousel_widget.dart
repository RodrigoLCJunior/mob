import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/game_start/game_start_entity.dart';

class AdventureCarousel extends StatelessWidget {
  final Function(int) onAdventureTap;
  final Animation<double> glowAnimation;
  final List<Adventure> adventures;
  final bool isLoading;
  final Future<void> Function(BuildContext) playScrollSound;

  const AdventureCarousel({
    Key? key,
    required this.onAdventureTap,
    required this.glowAnimation,
    required this.adventures,
    required this.isLoading,
    required this.playScrollSound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (adventures.isEmpty) {
      return const Center(
        child: Text(
          "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "Cinzel",
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
      ), // Ajuste este valor para abaixar mais ou menos
      child: CarouselSlider.builder(
        itemCount: adventures.length,
        itemBuilder: (context, index, realIndex) {
          final adventure = adventures[index];
          final pageOffset = (realIndex - index).abs().toDouble();
          final scale = (1.0 - (pageOffset * 0.1)).clamp(0.9, 1.0);

          return Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: () {
                if (adventure.isLocked) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Esta aventura está bloqueada",
                        style: TextStyle(fontFamily: "Cinzel"),
                      ),
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  onAdventureTap(index);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          adventure.imagePath,
                          fit: BoxFit.cover,
                          color:
                              adventure.isLocked
                                  ? Colors.grey.withOpacity(0.5)
                                  : null,
                          colorBlendMode:
                              adventure.isLocked ? BlendMode.saturation : null,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      if (adventure.isLocked)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      if (adventure.isLocked)
                        const Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 48,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: false,
          viewportFraction: 0.95,
          aspectRatio: 16 / 16,
          initialPage: 0,
          enableInfiniteScroll: true,
          onPageChanged: (index, reason) {
            if (reason == CarouselPageChangedReason.manual) {
              playScrollSound(context);
            }
          },
        ),
      ),
    );
  }
}
