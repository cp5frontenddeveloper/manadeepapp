// استيراد المكتبات اللازمة
import 'package:flutter/material.dart';

import '../../data/models/communicationlog.dart';

// بطاقة عرض الإشعارات
class NotificationCard extends StatelessWidget {
  // خصائص البطاقة
  final CommunicationLog log; // سجل الإشعار
  final VoidCallback onTap; // دالة النقر

  // منشئ البطاقة
  const NotificationCard({
    Key? key,
    required this.log,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الحصول على السمات
    final theme = Theme.of(context);
    // تنسيق التاريخ
    // ignore: unused_local_variable
    final dateStr = "${log.date.year}-${log.date.month}-${log.date.day}";

    // التحقق مما إذا كان الإشعار يحتاج إلى رد
    final bool needsResponse = log.isNew || log.note == null;

    // إنشاء البطاقة
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      // تلوين البطاقة حسب حالة الرد
      color: needsResponse ? theme.colorScheme.primary.withOpacity(0.1) : null,
      child: ListTile(
        onTap: onTap,
        title: Text(log.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        ),
        // محتوى البطاقة
        // subtitle: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(dateStr),
        //     // عرض الرد إذا كان موجودا
        //     if (log.note != null && log.note!.isNotEmpty)
        //       Text(
        //         log.note!,
        //         style: theme.textTheme.bodySmall?.copyWith(
        //           color: theme.colorScheme.secondary,
        //         ),
        //       ),
        //     // عرض رسالة طلب الرد إذا لم يكن هناك رد
        //     if (log.note == null)
        //       Text(
        //         'بحاجة إلى رد',
        //         style: theme.textTheme.bodySmall?.copyWith(
        //           color: theme.colorScheme.error,
        //         ),
        //       ),
        //   ],
        // ),
        // أيقونة حالة الإشعار
        leading: Icon(
          needsResponse ? Icons.mark_email_unread : Icons.mark_email_read,
          color: needsResponse
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
