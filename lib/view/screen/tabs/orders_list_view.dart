import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/view/widget/build_order_list.dart';

import '../../../controllers/orders/orders_list_controller.dart';
import '../../../core/constants/class/handle_data_view.dart';
import '../../../core/constants/class/status_request.dart';

class OrdersListView extends GetView<OrdersListController> {
  const OrdersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = Theme.of(context);
    

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return controller.isSearching.value
              ? TextField(
                  controller: controller.searchController,
                  onChanged: controller.filteroreder,
                  decoration: InputDecoration(
                    hintText: '15'.tr,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.searchController.clear();
                        FocusScope.of(context).unfocus();
                        controller.loadMockOrders();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                )
              : Text('Orders'); // Default title when not searching
        }),
        actions: [
          IconButton(
            icon: Icon(
                controller.isSearching.value ? Icons.cancel : Icons.search),
            onPressed: () {
              controller.isSearching.value = !controller.isSearching.value;
              if (!controller.isSearching.value) {
                controller.searchController.clear();
                FocusScope.of(context).unfocus();
                controller.loadMockOrders(); // Reset to original data
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addOrder();
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildBoxInqualityInfo(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.inzalized,
                child: Obx(() => HandlingDataView(
                      statusRequest: controller.statusrequest.value,
                      widget: Column(
                        children: [
                          Expanded(
                            child: controller.isSearching.value &&
                                    controller.filteredOrders.isEmpty
                                ? Center(
                                    child: Text(
                                      '16'.tr,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : buildOrderList(),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxInqualityInfo() {
    return Obx(() {
      if (controller.statusrequest.value == STATUSREQUEST.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.statusrequest.value == STATUSREQUEST.servicefailer) {
        return const Center(child: Text("حدث خطأ في تحميل البيانات"));
      }

      final b1Quantity = controller.getAvailableQuantityByBoxName("B1");
      final b2Quantity = controller.getAvailableQuantityByBoxName("B2");
      final b3Quantity = controller.getAvailableQuantityByBoxName("B3");

      return Table(
        border: TableBorder.all(color: Colors.black, width: 1),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[200]),
            children: [
              _buildTableCell("B1", isHeader: true),
              _buildTableCell("B2", isHeader: true),
              _buildTableCell("B3", isHeader: true),
            ],
          ),
          TableRow(
            children: [
              _buildTableCell(b1Quantity.toString()),
              _buildTableCell(b2Quantity.toString()),
              _buildTableCell(b3Quantity.toString()),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 20 : 16,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
