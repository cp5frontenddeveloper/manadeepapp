import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manadeebapp/view/screen/tabs/email_like_chat.dart';

import '../../../controllers/admin_communication_controller.dart';
import '../../../core/constants/class/status_request.dart';
import '../../widget/notificatio_cnard.dart';

class AdminCommunicationView extends GetView<AdminCommunicationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التواصل الاداري"),
        centerTitle:true,
      ),
      body: Obx(() {
        if (controller.status.value == STATUSREQUEST.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.status.value == STATUSREQUEST.servicefailer) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('13'.tr),
                ElevatedButton(
                  onPressed: controller.fetchLogs,
                  child: Text('14'.tr),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchLogs,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.logs.length,
            itemBuilder: (context, index) {
              final log = controller.logs[index];
              final showDateDivider = index == 0 ||
                  controller.logs[index].date.day !=
                      controller.logs[index - 1].date.day;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDateDivider)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _formatDate(log.date),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  NotificationCard(
                    log: log,
                    onTap: () {
                      Get.to(() => EmailLikeChatPage(logs: log,));
                    },
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'اليوم';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'أمس';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
