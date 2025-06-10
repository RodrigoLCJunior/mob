// Este arquivo define uma função utilitária chamada showSnackBar, que exibe uma SnackBar (notificação flutuante) na
// interface do Flutter para mostrar mensagens ao usuário.
// A função utiliza dependências do pacote midnight_never_end, como o IAppService (injetado via GetIt), para acessar o
// BuildContext necessário para exibir a SnackBar.

// A função showSnackBar aceita:
// - msg: A mensagem (String) a ser exibida na SnackBar (obrigatório).
// - colorBackground: Cor de fundo opcional da SnackBar.
// - duration: Duração da exibição da SnackBar (padrão: 5 segundos).
// - onListen: Callback opcional executado quando a SnackBar é fechada.

// Implementação:
// - Obtém o BuildContext do IAppService registrado no GetIt.
// - Cria uma SnackBar com a mensagem, duração, cor de fundo, margem fixa (34 pixels) e comportamento flutuante
// (SnackBarBehavior.floating).
// - Usa o ScaffoldMessenger para exibir a SnackBar e registra o callback onListen para ser chamado quando a SnackBar for fechada.
// - Inclui um bloco try-catch para evitar falhas silenciosas, embora sem tratamento específico de erros.

// Nota: Conforme sua solicitação anterior, tudo relacionado a mapas e bancos de dados não relacionais foi excluído.
// Este arquivo não contém referências a mapas ou NoSQL, sendo uma função de interface puramente visual, compatível com as restrições. A dependência de IAppService (via GetIt) está alinhada com o uso revisado em outros trechos (ex.: AppService para navegação). A função pode ser usada para exibir mensagens em resposta a eventos (ex.: sucesso/erro em chamadas à API gerenciadas por HttpService).

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/configs/injection_container.dart';
import 'package:midnight_never_end/core/service/app_service.dart';

void showSnackBar(
  String msg, {
  Color? colorBackground,
  Duration duration = const Duration(seconds: 5),
  void Function()? onListen,
}) {
  final BuildContext context = getIt<IAppService>().context!;
  final SnackBar snackBar = SnackBar(
    duration: duration,
    backgroundColor: colorBackground,
    margin: const EdgeInsets.all(34),
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
  try {
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
      onListen?.call();
    });
  } catch (_) {}
}
