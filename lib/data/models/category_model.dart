import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final int iconCodePoint;
  final String iconFontFamily;
  final String type; // "expense" or "fund"
  final int color;

  const Category({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.type,
    required this.color,
  });

  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily);

  Category copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
    String? iconFontFamily,
    String? type,
    int? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'type': type,
      'color': color,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      iconCodePoint: json['iconCodePoint'],
      iconFontFamily: json['iconFontFamily'],
      type: json['type'],
      color: json['color'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    iconCodePoint,
    iconFontFamily,
    type,
    color,
  ];
}
