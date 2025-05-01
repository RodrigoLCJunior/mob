import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';

import '../fixture/library/fixture_helper.dart';

void main() {
  test('should validate the MoedaPermanente entity', () async {
    // Arrange
    final Map<String, dynamic> map =
        FixtureHelper.fetchMoedaPermanenteRemoteMap();

    // Act
    final MoedaPermanente moeda = MoedaPermanente.fromJson(map);
    final MoedaPermanente moedaCopy = MoedaPermanente.fromJson(moeda.toJson());

    // Assert
    expect(moeda, isA<MoedaPermanente>());
    expect(moedaCopy, isA<MoedaPermanente>());
    expect(moedaCopy.id, "teste");
    expect(moedaCopy.quantidade, 0);
  });
}
