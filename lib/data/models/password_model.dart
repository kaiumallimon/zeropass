class PasswordModel {
  final String id;
  final String userId;
  final String categoryId;
  final String name;
  final String url;
  final String username;
  final String password;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  PasswordModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.url,
    required this.username,
    required this.password,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      name: json['name'],
      url: json['url'],
      username: json['username'],
      password: json['password'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'name': name,
      'url': url,
      'username': username,
      'password': password,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
