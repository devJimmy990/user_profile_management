import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const InputField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
