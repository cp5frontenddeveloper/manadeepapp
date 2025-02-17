class CustomerModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String location;
  final DateTime joiningDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.location,
    required this.joiningDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    try {
      return CustomerModel(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        phoneNumber: json["phone_number"] ?? '',
        location: json["location"] ?? '',
        joiningDate: DateTime.parse(
            json["joining_date"] ?? DateTime.now().toIso8601String()),
        createdAt: DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String()),
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
      );
    } catch (e) {
      print("Error parsing customer data: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
        "location": location,
        "joining_date": joiningDate.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
      };
}
