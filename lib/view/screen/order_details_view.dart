import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/orders/order_details_controller.dart';
import '../../data/models/order_model.dart';
import '../widget/sharedwidget/custom_info_groub.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('20'.tr, style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Obx(() {
        final order = controller.orderDetails.value;
        if (order == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 64, color: theme.colorScheme.secondary),
                const SizedBox(height: 16),
                Text('21'.tr, style: theme.textTheme.titleMedium),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderHeader(order, theme),
                    const SizedBox(height: 20),
                    _buildOrderDetails(order, theme),
                    const SizedBox(height: 20),
                    _buildDeliveryInfo(order, theme),
                    const SizedBox(height: 20),
                    _buildPaymentInfo(order, theme),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOrderHeader(Order order, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.shopping_bag,
                    color: theme.colorScheme.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '22'.tr + ' #${order.id}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.formatDate(order.receiptDate.toString()),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              _buildOrderStatus(order, theme),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  order.nameCline.substring(0, 1),
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.nameCline,
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      order.phoneNumberCline,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(Order order, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: order.isCompleted
            ? Colors.green.withOpacity(0.1)
            : theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        order.isCompleted ? '23'.tr : '24'.tr,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: order.isCompleted ? Colors.green : theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOrderDetails(Order order, ThemeData theme) {
    return CustomInfoGroup(
      title: '24'.tr,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '25'.tr,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '26'.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '27'.tr,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        ...order.orderItems
            .map((item) => Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.boxType?.name ?? '',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.boxType?.description ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${item.quantity}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.price} ${'28'.tr}',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${(double.parse(item.price.toString()) * item.quantity)} ${'28'.tr}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (order.orderItems.last != item) const Divider(height: 1),
                  ],
                ))
            .toList(),
      ],
    );
  }

  Widget _buildDeliveryInfo(Order order, ThemeData theme) {
    return InfoGroup(
      title: '29'.tr,
      icon: Icons.local_shipping,
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            _buildDeliveryInfoRow(
              theme,
              icon: Icons.calendar_today,
              title: '30'.tr,
              value: controller.formatDate(order.receiptDate.toString()),
            ),
            const SizedBox(height: 12),
            _buildDeliveryInfoRow(
              theme,
              icon: Icons.local_shipping,
              title: '31'.tr,
              value: order.receiptMethod,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoRow(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  )),
              const SizedBox(height: 4),
              Text(value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo(Order order, ThemeData theme) {
    // Calculate total price and quantity from all order items
    double totalPrice = 0;
    int totalQuantity = 0;

    for (var item in order.orderItems) {
      totalPrice += double.parse(item.price.toString()) * item.quantity;
      totalQuantity += item.quantity;
    }

    return CustomInfoGroup(
      title: '32'.tr,
      children: [
        _buildPaymentRow(
          theme,
          title: '33'.tr,
          value: '${totalPrice / totalQuantity} ' + '28'.tr,
        ),
        const SizedBox(height: 8),
        _buildPaymentRow(
          theme,
          title: '34'.tr,
          value: '$totalQuantity',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(),
        ),
        _buildPaymentRow(
          theme,
          title: '35'.tr,
          value: '$totalPrice ' + '28'.tr,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    ThemeData theme, {
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? theme.textTheme.titleMedium
              : theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )
              : theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}
