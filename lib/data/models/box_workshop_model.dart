class Workshop {
  final int id;
  final String name;
  final String workshopNumber;
  final String email;
  final String managerName;
  final String location;
  final String rating;
  final String iban;
  final String records;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Workshop({
    required this.id,
    required this.name,
    required this.workshopNumber,
    required this.email,
    required this.managerName,
    required this.location,
    required this.rating,
    required this.iban,
    required this.records,
    this.createdAt,
    this.updatedAt,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      workshopNumber: json['workshop_number'] ?? '',
      email: json['email'] ?? '',
      managerName: json['manager_name'] ?? '',
      location: json['location'] ?? '',
      rating: json['rating']?.toString() ?? '0',
      iban: json['iban'] ?? '',
      records: json['records'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'workshop_number': workshopNumber,
        'email': email,
        'manager_name': managerName,
        'location': location,
        'rating': rating,
        'iban': iban,
        'records': records,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
