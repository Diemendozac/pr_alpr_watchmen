
import 'package:flutter/material.dart';

class TextInputHelper {

  static validateEmail(String? value) {

    if (value == null || value.isEmpty) {
      return 'Este campo es necesario';
    }
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Ingrese un email válido';
    }

    return null;

  }

  static validatePassword (String? value) {

    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;

  }

  static validatePlate (String? value) {

    if (value == null || value.isEmpty) {
      return 'Ingrese una placa antes';
    }
    value = value.toUpperCase();
    final RegExp plateRegex = RegExp('[A-Z]{3}([0-9]){2}([A-Z0-9]{1})');

    if (!plateRegex.hasMatch(value)) {
      return 'Ingrese una placa válida';
    }
    return null;

  }

  static InputDecoration buildTextInputDecoration(BuildContext context, String inputLabel) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0x50bdbdbd),
      contentPadding: const EdgeInsets.all(15),
      label: Text(inputLabel),
      floatingLabelStyle: const TextStyle(color: Colors.transparent),
      labelStyle: Theme
          .of(context)
          .textTheme
          .titleSmall,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
    );
  }


}