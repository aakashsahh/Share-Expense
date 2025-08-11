import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? imagePath;
  final DateTime createdAt;

  const Member({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.imagePath,
    required this.createdAt,
  });

  Member copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? imagePath,
    DateTime? createdAt,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'image_path': imagePath,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      imagePath: json['image_path'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, name, phone, email, imagePath, createdAt];
}
