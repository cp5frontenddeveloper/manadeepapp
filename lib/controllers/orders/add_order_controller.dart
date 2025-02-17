// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:logging/logging.dart';
// import 'package:manadeebapp/data/models/box_inventory_model.dart';
// import 'package:manadeebapp/data/models/customer_model.dart';
// import 'package:manadeebapp/data/repositories/order_respone.dart';
// import 'package:manadeebapp/services/server_shared.dart';

// import '../../core/constants/class/status_request.dart';
// import '../../data/models/box_type_model.dart';
// import '../../data/models/communicationlog.dart';
// import '../../data/models/deliverymethod.dart';
// import '../../view/widget/sharedwidget/dialogs/custom_alert_dialog.dart';
// import '../../view/widget/sharedwidget/forms/custom_textform.dart';

// class AddOrderController extends GetxController {
//   final formKey = GlobalKey<FormState>();

//   // قائمة العملاء
//   final RxList<CustomerModel> customers = <CustomerModel>[].obs;
//   final Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);

//   // بيانات العميل
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final locationController = TextEditingController();
//   final _logger = Logger('AddOrderRespone');
//   // بيانات الصندوق
//   final RxList<BoxType> boxTypes = <BoxType>[].obs;
//   final Rx<BoxType?> selectedBoxType = Rx<BoxType?>(null);
//   final RxList<BoxInventory> boxInventory = <BoxInventory>[].obs;
//   final quantityController = TextEditingController();

//   // طريقة الاستلام
//   final RxList<DeliveryMethod> deliveryMethods = <DeliveryMethod>[
//     DeliveryMethod(id: 1, name: '57'.tr, price: 0),
//     DeliveryMethod(id: 2, name: '58'.tr, price: 50),
//     DeliveryMethod(id: 3, name: '59'.tr, price: 100),
//   ].obs;
//   final Rx<DeliveryMethod?> selectedDeliveryMethod = Rx<DeliveryMethod?>(null);
//   final AddOrderRespone addOrderRespone = AddOrderRespone(Get.find());
//   // بيانات الطلب
//   final receiptDateController = TextEditingController();
//   final Rx<String> receiptMethod = ''.obs;
//   final priceController = TextEditingController();
//   final notesController = TextEditingController();
//   String customerid = '';
//   String boxid = '';
//   final _isLoading = false.obs;
//   bool get isLoading => _isLoading.value;
//   final MyServices _myServices = Get.find<MyServices>();
//   final RxInt currentStep = 0.obs;

//   // إضافة متغير لحالة التحميل
//   final Rx<STATUSREQUEST> statusRequest = STATUSREQUEST.none.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadBoxInvertoy();
//     loadBoxTypes();
//     loadCustomers();

//     // إضافة مستمع للتغييرات في حقل الكمية
//     quantityController.addListener(() {
//       if (selectedBoxType.value != null && quantityController.text.isNotEmpty) {
//         validateQuantityAndShowError();
//       }
//     });
//   }

//   // التحقق من الكمية وعرض رسالة الخطأ
//   void validateQuantityAndShowError() {
//     final quantity = int.tryParse(quantityController.text);
//     if (quantity != null && selectedBoxType.value != null) {
//       final availableQuantity =
//           getAvailableQuantityByBoxName(selectedBoxType.value!.name);
//       if (quantity > availableQuantity) {
//         Get.snackbar(
//           '94'.tr,
//           'الكمية المطلوبة ($quantity) أكبر من الكمية المتوفرة ($availableQuantity)',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         quantityController.clear();
//       }
//     }
//   }

//   // تحميل بيانات المخزون
//   Future<void> loadBoxInvertoy() async {
//     try {
//       statusRequest.value = STATUSREQUEST.loading;
//       _isLoading.value = true;
//       update();

//       final boxinventorylist = await addOrderRespone.getboxInventory();

//       if (boxinventorylist.isNotEmpty) {
//         boxInventory.assignAll(boxinventorylist);
//         statusRequest.value = STATUSREQUEST.success;
//         _logger.info("تم تحميل ${boxInventory.length} عنصر من المخزون");
//       } else {
//         statusRequest.value = STATUSREQUEST.failure;
//         _logger.warning("لم يتم تحميل أي عناصر من المخزون");
//       }
//     } catch (e) {
//       statusRequest.value = STATUSREQUEST.servicefailer;
//       _logger.severe("حدث خطأ أثناء تحميل المخزون: $e");
//     } finally {
//       _isLoading.value = false;
//       update();
//     }
//   }

//   // تحميل أنواع الصناديق
//   Future<void> loadBoxTypes() async {
//     try {
//       statusRequest.value = STATUSREQUEST.loading;
//       _isLoading.value = true;
//       update();

//       final boxTyperespnse = await addOrderRespone.getBoxTypes();
//       if (boxTyperespnse.isNotEmpty) {
//         boxTypes.assignAll(boxTyperespnse);
//         statusRequest.value = STATUSREQUEST.success;
//       } else {
//         statusRequest.value = STATUSREQUEST.failure;
//       }
//     } catch (e) {
//       statusRequest.value = STATUSREQUEST.servicefailer;
//       print('حدث خطأ أثناء تحميل أنواع الصناديق: $e');
//     } finally {
//       _isLoading.value = false;
//       update();
//     }
//   }

