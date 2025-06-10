import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/models/avatar/avatar_entity.dart';
import '../fixture/library/fixture_helper.dart';

void main() {
  test('should validate the Avatar entity', () async {
    // Arrange
    final Map<String, dynamic> map = FixtureHelper.fetchAvatarRemoteMap();

    // Act
    final Avatar avatar = Avatar.fromJson(map);
    final Avatar avatarCopy = Avatar.fromJson(avatar.toJson()).copyWith();

    // Assert
    /*expect(avatar, isA<Avatar>());
    expect(avatarCopy, isA<Avatar>());
    expect(avatarCopy.id, "100");
    expect(avatarCopy.hp, 5);
    expect(avatarCopy.danoBase, 1);*/

    // Assert
    expect(avatar, isA<Avatar>());
    expect(avatarCopy, isA<Avatar>());
    expect(avatarCopy.id, "100");
    expect(avatarCopy.hp, 5);
    expect(avatarCopy.danoBase, 1);
    expect(avatarCopy.progressao, isNotNull);
    expect(avatarCopy.progressao!.id, "teste");
    expect(avatarCopy.progressao!.totalMoedasTemporarias, 0);
    expect(avatarCopy.progressao!.totalCliques, 0);
    expect(avatarCopy.progressao!.totalInimigosDerrotados, 0);
    expect(avatarCopy.progressao!.avatarId, "teste");
  });
}
