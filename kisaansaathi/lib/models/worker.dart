class Worker {
  final String id;
  final String name;
  final String phoneNumber;
  final String language;
  final String? profileImageUrl;
  final DateTime createdAt;

  Worker({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.language,
    this.profileImageUrl,
    required this.createdAt,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      language: json['language'] ?? 'English',
      profileImageUrl: json['profileImage']?['url'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'language': language,
      'profileImage': profileImageUrl != null ? {'url': profileImageUrl} : null,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
