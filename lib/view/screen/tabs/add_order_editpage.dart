import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/orders/OrderController.dart';
import '../../../core/constants/class/status_request.dart';
import '../../widget/boxdatatype.dart';
// تأكد من استيراد الـ controller

class OrderForm extends StatelessWidget {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  // Add controller as a late final field
  late final OrderController orderController;

  OrderForm({Key? key}) : super(key: key) {
    // Initialize the controller in the constructor
    orderController = Get.put(OrderController());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("إضافة طلب"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: orderController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 2),
                    _buildBoxInqualityInfo(),
                    _buildCustomerInfoSection(orderController),
                    BoxDetailsSection(
                      onBoxesUpdated: (boxes) =>
                          orderController.updateItems(boxes),
                    ),
                    _buildDeliveryInfoSection(orderController, context),
                    ElevatedButton(
                      onPressed: () {
                        if (orderController.formKey.currentState!.validate() &&
                            orderController.hasItems) {
                          orderController.submitForm();
                        } else {
                          Get.snackbar(
                            'تنبيه',
                            'يرجى إدخال جميع البيانات المطلوبة',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Text('إرسال الطلب'),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoxInqualityInfo() {
    return Obx(() {
      if (orderController.statusRequest.value == STATUSREQUEST.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (orderController.statusRequest.value == STATUSREQUEST.servicefailer) {
        return const Center(child: Text("حدث خطأ في تحميل البيانات"));
      }

      final b1Quantity = orderController.getAvailableQuantityByBoxName("B1");
      final b2Quantity = orderController.getAvailableQuantityByBoxName("B2");
      final b3Quantity = orderController.getAvailableQuantityByBoxName("B3");

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
      padding: EdgeInsets.all(8),
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

  Widget _buildCustomerInfoSection(OrderController orderController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                Text('معلومات العميل',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'الاسم'),
                    onSaved: (value) =>
                        orderController.formData['customerName'] = value!,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'الهاتف'),
                    onSaved: (value) =>
                        orderController.formData['phone'] = value!,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'العنوان'),
                    onSaved: (value) =>
                        orderController.formData['address'] = value!,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'التسليم'),
                    isExpanded: true,
                    items: ['كاش', 'شبكة', 'عربون'].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        orderController.formData['boxType'] = value!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoSection(
      OrderController orderController, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.blue),
                Text('معلومات التسليم',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'طريقة التسليم'),
                    items: ['استلام من المحل', 'توصيل للمنزل', 'توصيل وتركيب,']
                        .map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        orderController.formData['delivery'] = value!,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'التاريخ'),
                    keyboardType: TextInputType.datetime,
                    onSaved: (value) =>
                        orderController.formData['date'] = value!,
                    readOnly: true,
                    controller: TextEditingController(
                        text: orderController.formData['date'].toString()),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        orderController.formData['date'] = formattedDate;
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(labelText: 'ملاحظات'),
              maxLines: 1,
              onSaved: (value) => orderController.formData['notes'] = value!,
            ),
          ],
        ),
      ),
    );
  }
}
