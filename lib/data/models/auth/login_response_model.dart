class   LoginResponse {
  final bool status;
  final String message;
  final String token;
  final Representative? representative;

  LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    this.representative,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      representative: json['representative'] != null
          ? Representative.fromJson(json['representative'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'representative': representative?.toJson(),
    };
  }
}

class Representative {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Representative({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Representative.fromJson(Map<String, dynamic> json) {
    return Representative(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}