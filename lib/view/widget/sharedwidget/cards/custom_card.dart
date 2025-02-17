import 'package:flutter/material.dart';
import '../customlisttitle/custom_listtitle.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? cardColor;
  final BorderRadius? borderRadius;
  final String? subtitle;
  final bool isSelected;

  const CustomCard({
    super.key,
    required this.title,
    this.leadingIcon = Icons.note_add_outlined,
    this.trailingIcon = Icons.arrow_forward_ios_outlined,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.elevation = 0,
    this.cardColor,
    this.borderRadius,
    this.subtitle,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor ?? theme.colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: CustomListTile(
          title: title,
          subtitle: subtitle,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          iconColor: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withOpacity(0.7),
          titleStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
