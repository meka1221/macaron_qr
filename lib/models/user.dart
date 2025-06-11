class User {
  final String id;
  final String email;
  final String name;
  final int points;
  final String? avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.points = 0,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      points: (json['points'] ?? 0) is int ? json['points'] : int.tryParse(json['points'].toString()) ?? 0,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'points': points,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    int? points,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      points: points ?? this.points,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
