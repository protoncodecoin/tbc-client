import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController textController;
  final bool isPasswordField;
  const CustomFormField({
    super.key,
    required this.labelText,
    required this.textController,
    this.isPasswordField = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        label: Text(
          labelText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      obscureText: isPasswordField,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$labelText is missing";
        }
        return null;
      },
    );
  }
}
