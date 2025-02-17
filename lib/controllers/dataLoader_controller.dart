import 'package:get/get.dart';
import 'package:manadeebapp/controllers/admin_communication_controller.dart';
import 'package:manadeebapp/data/models/communicationlog.dart';
import '../core/constants/db.dart';
import '../data/models/box_type_model.dart';
import '../data/models/customer_model.dart';
import '../data/models/order_model.dart';
import 'orders/orders_list_controller.dart';

class DataLoaderController extends GetxController {
  // Existing lists
  final RxList<CommunicationLog> logs = <CommunicationLog>[].obs;
  final RxList<Order> orders = <Order>[].obs;
  final RxList<CustomerModel> customerModels = <CustomerModel>[].obs;
  final RxList<BoxType> boxTypes = <BoxType>[].obs;
  final RxList<Map<String, dynamic>> notes = <Map<String, dynamic>>[].obs;

  // Combined list to store all data
  final RxList<dynamic> allDataList = <dynamic>[].obs;

  // Add filtered list observable
  final RxList<dynamic> filteredDataList = <dynamic>[].obs;
  final DatabaseHelper dbnote = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadAllData(); // تحميل البيانات عند بدء التشغيل
  }

  // Method to load data from all sources
  Future<void> loadAllData() async {
    try {
      allDataList.clear();
      await Future.wait([
        _loadCommunicationLogs(),
        _loadOrders(),
        _loadCustomerModels(),
        _loadNotes(),
      ]);

      allDataList.addAll([
        ...logs,
        ...orders,
        ...customerModels,
        ...boxTypes,
        ...notes,
      ]);

      filteredDataList.assignAll(allDataList);
      print('Total data loaded: ${allDataList.length} items');
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _loadCommunicationLogs() async {
    try {
      final adminController = Get.find<AdminCommunicationController>();
      await adminController.fetchLogs();
      logs.assignAll(adminController.logs);
    } catch (e) {
      print('Error loading communication logs: $e');
    }
  }

  Future<void> _loadOrders() async {
    try {
      final ordersController = Get.find<OrdersListController>();
      await ordersController.loadMockOrders();
      orders.assignAll(ordersController.orders);
    } catch (e) {
      print('Error loading orders: $e');
    }
  }

  Future<void> _loadCustomerModels() async {}

  Future<void> _loadNotes() async {
    try {
      final loadedNotes = await dbnote.getNotes();
      notes.assignAll(loadedNotes);
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  // Update search method to use filteredDataList
  void searchAllData(String query) {
    if (query.isEmpty) {
      filteredDataList.assignAll(allDataList);
      return;
    }

    final searchLower = query.toLowerCase();
    filteredDataList.assignAll(allDataList.where((item) {
      if (item is CommunicationLog) {
        return item.title.toLowerCase().contains(searchLower);
      } else if (item is Order) {
        return item.nameCline.toLowerCase().contains(searchLower) ||
            item.phoneNumberCline.toLowerCase().contains(searchLower) ||
            item.id.toString().contains(searchLower);
      } else if (item is CustomerModel) {
        return item.name.toLowerCase().contains(searchLower) ||
            item.phoneNumber.toLowerCase().contains(searchLower);
      } else if (item is BoxType) {
        return item.name.toLowerCase().contains(searchLower) ||
            item.description!.toLowerCase().contains(searchLower);
      } else if (item is Map<String, dynamic>) {
        return item['note'].toString().toLowerCase().contains(searchLower);
      }
      return false;
    }).toList());

    print('Search results: ${filteredDataList.length} items');
  }
}
