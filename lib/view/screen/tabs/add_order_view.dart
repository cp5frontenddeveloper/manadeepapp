// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:manadeebapp/data/models/customer_model.dart';
// import '../../../controllers/orders/add_order_controller.dart';
// import '../../../core/constants/class/status_request.dart';
// import '../../../data/models/box_type_model.dart';
// import '../../../data/models/deliverymethod.dart';
// import '../../widget/sharedwidget/buttons/custom_button.dart';
// import '../../widget/sharedwidget/forms/custom_textform.dart';

// class AddOrderView extends GetView<AddOrderController> {
//   const AddOrderView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: Obx(() {
//         if (controller.statusRequest.value == STATUSREQUEST.loading) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   color: theme.colorScheme.primary,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'جاري إضافة الطلب...',
//                   style: theme.textTheme.titleMedium,
//                 ),
//               ],
//             ),
//           );
//         }

//         return Form(
//           key: controller.formKey,
//           child: Obx(() => Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     EasyStepper(
//                       activeStep: controller.currentStep.value,
//                       direction: Axis.horizontal,
//                       showStepBorder: true,
//                       stepRadius: 24,
//                       showLoadingAnimation: false,
//                       stepShape: StepShape.circle,
//                       borderThickness: 2,
//                       padding: const EdgeInsets.all(16),
//                       activeStepBorderColor: theme.colorScheme.primary,
//                       activeStepIconColor: theme.colorScheme.onPrimary,
//                       activeStepTextColor: theme.colorScheme.primary,
//                       finishedStepBackgroundColor: theme.colorScheme.primary,
//                       finishedStepBorderColor: theme.colorScheme.primary,
//                       finishedStepTextColor: theme.colorScheme.primary,
//                       finishedStepIconColor: theme.colorScheme.onPrimary,
//                       activeStepBackgroundColor: theme.colorScheme.primary,
//                       steps: [
//                         EasyStep(
//                           customStep: CircleAvatar(
//                             radius: 24,
//                             backgroundColor: controller.currentStep.value >= 0
//                                 ? theme.colorScheme.primary
//                                 : theme.colorScheme.surface,
//                             child: Icon(
//                               Icons.person,
//                               color: controller.currentStep.value >= 0
//                                   ? theme.colorScheme.onPrimary
//                                   : theme.colorScheme.onSurface,
//                             ),
//                           ),
//                           title: '36'.tr,
//                         ),
//                         EasyStep(
//                           customStep: CircleAvatar(
//                             radius: 24,
//                             backgroundColor: controller.currentStep.value >= 1
//                                 ? theme.colorScheme.primary
//                                 : theme.colorScheme.surface,
//                             child: Icon(
//                               Icons.inventory,
//                               color: controller.currentStep.value >= 1
//                                   ? theme.colorScheme.onPrimary
//                                   : theme.colorScheme.onSurface,
//                             ),
//                           ),
//                           title: '37'.tr,
//                         ),
//                         EasyStep(
//                           customStep: CircleAvatar(
//                             radius: 24,
//                             backgroundColor: controller.currentStep.value >= 2
//                                 ? theme.colorScheme.primary
//                                 : theme.colorScheme.surface,
//                             child: Icon(
//                               Icons.description,
//                               color: controller.currentStep.value >= 2
//                                   ? theme.colorScheme.onPrimary
//                                   : theme.colorScheme.onSurface,
//                             ),
//                           ),
//                           title: '20'.tr,
//                         ),
//                       ],
//                       onStepReached: (index) =>
//                           controller.currentStep.value = index,
//                     ),
//                     const SizedBox(height: 24),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: _buildCurrentStep(theme),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildNavigationButtons(theme),
//                   ],
//                 ),
//               )),
//         );
//       }),
//     );
//   }

