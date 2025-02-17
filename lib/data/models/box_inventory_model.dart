
import 'box_status_model.dart';
import 'box_type_model.dart';
import 'box_workshop_model.dart';

class BoxInventory {
  final int id;
  final String invoiceNumber;
  final int workshopId;
  final int boxTypeId;
  final int boxStatusId;
  final int quantity;
  final int receivedQuantity;
  final DateTime orderDate;
  final DateTime? actualDeliveryDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Workshop workshop;
  final BoxType boxType;
  final BoxStatus boxStatus;

  BoxInventory({
    required this.id,
    required this.invoiceNumber,
    required this.workshopId,
    required this.boxTypeId,
    required this.boxStatusId,
    required this.quantity,
    required this.receivedQuantity,
    required this.orderDate,
    this.actualDeliveryDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.workshop,
    required this.boxType,
    required this.boxStatus,
  });

  factory BoxInventory.fromJson(Map<String, dynamic> json) {
    try {
      return BoxInventory(
        id: json['id'] ?? 0,
        invoiceNumber: json['invoice_number'] ?? '',
        workshopId: json['workshop_id'] ?? 0,
        boxTypeId: json['box_type_id'] ?? 0,
        boxStatusId: json['box_status_id'] ?? 0,
        quantity: json['quantity'] ?? 0,
        receivedQuantity: json['received_quantity'] ?? 0,
        orderDate: json['order_date'] != null
            ? DateTime.parse(json['order_date'])
            : DateTime.now(),
        actualDeliveryDate: json['actual_delivery_date'] != null
            ? DateTime.parse(json['actual_delivery_date'])
            : null,
        notes: json['notes'],
        createdAt: DateTime.parse(
            json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updated_at'] ?? DateTime.now().toIso8601String()),
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
        workshop: Workshop.fromJson(json['workshop'] ?? {}),
        boxType: BoxType.fromJson(json['box_type'] ?? {}),
        boxStatus: BoxStatus.fromJson(json['box_status'] ?? {}),
      );
    } catch (e) {
      print('Error parsing BoxInventory: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_number": invoiceNumber,
        "workshop_id": workshopId,
        "box_type_id": boxTypeId,
        "box_status_id": boxStatusId,
        "quantity": quantity,
        "received_quantity": receivedQuantity,
        "order_date": orderDate.toIso8601String(),
        "actual_delivery_date": actualDeliveryDate?.toIso8601String(),
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt?.toIso8601String(),
        "workshop": workshop.toJson(),
        "box_type": boxType.toJson(),
        "box_status": boxStatus.toJson(),
      };

  static List<BoxInventory> fromJsonList(Map<String, dynamic> jsonResponse) {
    if (jsonResponse['data'] == null) return [];

    final List<dynamic> data = jsonResponse['data'] as List;
    return data.map((json) => BoxInventory.fromJson(json)).toList();
  }
}
