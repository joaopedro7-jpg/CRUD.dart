class Planet {
  final int? id;
  final String name;
  final double distance;
  final double size;
  final String? nickname;

  Planet({
    this.id,
    required this.name,
    required this.distance,
    required this.size,
    this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'distance': distance,
      'size': size,
      'nickname': nickname,
    };
  }

  static Planet fromMap(Map<String, dynamic> map) {
    return Planet(
      id: map['id'],
      name: map['name'],
      distance: map['distance'],
      size: map['size'],
      nickname: map['nickname'],
    );
  }
}
