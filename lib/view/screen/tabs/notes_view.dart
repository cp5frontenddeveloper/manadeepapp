import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/view/widget/sharedwidget/dialogs/custom_alert_dialog.dart';
import '../../../controllers/notes/notes_controller.dart';
import '../../widget/sharedwidget/cards/custom_card.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Note"),
        centerTitle: true,
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.notes.length,
            itemBuilder: (context, index) {
              return Dismissible(
                  key: Key(controller.notes[index]['id'].toString()),
                  onDismissed: (_) => controller.deleteNote(index),
                  background: Container(
                    color: theme.colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: theme.colorScheme.onError),
                  ),
                  child: CustomCard(
                    title: controller.notes[index]['note'],
                  ));
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    CustomAlertDialog.show(
      context: context,
      title: '80'.tr,
      label: '55'.tr,
      hint: '56'.tr,
      confirmButtonText: '78'.tr,
      cancelButtonText: '79'.tr,
      onConfirm: (value) {
        if (value.isNotEmpty) {
          controller.addNote(value['main']!);
        }
      },
      onCancel: () => Get.back(),
    );
  }
}