//   Widget _buildCurrentStep(ThemeData theme) {
//     switch (controller.currentStep.value) {
//       case 0:
//         return Column(
//           children: [
//             _buildHeader(theme),
//             const SizedBox(height: 24),
//             _buildClientSection(theme),
//           ],
//         );
//       case 1:
//         return _buildBoxSection(theme);
//       case 2:
//         return _buildOrderDetailsSection(theme);
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _buildNavigationButtons(ThemeData theme) {
//     return Row(
//       children: [
//         if (controller.currentStep.value != 0)
//           Expanded(
//             child: CustomButton(
//               text: '38'.tr,
//               onPressed: controller.previousStep,
//               height: 45,
//             ),
//           ),
//         if (controller.currentStep.value != 0) const SizedBox(width: 12),
//         Expanded(
//           child: CustomButton(
//             text: controller.currentStep.value >= 2 ? '40'.tr : '39'.tr,
//             onPressed: controller.nextStep,
//             height: 45,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader(ThemeData theme) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(
//           Icons.add_shopping_cart_rounded,
//           size: 48,
//           color: theme.colorScheme.primary,
//         ),
//         const SizedBox(height: 16),
//         Text(
//           '41'.tr,
//           style: theme.textTheme.headlineMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onBackground,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           '42'.tr,
//           style: theme.textTheme.bodyLarge?.copyWith(
//             color: theme.colorScheme.onBackground.withOpacity(0.7),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSection(ThemeData theme, String title, List<Widget> children) {
//     return Container(
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: theme.shadowColor.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: theme.textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildClientSection(ThemeData theme) {
//     return _buildSection(
//       theme,
//       '36'.tr,
//       [
//         Column(
//           children: [
//             CustomButton(
//               text: '43'.tr,
//               onPressed: () => controller.showAddCustomerDialog(),
//               icon: Icons.add,
//               width: double.infinity,
//               height: 56,
//             ),
//             const SizedBox(height: 16),
//             Obx(() => DropdownButtonFormField<CustomerModel>(
//                   decoration: InputDecoration(
//                     labelText: '44'.tr,
//                     prefixIcon: const Icon(Icons.person),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.white,
//                   ),
//                   value: controller.selectedCustomer.value,
//                   items: controller.customers.map((customer) {
//                     return DropdownMenuItem(
//                       value: customer,
//                       child: Text(customer.name),
//                     );
//                   }).toList(),
//                   onChanged: controller.onCustomerSelected,
//                   hint: Text('45'.tr),
//                 )),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildBoxSection(ThemeData theme) {
//     return _buildSection(
//       theme,
//       '37'.tr,
//       [
//         Obx(() => DropdownButtonFormField<BoxType>(
//               decoration: InputDecoration(
//                 labelText: '18'.tr,
//                 prefixIcon: const Icon(Icons.category),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               value: controller.selectedBoxType.value,
//               items: controller.boxTypes.map((boxType) {
//                 return DropdownMenuItem(
//                   value: boxType,
//                   child: Text('${boxType.name}'),
//                 );
//               }).toList(),
//               onChanged: controller.onBoxTypeSelected,
//               validator: (value) => value == null ? '46'.tr : null,
//             )),
//         const SizedBox(height: 8),
//         Obx(() => controller.selectedBoxType.value != null
//             ? Container(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.primary.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.inventory,
//                         color: theme.colorScheme.primary, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       'الكمية المتوفرة: ${controller.getAvailableQuantityByBoxName(controller.selectedBoxType.value!.name)}',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: theme.colorScheme.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : const SizedBox.shrink()),
//         const SizedBox(height: 16),
//         TextFormFieldCustom(
//           label: '19'.tr,
//           hint: '47'.tr,
//           controller: controller.quantityController,
//           validator: controller.validateQuantity,
//           leadingIcon: Icons.shopping_cart,
//           keyboardType: TextInputType.number,
//         ),
//         const SizedBox(height: 16),
//         TextFormFieldCustom(
//           label: '27'.tr,
//           hint: '48',
//           controller: controller.priceController,
//           validator: controller.validatePrice,
//           leadingIcon: Icons.attach_money,
//           keyboardType: TextInputType.number,
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderDetailsSection(ThemeData theme) {
//     return _buildSection(
//       theme,
//       '49'.tr,
//       [
//         Obx(() => DropdownButtonFormField<DeliveryMethod>(
//               decoration: InputDecoration(
//                 labelText: '50'.tr,
//                 prefixIcon: const Icon(Icons.local_shipping),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               value: controller.selectedDeliveryMethod.value,
//               items: controller.deliveryMethods.map((method) {
//                 return DropdownMenuItem(
//                   value: method,
//                   child: Text('${method.name} - ${method.price} ' + '28'.tr),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   controller.selectedDeliveryMethod.value = value;
//                   controller.receiptMethod.value = value.name;
//                 }
//               },
//               validator: (value) => value == null ? '51'.tr : null,
//             )),
//         const SizedBox(height: 16),
//         TextFormFieldCustom(
//           label: '52'.tr,
//           hint: '53'.tr,
//           controller: controller.receiptDateController,
//           validator: (value) => value?.isEmpty ?? true ? '54'.tr : null,
//           leadingIcon: Icons.calendar_today,
//           readonly: true,
//           onTap: () => controller.selectDate(Get.context!),
//         ),
//         const SizedBox(height: 16),
//         TextFormFieldCustom(
//           label: '55'.tr,
//           hint: '56'.tr,
//           controller: controller.notesController,
//           leadingIcon: Icons.note,
//           maxLines: 3,
//         ),
//       ],
//     );
//   }
// }