//   // تحميل بيانات العملاء
//   Future<void> loadCustomers() async {
//     try {
//       statusRequest.value = STATUSREQUEST.loading;
//       _isLoading.value = true;
//       update();

//       final customersResponse = await addOrderRespone.getCustomers();
//       if (customersResponse.isNotEmpty) {
//         customers.assignAll(customersResponse);
//         statusRequest.value = STATUSREQUEST.success;
//       } else {
//         statusRequest.value = STATUSREQUEST.failure;
//       }
//     } catch (e) {
//       statusRequest.value = STATUSREQUEST.servicefailer;
//       print('حدث خطأ أثناء تحميل العملاء: $e');
//     } finally {
//       _isLoading.value = false;
//       update();
//     }
//   }

//   // إضافة عميل جديد
//   addCustomer() async {
//     try {
//       final customerserviceadd = await addOrderRespone.addCustomer(
//           nameController.text, phoneController.text, locationController.text);
//       if (customerserviceadd.isNotEmpty) {
//         customers.add(customerserviceadd.first);
//         onCustomerSelected(customerserviceadd.first);
//       }
//     } catch (e) {}
//   }

//   // عند اختيار عميل
//   void onCustomerSelected(CustomerModel? customer) {
//     selectedCustomer.value = customer;
//     if (customer != null) {
//       customerid = customer.id.toString();
//     }
//   }

//   // عند اختيار نوع الصندوق
//   void onBoxTypeSelected(BoxType? boxType) {
//     selectedBoxType.value = boxType;
//     if (boxType != null) {
//       boxid = boxType.id.toString();
//       quantityController.clear();

//       printDebugInfo(boxType.name);

//       int availableQuantity = getAvailableQuantityByBoxName(boxType.name);
//       Get.snackbar(
//         'معلومات المخزون',
//         'الكمية المتوفرة من ${boxType.name} هي $availableQuantity صندوق',
//         snackPosition: SnackPosition.TOP,
//         duration: const Duration(seconds: 3),
//       );
//     }
//   }

//   // حساب الكمية المتوفرة حسب اسم نوع الصندوق
//   int getAvailableQuantityByBoxName(String boxName) {
//     try {
//       // البحث عن الصناديق المطابقة بالاسم
//       var matchingBoxes =
//           boxInventory.where((box) => box.boxType.name == boxName).toList();

//       if (matchingBoxes.isEmpty) {
//         _logger.warning('لم يتم العثور على صناديق بالاسم: $boxName');
//         return 0;
//       }

//       // حساب الكمية الإجمالية المتوفرة
//       int totalAvailable = 0;
//       for (var box in matchingBoxes) {
//         int available = box.quantity;
//         totalAvailable = box.quantity;
//         _logger.info('معرف الصندوق: ${box.id}, المتوفر: $available '
//             '(الكمية: ${box.quantity}, المستلم: ${box.receivedQuantity})');
//       }

//       _logger.info('إجمالي المتوفر لـ $boxName: $totalAvailable');
//       return totalAvailable;
//     } catch (e) {
//       _logger.severe('حدث خطأ أثناء حساب الكمية المتوفرة: $e');
//       return 0;
//     }
//   }

//   // طباعة معلومات التصحيح
//   void printDebugInfo(String boxName) {
//     try {
//       var boxType = boxTypes.firstWhere((type) => type.name == boxName,
//           orElse: () => BoxType(
//               id: -1,
//               name: '',
//               description: '',
//               createdAt: DateTime.now(),
//               updatedAt: DateTime.now()));

//       _logger
//           .info('تم العثور على نوع الصندوق: ${boxType.id} - ${boxType.name}');

//       var matchingBoxes =
//           boxInventory.where((box) => box.boxTypeId == boxType.id).toList();
//       _logger.info('عدد الصناديق المطابقة: ${matchingBoxes.length}');

//       for (var box in matchingBoxes) {
//         _logger.info('رقم الفاتورة: ${box.invoiceNumber}, '
//             'الكمية: ${box.quantity}, '
//             'المستلم: ${box.receivedQuantity}');
//       }
//     } catch (e) {
//       _logger.severe('Debug Error: $e');
//     }
//   }

//   // التحقق من الكمية المتوفرة
//   void checkAvailableBoxes(String boxName) {
//     int available = getAvailableQuantityByBoxName(boxName);
//     Get.snackbar(
//       'الكمية المتوفرة',
//       'الكمية المتوفرة من $boxName هي $available صندوق',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   // التحقق من صحة الكمية المدخلة
//   String? validateQuantity(String? value) {
//     if (value == null || value.isEmpty) {
//       return '60'.tr;
//     }

//     final quantity = int.tryParse(value);
//     if (quantity == null || quantity <= 0) {
//       return '61'.tr;
//     }

//     if (selectedBoxType.value != null) {
//       final availableQuantity =
//           getAvailableQuantityByBoxName(selectedBoxType.value!.name);
//       if (quantity > availableQuantity) {
//         return 'الكمية المطلوبة ($quantity) أكبر من الكمية المتوفرة ($availableQuantity)';
//       }
//     }

