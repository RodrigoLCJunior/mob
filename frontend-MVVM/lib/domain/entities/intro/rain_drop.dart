/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Entidade da chuva
 ** Obs...:
 */

class RainDrop {
  final double x;
  final double y;
  final double speed;
  final double length;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
  });

  RainDrop copyWith({double? x, double? y, double? speed, double? length}) {
    return RainDrop(
      x: x ?? this.x,
      y: y ?? this.y,
      speed: speed ?? this.speed,
      length: length ?? this.length,
    );
  }
}
