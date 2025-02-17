// response_model.dart

class ApiResponse {
  final bool status;
  final String message;
  final List<CommunicationLog> notifications;
  final int unreadCount;

  ApiResponse({
    required this.status,
    required this.message,
    required this.notifications,
    required this.unreadCount,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        notifications: (json['notifications'] as List?)
                ?.map((item) => CommunicationLog.fromJson(item))
                .toList() ??
            [],
        unreadCount: json['unread_count'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'notifications': notifications.map((e) => e.toJson()).toList(),
        'unread_count': unreadCount,
      };
}
DateTime _parseDateTime(String? dateStr) {
  if (dateStr == null) return DateTime.now();
  
  try {
    return DateTime.parse(dateStr);
  } catch (e) {
    // Try alternative format
    try {
      final parts = dateStr.split(' ');
      if (parts.length >= 1) {
        return DateTime.parse(parts[0]);
      }
    } catch (e) {
      print('Error parsing date: $dateStr');
    }
    return DateTime.now();
  }
}

// communication_log.dart
class CommunicationLog {
  final int id;
  final int representativeId;
  final String title;
  final DateTime date;
  final bool isNew;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Representative representative;

  CommunicationLog({
    required this.id,
    required this.representativeId,
    required this.title,
    required this.date,
    required this.isNew,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.representative,
  });

  factory CommunicationLog.fromJson(Map<String, dynamic> json) {
    return CommunicationLog(
      id: json['id'] ?? 0,
      representativeId: json['representative_id'] ?? 0,
      title: json['title'] ?? '',
      date: _parseDateTime(json['date']),
      isNew: json['isNew'] == 1,
      note: json['note'],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      representative: Representative.fromJson(json['representative'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'representative_id': representativeId,
        'title': title,
        'date': date.toIso8601String().split('T')[0],
        'isNew': isNew,
        'note': note,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'representative': representative.toJson(),
      };

  CommunicationLog copyWith({
    int? id,
    int? representativeId,
    String? title,
    DateTime? date,
    bool? isNew,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    Representative? representative,
  }) =>
      CommunicationLog(
        id: id ?? this.id,
        representativeId: representativeId ?? this.representativeId,
        title: title ?? this.title,
        date: date ?? this.date,
        isNew: isNew ?? this.isNew,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        representative: representative ?? this.representative,
      );
}

// representative.dart
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
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null ? 
        DateTime.tryParse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone_number': phoneNumber,
        'email': email,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  Representative copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) =>
      Representative(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
      );
}
