abstract interface class IEnvironmentHelper {
  String? get urlAuthentication;
  String? get urlUserInformation;
}

final class EnvironmentHelper implements IEnvironmentHelper {
  const EnvironmentHelper();

  String get _urlBase => 'https://mob-backend-3-combate-inteiro.onrender.com';

  @override
  String? get urlAuthentication => '$_urlBase/authentication';

  @override
  String get urlUserInformation => '$_urlBase/user_information';
}
