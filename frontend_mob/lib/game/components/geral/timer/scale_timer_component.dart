/// Este arquivo define a classe `ScaleTimerComponent`, responsável por animar
/// a escala de um componente no Flame com transição suave.
///
/// Principais responsabilidades:
/// - Anima a escala de um componente de um valor inicial para um valor final.
/// - Ajusta a sombra do componente (se presente) durante a animação.
import 'package:flame/components.dart';

class ScaleTimerComponent extends TimerComponent {
  final double startScale;
  final double endScale;
  final PositionComponent component;
  final RectangleComponent? shadowComponent;
  double t = 0;

  ScaleTimerComponent({
    required this.startScale,
    required this.endScale,
    required this.component,
    this.shadowComponent,
  }) : super(
         period: 0.1, // Duração da animação (0.1 segundos)
         repeat: false,
         removeOnFinish: true,
       );

  @override
  void update(double dt) {
    super.update(dt);
    t += dt / 0.1; // Normalizar para a duração
    if (t > 1) t = 1;
    final newScale = startScale + (endScale - startScale) * t;
    component.scale = Vector2.all(newScale);
    if (shadowComponent != null) {
      shadowComponent!.size =
          component.size * newScale * 1.1; // Ligeiramente maior
      shadowComponent!.opacity =
          (startScale < endScale) ? t * 0.3 : (1 - t) * 0.3;
    }
    if (t >= 1) {
      component.scale = Vector2.all(endScale);
      if (shadowComponent != null) {
        shadowComponent!.opacity = (startScale < endScale) ? 0.3 : 0;
      }
    }
  }
}
