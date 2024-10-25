
class InputValidator {

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

}