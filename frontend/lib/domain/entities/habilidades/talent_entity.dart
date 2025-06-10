import 'package:flutter/material.dart';

class Talent {
  final String title;
  final IconData icon;
  final int level;
  final int cost;

  Talent({
    required this.title,
    required this.icon,
    required this.level,
    required this.cost,
  });

  Talent copyWith({String? title, IconData? icon, int? level, int? cost}) {
    return Talent(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      level: level ?? this.level,
      cost: cost ?? this.cost,
    );
  }
}
