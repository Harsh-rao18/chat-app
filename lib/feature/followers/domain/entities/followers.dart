class Followers {
  final String id;
  final String followerId;
  final String followingId;
  final DateTime createdAt;
  final String name;  // ✅ Add name field
  final String image; // ✅ Add image field

  Followers({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
    required this.name,  // ✅ Add name field
    required this.image, // ✅ Add image field
  });

}
