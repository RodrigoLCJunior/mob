// Este arquivo define uma interface abstrata e exporta o pacote flutter/material.dart para uso em outros módulos.
// A interface IFactoryViewModel<T> estabelece um contrato para fábricas que criam e gerenciam instâncias de ViewModels
// (de tipo genérico T) no contexto de uma aplicação Flutter.
// Ela declara dois métodos:
// - create: Responsável por criar uma instância do ViewModel, recebendo o BuildContext para acesso ao contexto da
//   interface do usuário (ex.: para obter providers ou navegação).
// - dispose: Responsável por liberar recursos ou limpar o ViewModel quando ele não for mais necessário, também utilizando
//   o BuildContext.
// Essa interface é útil para padronizar a criação e o descarte de ViewModels em arquiteturas como MVVM,
// promovendo desacoplamento e reutilização de lógica.

import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

abstract interface class IFactoryViewModel<T> {
  T create(BuildContext context);
  void dispose(BuildContext context, T viewModel);
}
