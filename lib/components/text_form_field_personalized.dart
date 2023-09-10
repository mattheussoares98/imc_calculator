import 'package:flutter/material.dart';

class TextFormFieldPersonalized {
  static Widget formField({
    required TextEditingController controller,
    required BuildContext context,
    required String labelText,
    required String? Function(String?)? validator,
    required TextInputType textInputType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          decorationColor: Colors.black,
          color: Colors.black,
          fontSize: 20,
        ),
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          labelText: labelText,
          counterStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
