import 'package:flutter/material.dart';
import '../buttons/custom_button.dart';
import '../forms/custom_textform.dart';

/// مربع حوار مخصص قابل لإعادة الاستخدام
class CustomAlertDialog {
  /// عرض مربع الحوار المخصص
  /// 
  /// المعلمات:
  /// * [context] - سياق البناء المطلوب
  /// * [title] - عنوان مربع الحوار (اختياري)
  /// * [label] - تسمية حقل النص (اختياري)
  /// * [hint] - نص التلميح لحقل النص (اختياري)
  /// * [confirmButtonText] - نص زر التأكيد (اختياري)
  /// * [cancelButtonText] - نص زر الإلغاء (اختياري)
  /// * [onConfirm] - دالة يتم تنفيذها عند التأكيد (اختياري)
  /// * [onConfirmActions] - قائمة الإجراءات التي يتم تنفيذها عند التأكيد (اختياري)
  /// * [onCancel] - دالة يتم تنفيذها عند الإلغاء (اختياري)
  /// * [onCancelActions] - قائمة الإجراءات التي يتم تنفيذها عند الإلغاء (اختياري)
  /// * [customContent] - محتوى مخصص لعرضه في مربع الحوار (اختياري)
  /// * [showTextField] - ما إذا كان سيتم عرض حقل النص (افتراضي: صحيح)
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? label,
    String? hint,
    String? confirmButtonText,
    String? cancelButtonText,
    bool barrierDismissible = true,
    Function(Map<String, String>)? onConfirm,
    List<Function()>? onConfirmActions,
    VoidCallback? onCancel,
    List<Function()>? onCancelActions,
    Widget? customContent,
    bool showTextField = true,
    bool showCancelButton = true

  }) {
    final theme = Theme.of(context);
    final textController = TextEditingController();
    final formValues = <String, String>{};

    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        title: _buildTitle(title, theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContent(customContent, showTextField, label, hint, textController, formValues),
            const SizedBox(height: 20),
            _buildButtonsRow(
              context,
              confirmButtonText,
              cancelButtonText,
              showTextField,
              textController,
              formValues,
              onConfirm,
              onConfirmActions,
              onCancel,
              onCancelActions,
              showCancelButton
            )
          ],
        ),
      ),
    );
  }

  /// بناء عنوان مربع الحوار
  static Widget? _buildTitle(String? title, ThemeData theme) {
    if (title == null) return null;
    return Text(title, style: theme.textTheme.titleLarge);
  }

  /// بناء محتوى مربع الحوار
  static Widget _buildContent(
    Widget? customContent,
    bool showTextField,
    String? label,
    String? hint,
    TextEditingController controller,
    Map<String, String> formValues,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (customContent != null) customContent,
        if (showTextField)
          TextFormFieldCustom(
            label: label ?? '',
            hint: hint ?? '',
            controller: controller,
            onChanged: (value) => formValues['main'] = value,
          ),
      ],
    );
  } 
  /// بناء صف الأزرار
  static Widget _buildButtonsRow(
    BuildContext context,
    String? confirmButtonText,
    String? cancelButtonText,
    bool showTextField,
    TextEditingController controller,
    Map<String, String> formValues,
    Function(Map<String, String>)? onConfirm,
    List<Function()>? onConfirmActions,
    VoidCallback? onCancel,
    List<Function()>? onCancelActions,
    bool? showCancelButton,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildConfirmButton(
            context,
            confirmButtonText,
            showTextField,
            controller,
            formValues,
            onConfirm,
            onConfirmActions,
          ),
        ),
        if (showCancelButton ?? true)
          Expanded(
            child: _buildCancelButton(
              context,
              cancelButtonText,
              onCancel,
              onCancelActions,
            ),
          ),
      ],
    );
  }

  /// بناء زر التأكيد
  static Widget _buildConfirmButton(
    BuildContext context,
    String? confirmButtonText,
    bool showTextField,
    TextEditingController controller,
    Map<String, String> formValues,
    Function(Map<String, String>)? onConfirm,
    List<Function()>? onConfirmActions,
  ) {
    return CustomButton(
      text: confirmButtonText ?? "حفظ",
      onPressed: () {
        if (!showTextField || controller.text.isNotEmpty) {
          if (onConfirm != null && showTextField) {
            formValues['main'] = controller.text;
            onConfirm(formValues);
          }
          onConfirmActions?.forEach((action) => action());
          Navigator.of(context).pop();
        }
      },
      width: double.infinity,
      height: 45,
      elevation: 2,
    );
  }

  /// بناء زر الإلغاء
  static Widget _buildCancelButton(
    BuildContext context,
    String? cancelButtonText,
    VoidCallback? onCancel,
    List<Function()>? onCancelActions,
  ) {
    return CustomButton(
      text: cancelButtonText ?? "إلغاء",
      onPressed: () {
        onCancel?.call();
        onCancelActions?.forEach((action) => action());
        Navigator.of(context).pop();
      },
      width: double.infinity,
      height: 45,
      elevation: 2,
    );
  }
}
