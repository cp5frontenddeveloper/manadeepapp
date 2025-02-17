import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/view/screen/tabs/email_like_chat.dart';
import '../../controllers/dataLoader_controller.dart';
import '../../data/models/box_type_model.dart';
import '../../data/models/communicationlog.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/order_model.dart';
import '../../routes/app_pages.dart';


class DynamicSearchPage extends GetView<DataLoaderController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('البحث الشامل'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن طلبات، عملاء، ملاحظات...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => controller.loadAllData(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: controller.searchAllData,
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.filteredDataList.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredDataList[index];
                    return _buildSearchResultCard(item);
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(dynamic item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildLeadingIcon(item),
        title: _buildTitle(item),
        subtitle: _buildSubtitle(item),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => _handleItemTap(item),
      ),
    );
  }

  Widget _buildLeadingIcon(dynamic item) {
    if (item is CommunicationLog) {
      return Icon(Icons.message, color: Colors.blue);
    } else if (item is Order) {
      return Icon(Icons.shopping_cart, color: Colors.green);
    } else if (item is CustomerModel) {
      return Icon(Icons.person, color: Colors.orange);
    } else if (item is BoxType) {
      return Icon(Icons.inventory, color: Colors.purple);
    } else if (item is Map<String, dynamic>) {
      return Icon(Icons.note, color: Colors.red);
    }
    return Icon(Icons.error);
  }

  Widget _buildTitle(dynamic item) {
    if (item is CommunicationLog) {
      return Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis);
    } else if (item is Order) {
      return Text('طلب ${item.id} - ${item.nameCline}');
    } else if (item is CustomerModel) {
      return Text(item.name);
    } else if (item is BoxType) {
      return Text('${item.name} - ${item.description}');
    } else if (item is Map<String, dynamic>) {
      return Text(item['note'], maxLines: 2, overflow: TextOverflow.ellipsis);
    }
    return Text(item.toString());
  }

  Text? _buildSubtitle(dynamic item) {
    if (item is Order) {
      return Text('رقم الهاتف: ${item.phoneNumberCline}');
    } else if (item is CustomerModel) {
      return Text(item.phoneNumber);
    } else if (item is CommunicationLog) {
      return Text(item.date.toString().split('.')[0]);
    }
    return null;
  }

  void _handleItemTap(dynamic item) {
    if (item is CommunicationLog) {
      Get.to(() => EmailLikeChatPage(logs: item,));
    } else if (item is Order) {
      Get.toNamed(AppRoutes.orderDetail, arguments: {'order': item});
    } else if (item is CustomerModel) {
      // Navigate to customer details
      Get.snackbar('عميل', 'تم اختيار العميل ${item.name}');
    } else if (item is BoxType) {
      // Navigate to box type details
      Get.snackbar('صندوق', 'تم اختيار الصندوق ${item.name}');
    } else if (item is Map<String, dynamic>) {
      // Show note details
      Get.snackbar('ملاحظة', item['note']);
    }
  }
}
