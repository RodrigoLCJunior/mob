// A classe AssetsHelper é uma classe utilitária projetada para organizar e gerenciar os caminhos
// de acesso aos recursos estáticos (assets) utilizados na aplicação, especificamente para elementos
// visuais da tela de login. Ela utiliza a extensão `joinPath` (importada de '../core/library/extensions.dart')
// para concatenar caminhos de diretórios e arquivos de forma consistente, garantindo que os caminhos
// sejam construídos corretamente independentemente da plataforma. A classe define constantes para
// o diretório 'assets/login' e especifica os caminhos completos para cada arquivo de recurso relacionado
// à tela de login, facilitando o acesso a esses assets em outras partes do código e promovendo manutenção
// centralizada dos caminhos.Os assets relacionados a mapas foram removidos, pois não serão utilizados conforme indicado.

import '../core/library/extensions.dart';

// Define o nome do diretório raiz para os assets
const String _kAssetsDirectoryName = 'assets';

// Classe final que não pode ser estendida, usada para gerenciar caminhos de assets
final class AssetsHelper {
  // Define o caminho para o diretório 'assets/login' usando joinPath
  static final String _assetsLogin = [_kAssetsDirectoryName, 'login'].joinPath;
  static final String assetsLoginFacebook =
      [_assetsLogin, 'facebook.png'].joinPath;
  static final String assetsLoginGoogle = [_assetsLogin, 'google.png'].joinPath;
  static final String assetsLoginIcon =
      [_assetsLogin, 'login_icon.png'].joinPath;
  static final String assetsLoginBottom =
      [_assetsLogin, 'login_bottom.png'].joinPath;
  static final String assetsLoginTop = [_assetsLogin, 'login_top.png'].joinPath;
}
