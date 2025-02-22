class User {
  final String id;
  final String email;
  final Metadata metadata;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.metadata,
    required this.createdAt,
  });

}

class Metadata {
  final String name;
  final String image;
  final String description;

  const Metadata({
    required this.name,
    required this.image,
    required this.description,
  });

  factory Metadata.fromMap(Map<String, dynamic> map) {
    return Metadata(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {  // ✅ Renamed from toMap()
    return {
      'name': name,
      'image': image,
      'description': description,
    };
  }
}

