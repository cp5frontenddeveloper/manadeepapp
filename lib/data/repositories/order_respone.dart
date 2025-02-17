// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:manadeebapp/data/models/box_type_model.dart';
import 'package:manadeebapp/data/models/customer_model.dart';
import 'package:manadeebapp/data/providers/crud.dart';
import 'package:manadeebapp/data/providers/link/api_endpoints.dart';

import '../models/box_inventory_model.dart';
import '../models/order_model.dart';

class AddOrderRespone {
  final CRUD crud;
  final _logger = Logger('AddOrderRespone');

  AddOrderRespone(this.crud);

  Future<List<CustomerModel>> getCustomers() async {
    try {
      _logger.info('Fetching customers from: $getCustomersLink');
      var response = await crud.getdata(getCustomersLink);

      return response.fold((error) {
        _logger.warning("Error fetching customers: $error");
        return [];
      }, (data) {
        if (data is List) {
          _logger.info("Received ${data.length} customers from API");
          return List<CustomerModel>.from(
              data.map((json) => CustomerModel.fromJson(json)));
        } else {
          _logger.warning("Unexpected data format: $data");
          return [];
        }
      });
    } catch (e) {
      _logger.severe("Exception in getCustomers: $e");
      return [];
    }
  }

  Future<List<CustomerModel>> addCustomer(
      String name, String phoneNumber, String location) async {
    try {
      var response = await crud.postdata(getCustomersLink, {
        "name": name,
        "phone_number": phoneNumber,
        "location": location,
        "joining_date": "2024-01-15"
      });
      return response.fold((error) {
        _logger.warning('Error adding customer: $error');
        return [];
      }, (data) {
        if (data is Map<String, dynamic>) {
          _logger.info("Received customer data from API");
          return [CustomerModel.fromJson(data)];
        } else {
          _logger.warning("Unexpected data format: $data");
          return [];
        }
      });
    } catch (e) {
      _logger.severe("Exception in addCustomer: $e");
      return [];
    }
  }

  Future<List<BoxType>> getBoxTypes() async {
    try {
      _logger.info("Fetching box types from: $getBoxTypesLink");
      var response = await crud.getdata(getBoxTypesLink);
      return response.fold((error) {
        _logger.warning("Error fetching box types: $error");
        return [];
      }, (data) {
        if (data is List) {
          _logger.info('Received ${data.length} box types from API');
          return data.map<BoxType>((json) => BoxType.fromJson(json)).toList();
        }
        return [];
      });
    } catch (e) {
      _logger.severe("Exception in getBoxTypes: $e");
      return [];
    }
  }

  Future<bool> addOrder(
    int representativeId,
    String receiptDate,
    String receiptMethod,
    String customerName,
    String phoneNumber,
    String location,
    String notes,
    List<Map<String, dynamic>> items,
  ) async {
    try {
      _logger.info("Adding order to API");
      var response = await crud.postdata(addOrderResponseLink, {
        "representative_id": representativeId,
        "receipt_date": receiptDate,
        "receipt_method": receiptMethod,
        "namecline": customerName,
        "phone_numbercline": phoneNumber,
        "locationcline": location,
        "is_completed": false,
        "notes": notes,
        "items": items,
      });

      return response.fold((error) {
        _logger.warning("Error adding order: $error");
        return false;
      }, (data) {
        _logger.info("Order added successfully");
        return true;
      });
    } catch (e) {
      _logger.severe("Exception in addOrder: $e");
      return false;
    }
  }

  Future<List<Order>> getorderapi(String userid) async {
    try {
      _logger.info("Fetching orders for user: $userid");
      var response = await crud.getdata(getOrderLink(userid));
      return response.fold((error) {
        _logger.warning("Error fetching orders: $error");
        return [];
      }, (data) {
        if (data is List) {
          _logger.info("Received ${data.length} orders from API");
          return List<Order>.from(data.map((json) => Order.fromJson(json)));
        }
        return [];
      });
    } catch (e) {
      _logger.severe("Exception in getorderapi: $e");
      return [];
    }
  }

  Future<List<BoxInventory>> getboxInventory() async {
    try {
      var response = await crud.getdata(getBoxInventoryLink);

      return response.fold((error) {
        print("Error fetching boxinventory: $error");
        return [];
      }, (data) {
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          List<dynamic> boxList = data['data'];
          print("Received ${boxList.length} boxes from API");

          var result =
              boxList.map((json) => BoxInventory.fromJson(json)).toList();
          print("Successfully parsed ${result.length} BoxInventory objects");

          return result;
        }
        print("Invalid response format");
        return [];
      });
    } catch (e) {
      print("Exception in getboxInventory: $e");
      return [];
    }
  }
}
