import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/routes/app_pages.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/class/status_request.dart';
import '../widget/custom_drawer.dart';
import 'tabs/admin_communication_view.dart';
import 'tabs/notes_view.dart';
import 'tabs/orders_list_view.dart';

class Homepagemanadeep extends StatefulWidget {
  const Homepagemanadeep({super.key});

  @override
  State<Homepagemanadeep> createState() => _HomepagemanadeepState();
}

class _HomepagemanadeepState extends State<Homepagemanadeep> {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Obx(() => CustomDrawer(
            username: controller.username,
            email: controller.email,
          )),
      appBar: AppBar(
        title: const Text("Homepage"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildBoxInqualityInfo(),
            const SizedBox(height: 35),
            // الطريقة الأولى: تغليف GridView بـ Expanded
            Expanded(child: _buildButtonGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxInqualityInfo() {
    return Obx(() {
      if (controller.statusRequest.value == STATUSREQUEST.loading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.statusRequest.value == STATUSREQUEST.servicefailer) {
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

  Widget _buildButtonGrid() {
    final List<Map<String, dynamic>> buttons = [
      {"icon": Icons.message, "label": "التواصل الإداري"},
      {"icon": Icons.assignment, "label": "الطلبات"},
      {"icon": Icons.note, "label": "الملاحظات"},
      {"icon": Icons.search, "label": "البحث"},
    ];

    return Center(
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: InkWell(
              onTap: () {
                _onButtonPressed(context, buttons[index]["label"]);
              },
              splashColor: Colors.blue.withOpacity(0.2),
              highlightColor: Colors.blue.withOpacity(0.1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(buttons[index]["icon"], size: 40, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(
                      buttons[index]["label"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onButtonPressed(BuildContext context, String buttonLabel) {
    if (buttonLabel == "التواصل الإداري") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminCommunicationView()),
      );
    } else if (buttonLabel == "الطلبات") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdersListView()),
      );
    } else if (buttonLabel == "الملاحظات") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotesView()),
      );
    } else if (buttonLabel == "البحث") {
      Get.toNamed(AppRoutes.search);
    }
    // يمكن إضافة المزيد من الشروط للأزرار الأخرى هنا.
  }
}
