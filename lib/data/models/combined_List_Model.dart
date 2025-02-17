// import 'package:get/get.dart';
// import 'package:manadeebapp/data/models/box_type_model.dart';
// import 'package:manadeebapp/data/models/communicationlog.dart';
// import 'package:manadeebapp/data/models/customer_model.dart';
// import 'package:manadeebapp/data/models/order_model.dart';

// class CombinedListModel {
//   final RxList<CommunicationLog> logs;
//   final RxList<Order> orders;
//   final RxList<CustomerModel> customerModels;
//   final RxList<BoxType> boxTypes;

//   // Combined list to store all types
//   RxList<dynamic> combinedList = <dynamic>[].obs;

//   CombinedListModel({
//     required this.logs,
//     required this.orders,
//     required this.customerModels,
//     required this.boxTypes,
//   }) {
//     // Combine all lists into single observable list
//     combinedList.addAll([
//       ...logs,
//       ...orders,
//       ...customerModels,
//       ...boxTypes
//     ]);
//   }

//   // Method to add items from specific list types
//   void addItem(dynamic item) {
//     if (item is CommunicationLog) {
//       logs.add(item);
//       combinedList.add(item);
//     } else if (item is Order) {
//       orders.add(item);
//       combinedList.add(item);
//     } else if (item is CustomerModel) {
//       customerModels.add(item);
//       combinedList.add(item);
//     } else if (item is BoxType) {
//       boxTypes.add(item);
//       combinedList.add(item);
//     }
//   }

//   // Search method across combined list
//   RxList<dynamic> searchItems(String query) {
//     return RxList<dynamic>(
//       combinedList.where((item) => 
//         item.toString().toLowerCase().contains(query.toLowerCase())
//       ).toList()
//     );
//   }
// }