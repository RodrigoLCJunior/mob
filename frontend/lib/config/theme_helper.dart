// A classe ThemeHelper é uma classe utilitária que centraliza as configurações de tema visual da aplicação Flutter,
// definindo cores primárias e estilos para componentes da interface do usuário.
// Ela fornece constantes para cores (primária, primária clara e transparente) e um método getter estático que retorna
// um objeto ThemeData, usado para configurar o tema global da aplicação.
// O tema inclui:
// - Definição da cor primária e do fundo do scaffold (branco).
// - Estilo para botões elevados (ElevatedButton), com cor de fundo primária, texto branco, formato arredondado
//   (StadiumBorder) e tamanho fixo.
// - Estilo para campos de entrada (InputDecorationTheme), com fundo claro, ícones na cor primária, padding interno
//   e borda arredondada sem contorno.
// Essa centralização facilita a manutenção e a aplicação consistente do design visual em toda a interface da aplicação.

import 'package:flutter/material.dart';

final class ThemeHelper {
  static const Color kPrimaryColor = Color(0xFF6F35A5);
  static const Color kPrimaryLightColor = Color(0xFFF1E6FF);
  static const Color kTransparenteColor = Colors.transparent;

  static ThemeData get theme {
    return ThemeData(
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor,
          shape: const StadiumBorder(),
          maximumSize: const Size(double.infinity, 56),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: kPrimaryLightColor,
        iconColor: kPrimaryColor,
        prefixIconColor: kPrimaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
