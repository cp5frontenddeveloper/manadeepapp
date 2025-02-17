import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ويدجت مخصص لحقل إدخال النص
class TextFormFieldCustom extends StatefulWidget {
  const TextFormFieldCustom({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.readonly = false,
    this.initiallyObscured = false,
    this.suffixIcon,
    this.onChanged,
    this.leadingIcon,
    this.maxLines = 1,
    this.onTap,
  });

  // خصائص الويدجت
  final String label; // نص العنوان
  final String hint; // نص التلميح
  final TextEditingController controller; // متحكم النص
  final String? Function(String?)? validator; // دالة التحقق
  final List<TextInputFormatter>? inputFormatters; // منسقات الإدخال
  final TextInputType? keyboardType; // نوع لوحة المفاتيح
  final bool readonly; // للقراءة فقط
  final bool initiallyObscured; // إخفاء النص مبدئياً
  final Widget? suffixIcon; // أيقونة في نهاية الحقل
  final Function(String)? onChanged;
  final IconData? leadingIcon;
  final int? maxLines;
  final VoidCallback? onTap;

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  // حالة إخفاء النص
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initiallyObscured;
  }

  // تبديل حالة إظهار/إخفاء النص
  void _toggleObscureText() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty) ...[
            Text(
              widget.label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            readOnly: widget.readonly,
            onChanged: widget.onChanged,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines,
            onTap: widget.onTap,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.5),
              ),
              prefixIcon: widget.leadingIcon != null
                  ? Icon(widget.leadingIcon, color: theme.colorScheme.primary)
                  : null,
              suffixIcon: widget.suffixIcon ?? _buildPasswordIcon(),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  // بناء أيقونة كلمة المرور
  Widget? _buildPasswordIcon() {
    return widget.initiallyObscured
        ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: _toggleObscureText,
          )
        : null;
  }
}
