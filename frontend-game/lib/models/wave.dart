class Wave {
  final int waveAtual;
  final int waveFinal;

  Wave({
    required this.waveAtual,
    required this.waveFinal,
  });

  factory Wave.fromJson(Map<String, dynamic> json) {
    return Wave(
      waveAtual: json['waveAtual'],
      waveFinal: json['waveFinal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waveAtual': waveAtual,
      'waveFinal': waveFinal,
    };
  }
}