//     return null;
//   }

//   // التحقق من صحة السعر المدخل
//   String? validatePrice(String? value) {
//     if (value == null || value.isEmpty) {
//       return '62'.tr;
//     }
//     final price = double.tryParse(value);
//     if (price == null || price <= 0) {
//       return '63'.tr;
//     }
//     return null;
//   }

//   // إغلاق الحقول عند الانتهاء
//   @override
//   void onClose() {
//     nameController.dispose();
//     phoneController.dispose();
//     locationController.dispose();
//     quantityController.dispose();
//     receiptDateController.dispose();
//     priceController.dispose();
//     notesController.dispose();
//     super.onClose();
//   }

//   // اختيار التاريخ
//   Future<void> selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       receiptDateController.text = picked.toString().split(' ')[0];
//     }
//   }

//   // الانتقال إلى الخطوة التالية
//   void nextStep() {
//     if (currentStep.value == 0) {
//       if (selectedCustomer.value == null) {
//         Get.snackbar('64'.tr, '65'.tr, snackPosition: SnackPosition.BOTTOM);
//         return;
//       }
//     } else if (currentStep.value == 1) {
//       // التحقق من اختيار الصندوق والكمية
//       if (selectedBoxType.value == null ||
//           quantityController.text.isEmpty ||
//           priceController.text.isEmpty) {
//         Get.snackbar('64'.tr, '66'.tr, snackPosition: SnackPosition.BOTTOM);
//         return;
//       }

//       // التحقق من الكمية مقابل المخزون المتاح
//       final quantityValidation = validateQuantity(quantityController.text);
//       if (quantityValidation != null) {
//         Get.snackbar('خطأ في الكمية', quantityValidation,
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.red,
//             colorText: Colors.white);
//         return;
//       }
//     } else if (currentStep.value == 2) {
//       if (selectedDeliveryMethod.value == null ||
//           receiptDateController.text.isEmpty) {
//         Get.snackbar(
//           '64'.tr,
//           '67'.tr,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }
//       submitOrder();
//       return;
//     }

//     currentStep.value++;
//   }

//   // الانتقال إلى الخطوة السابقة
//   void previousStep() {
//     if (currentStep.value > 0) {
//       currentStep.value--;
//     }
//   }

//   // إضافة الطلب
//   void submitOrder() async {
//     try {
//       statusRequest.value = STATUSREQUEST.loading;
//       if (!formKey.currentState!.validate()) return;

//       final userData = _myServices.sharedPreferences.getString('userData');
//       if (userData == null) return;

//       _isLoading.value = true;
//       final userId =
//           Representative.fromJson(jsonDecode(userData)).id.toString();

//       final success = await addOrderRespone.addOrder(
//           customerid,
//           boxid,
//           userId,
//           quantityController.text,
//           receiptDateController.text,
//           receiptMethod.value,
//           priceController.text,
//           notesController.text);

//       if (success) {
//         statusRequest.value = STATUSREQUEST.success;
//         _isLoading.value = false;
//         Get.snackbar(
//           '68'.tr,
//           '69'.tr,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         _resetForm();
//         loadBoxInvertoy();
//           } else {
//         statusRequest.value = STATUSREQUEST.failure;
//         _isLoading.value = false;
//         Get.snackbar(
//           '9'.tr,
//           '70'.tr,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       statusRequest.value = STATUSREQUEST.servicefailer;
//       _isLoading.value = false;
//       Get.snackbar(
//         'خطأ',
//         'حدث خطأ أثناء إضافة الطلب',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   // إعادة تعيين الحقول
//   void _resetForm() {
//     nameController.clear();
//     phoneController.clear();
//     locationController.clear();
//     quantityController.clear();
//     receiptDateController.clear();
//     priceController.clear();
//     notesController.clear();
//     selectedBoxType.value = null;
//     receiptMethod.value = '';
//     currentStep.value = 0;
//   }

//   // عرض حوار إضافة العميل
//   void showAddCustomerDialog() {
//     CustomAlertDialog.show(
//       context: Get.context!,
//       title: '71'.tr,
//       customContent: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextFormFieldCustom(
//             label: '72'.tr,
//             hint: '73'.tr,
//             controller: nameController,
//             leadingIcon: Icons.person,
//           ),
//           const SizedBox(height: 16),
//           TextFormFieldCustom(
//             label: '74'.tr,
//             hint: '75'.tr,
//             controller: phoneController,
//             leadingIcon: Icons.phone,
//             keyboardType: TextInputType.phone,
//           ),
//           const SizedBox(height: 16),
//           TextFormFieldCustom(
//             label: '76'.tr,
//             hint: '77'.tr,
//             controller: locationController,
//             leadingIcon: Icons.location_on,
//           ),
//         ],
//       ),
//       showTextField: false,
//       confirmButtonText: '78'.tr,
//       onConfirmActions: [
//         () async {
//           await addCustomer();
//           nameController.clear();
//           phoneController.clear();
//           locationController.clear();
//         }
//       ],
//     );
//   }
// }
