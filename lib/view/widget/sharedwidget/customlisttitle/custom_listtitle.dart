/// قائمة مخصصة قابلة للتخصيص مع العديد من الخيارات
///
/// تتيح هذه القائمة إنشاء عنصر قائمة مع:
/// * `title` - نص العنوان الرئيسي (مطلوب)
/// * `subtitle` - نص العنوان الفرعي (اختياري)
/// * `leadingIcon` - أيقونة في بداية القائمة (اختياري)
/// * `trailingIcon` - أيقونة في نهاية القائمة (اختياري)
/// * `onTap` - وظيفة يتم تنفيذها عند النقر (اختياري)
/// * `backgroundColor` - لون خلفية القائمة (اختياري)
/// * `contentPadding` - المسافة الداخلية للمحتوى (اختياري)
/// * `dense` - لجعل القائمة أكثر تراصاً (افتراضي: false)
/// * `enabled` - لتفعيل أو تعطيل القائمة (افتراضي: true)
/// * `iconSize` - حجم الأيقونات (اختياري)
/// * `iconColor` - لون الأيقونات (اختياري)
/// * `titleStyle` - نمط نص العنوان (اختياري)
/// * `subtitleStyle` - نمط نص العنوان الفرعي (اختياري)
///
/// مثال:
/// ```dart
/// CustomListTile(
///   title: 'عنوان القائمة',
///   subtitle: 'عنوان فرعي',
///   leadingIcon: Icons.home,
///   onTap: () {
///     print('تم النقر على القائمة');
///   },
/// )
/// ```
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Function()? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final bool enabled;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const CustomListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailingIcon,
    this.onTap,
    this.backgroundColor,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.dense = false,
    this.enabled = true,
    this.iconSize = 24,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: contentPadding!,
            child: Row(
              children: [
                if (leadingIcon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? theme.colorScheme.primary)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      leadingIcon,
                      color: iconColor ?? theme.colorScheme.primary,
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: titleStyle ??
                            theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: enabled
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                            ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: subtitleStyle ??
                              theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 12),
                  Icon(
                    trailingIcon,
                    color:
                        iconColor ?? theme.colorScheme.primary.withOpacity(0.5),
                    size: iconSize! - 4,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
