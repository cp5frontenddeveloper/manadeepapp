// note_response.dart
class NoteResponse {
  final bool success;
  final List<Note> data;

  NoteResponse({
    required this.success,
    required this.data,
  });

  factory NoteResponse.fromJson(Map<String, dynamic> json) {
    return NoteResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List).map((item) => Note.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((note) => note.toJson()).toList(),
    };
  }
}

// note.dart
class Note {
  final int id;
  final int adminCommunicationLogId;
  final String noteType;
  final String noteValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.adminCommunicationLogId,
    required this.noteType,
    required this.noteValue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? 0,
      adminCommunicationLogId: json['admin_communication_log_id'] ?? 0,
      noteType: json['note_type'] ?? '',
      noteValue: json['note_value'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_communication_log_id': adminCommunicationLogId,
      'note_type': noteType,
      'note_value': noteValue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}