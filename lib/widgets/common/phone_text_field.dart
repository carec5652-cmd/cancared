import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable phone number text field with validation
class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final bool enabled;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction ?? TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: labelText ?? 'Phone Number',
        hintText: hintText ?? '00962 7X XXX XXXX',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[200],
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            // Basic validation for Jordan phone numbers (00962)
            if (value.length < 9 || value.length > 12) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
    );
  }
}

