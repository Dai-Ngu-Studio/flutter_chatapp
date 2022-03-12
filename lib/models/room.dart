class Room {
  final String? roomID;
  final String? name;
  final String? description;
  final String? roomImage;
  final DateTime? createdAt;
  final List<String>? users;

  Room({
    this.roomID,
    this.name,
    this.description,
    this.roomImage,
    this.createdAt,
    this.users,
  });
}
