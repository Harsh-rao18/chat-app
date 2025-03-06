import 'package:application_one/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.metadata,
    required super.createdAt,
  });

  /// Convert from Firestore/Supabase map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['created_at'] ?? '',
      metadata: Metadata.fromMap(map['metadata'] ?? {}),
    );
  }

  /// Convert UserModel to Firestore/Supabase map
  Map<String, dynamic> toMap() {  // ✅ Renamed from toMap()
    return {
      'id': id,
      'email': email,
      'created_at': createdAt,
      'metadata': metadata.toMap(), // ✅ Ensure Metadata has a toMap() method
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? createdAt,
    Metadata? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
