class Wave {
  final int waveAtual;
  final int waveFinal;
  final List<int> inimigosDerrotados;
  final int ultimoInimigoId;

  Wave({
    required this.waveAtual,
    required this.waveFinal,
    required this.inimigosDerrotados,
    required this.ultimoInimigoId,
  });

  factory Wave.fromJson(Map<String, dynamic> json) {
  print('Wave.fromJson - json: $json');

  return Wave(
    waveAtual: json['waveAtual'] as int? ?? 1,
    waveFinal: json['waveFinal'] as int? ?? 1,
    inimigosDerrotados: (json['inimigosDerrotados'] as List?)
            ?.where((e) => e != null)
            .map((e) => e as int)
            .toList() ??
        [],
    ultimoInimigoId: json['ultimoInimigoId'] as int? ?? 0,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'waveAtual': waveAtual,
      'waveFinal': waveFinal,
      'inimigosDerrotados': inimigosDerrotados,
      'ultimoInimigoId': ultimoInimigoId,
    };
  }

  Wave copyWith({
    int? waveAtual,
    int? waveFinal,
    List<int>? inimigosDerrotados,
    int? ultimoInimigoId,
  }) {
    return Wave(
      waveAtual: waveAtual ?? this.waveAtual,
      waveFinal: waveFinal ?? this.waveFinal,
      inimigosDerrotados: inimigosDerrotados ?? this.inimigosDerrotados,
      ultimoInimigoId: ultimoInimigoId ?? this.ultimoInimigoId,
    );
  }
}
