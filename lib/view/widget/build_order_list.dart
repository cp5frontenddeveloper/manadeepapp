import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/controllers/orders/orders_list_controller.dart';

final OrdersListController controller = Get.put(OrdersListController());

Widget buildOrderList() {
  return Obx(() => ListView.builder(
        itemCount: controller.filteredOrders.length,
        itemBuilder: (context, index) {
          final order = controller.filteredOrders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  order.nameCline[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                '17'.tr + ': ${order.nameCline}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // subtitle: Text(
              //   '18'.tr +
              //       ': ${order.orderItems.first.boxType?.name ?? ""} | ' +
              //       '19'.tr +
              //       ': ${order.orderItems.first.quantity}',
              // ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.navigateToOrderDetails(order),
            ),
          );
        },
      ));
}
