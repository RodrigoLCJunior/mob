import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/domain/entities/progressao/progressao_entity.dart';

import '../fixture/library/fixture_helper.dart';

void main() {
  test('should validate the Progressao entity', () async {
    // Arrange
    final Map<String, dynamic> map = FixtureHelper.fetchProgressaoRemoteMap();

    // Act
    final Progressao progressao = Progressao.fromJson(map);
    final Progressao progressaoCopy = Progressao.fromJson(progressao.toJson());

    // Assert
    expect(progressao, isA<Progressao>());
    expect(progressaoCopy, isA<Progressao>());
    expect(progressaoCopy.id, "teste");
    expect(progressaoCopy.totalMoedasTemporarias, 0);
    expect(progressaoCopy.totalCliques, 0);
    expect(progressaoCopy.totalInimigosDerrotados, 0);
    expect(progressaoCopy.avatarId, "");
  });
}
