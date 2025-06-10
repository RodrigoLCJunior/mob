import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/habilidades/talent_entity.dart';
import 'talent_title.dart';

class TalentsList extends StatelessWidget {
  final List<Talent> talents;
  final bool isLoading;
  final void Function(int) onUpgrade;

  const TalentsList({
    super.key,
    required this.talents,
    required this.isLoading,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          talents.asMap().entries.map((entry) {
            final index = entry.key;
            final talent = entry.value;
            return TalentTile(
              icon: talent.icon,
              title: talent.title,
              level: talent.level,
              cost: talent.cost,
              onPressed:
                  isLoading
                      ? null
                      : () {
                        onUpgrade(index);
                      },
              glowAnimation: null,
            );
          }).toList(),
    );
  }
}
