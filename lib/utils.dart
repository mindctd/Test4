class Utils {
  bool isValidUsername(String username) {
    final RegExp regExp = RegExp(
      r'^[^\s\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}]{5,}$',
      unicode: true,
    );

    return regExp.hasMatch(username);
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
      r'^[^\s][\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
    );
    return regex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final RegExp regExp = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
    );

    return regExp.hasMatch(password);
  }

  bool isValidName(String name) {
    final RegExp regExp = RegExp(
      r'^(?!\s*$)[^\s\u{1F600}-\u{1F6FF}]+$',
      unicode: true,
    );

    return regExp.hasMatch(name);
  }

  bool isValidSurname(String name) {
    final RegExp regExp = RegExp(
      r'^(?!\s*$)[^\s\u{1F600}-\u{1F6FF}]+$',
      unicode: true,
    );

    return regExp.hasMatch(name);
  }

  bool istelephoneNumber(String number) {
    final RegExp regExp = RegExp(r'^0\d{9}$');

    return regExp.hasMatch(number);
  }

  bool isValidAddress(String address) {
    final RegExp regExp = RegExp(
      r'^[^\u{1F600}-\u{1F6FF}]+$',
      unicode: true,
    );

    return regExp.hasMatch(address);
  }
}
