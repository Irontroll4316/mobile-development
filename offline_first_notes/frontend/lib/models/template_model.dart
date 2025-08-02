// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:offline_first_notes/core/constants/utils.dart';

class TemplateModel {
  final String name;
  final String uid;
  final Color color;
  final DateTime createdAt;
  final DateTime lastUsed;
  final int isSynced;

  TemplateModel({
    required this.name,
    required this.uid,
    required this.color,
    required this.createdAt,
    required this.lastUsed,
    required this.isSynced,
  });

  TemplateModel copyWith({
    String? name,
    String? uid,
    Color? color,
    DateTime? createdAt,
    DateTime? lastUsed,
    int? isSynced,
  }) {
    return TemplateModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'color': rgbToHex(color),
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      color: hexToRgb(map['color']),
      createdAt: DateTime.parse(map['createdAt']),
      lastUsed: DateTime.parse(map['lastUsed']),
      isSynced: map['isSynced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TemplateModel.fromJson(String source) =>
      TemplateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TemplateModel(name: $name, uid: $uid, color: $color, createdAt: $createdAt, lastUsed: $lastUsed, isSynced: $isSynced)';
  }

  @override
  bool operator ==(covariant TemplateModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.uid == uid &&
        other.color == color &&
        other.createdAt == createdAt &&
        other.lastUsed == lastUsed &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uid.hashCode ^
        color.hashCode ^
        createdAt.hashCode ^
        lastUsed.hashCode ^
        isSynced.hashCode;
  }
}
