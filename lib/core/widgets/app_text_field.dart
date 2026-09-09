import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppTextField extends StatelessWidget {
const AppTextField({
    super.key,
 required this.controller,
 required this.label,
 this.hint,
 this.obscureText = false,
 this.keyboardType,
 this.prefixIcon,
 this.suffixIcon,
 this.validator,
 this.maxLines = 1,
 this.readOnly = false,
 this.onTap,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
obscureText: obscureText,
keyboardType: keyboardType,
validator: validator,
maxLines: maxLines,
readOnly: readOnly,
onTap: onTap,
decoration: InputDecoration(
        labelText: label,
hintText: hint,
prefixIcon: prefixIcon == null
? null
: Icon(
                prefixIcon,
size: 22,
color: AppTheme.primaryOrange,
              ),
suffixIcon: suffixIcon,
      ),
    );
  }
}