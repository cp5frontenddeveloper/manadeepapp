
import 'box_type_model.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int boxTypeId;
  final int quantity;
  final double price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BoxType? boxType;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.boxTypeId,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.boxType,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'],
    orderId: json['order_id'],
    boxTypeId: json['box_type_id'],
    quantity: json['quantity'],
    price: double.parse(json['price'].toString()),
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    boxType: json['box_type'] != null ? BoxType.fromJson(json['box_type']) : null,
  );
}

class Order {
  final int id;
  final int representativeId;
  final DateTime receiptDate;
  final String receiptMethod;
  final String nameCline;
  final String phoneNumberCline;
  final String locationCline;
  final bool isCompleted;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.representativeId,
    required this.receiptDate,
    required this.receiptMethod,
    required this.nameCline,
    required this.phoneNumberCline,
    required this.locationCline,
    required this.isCompleted,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    representativeId: json['representative_id'],
    receiptDate: DateTime.parse(json['receipt_date']),
    receiptMethod: json['receipt_method'],
    nameCline: json['namecline'],
    phoneNumberCline: json['phone_numbercline'],
    locationCline: json['locationcline'],
    isCompleted: json['is_completed'],
    notes: json['notes'],
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    orderItems: (json['order_items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
  );
}