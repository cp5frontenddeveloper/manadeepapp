import 'package:flutter/material.dart';

class BoxDetailsSection extends StatefulWidget {
  final Function(List<Map<String, dynamic>>)? onBoxesUpdated;

  const BoxDetailsSection({super.key, this.onBoxesUpdated});

  @override
  _BoxDetailsSectionState createState() => _BoxDetailsSectionState();
}

class _BoxDetailsSectionState extends State<BoxDetailsSection> {
  // قائمة لتخزين أنواع الصناديق المختارة
  List<Map<String, dynamic>> selectedBoxTypes = [];

  // قائمة بأنواع الصناديق المتاحة
  final List<String> availableBoxTypes = ['B1', 'B2', 'B3'];

  void _updateParent() {
    widget.onBoxesUpdated?.call(selectedBoxTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory, color: Colors.blue),
                Text(' Box Details',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),

            // عرض حقول إدخال لكل نوع صندوق تم اختياره
            ...selectedBoxTypes.map((box) {
              return _buildBoxInputFields(box);
            }).toList(),

            // زر لإضافة نوع صندوق جديد
            TextButton(
              onPressed: () {
                setState(() {
                  // إضافة نوع صندوق جديد إلى القائمة
                  selectedBoxTypes.add({
                    'type': availableBoxTypes[0], // القيمة الافتراضية
                    'quantity': '',
                    'price': '',
                  });
                  _updateParent();
                });
              },
              child: Text('Add Box Type'),
            ),
          ],
        ),
      ),
    );
  }

  // بناء حقول إدخال لكل نوع صندوق
  Widget _buildBoxInputFields(Map<String, dynamic> box) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Type'),
                isExpanded: true,
                value: box['type'],
                items: availableBoxTypes.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    box['type'] = value!;
                    _updateParent();
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Qty'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  box['quantity'] = value;
                  _updateParent();
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  box['price'] = value;
                  _updateParent();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
