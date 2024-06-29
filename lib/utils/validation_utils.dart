class ValidationUtils {
  static bool isValidEmail(String? email) {
    if (email == null) return false;
    var regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  static bool isValidMobile(String? mobile) {
    if (mobile == null) return false;
    // var regex = RegExp(r"^\d{11}$");

    return true;
  }

  static bool isValidFullName(String? fullName) {
    if (fullName!.trim().length < 5) return false;
    // var regex = RegExp(r"^\d{11}$");

    return true;
  }

  static bool isValidPassword(String? passwrod) {
    if (!(passwrod!.trim().length >= 8)) return false;
    // var regex = RegExp(r"^\d{11}$");

    return true;
  }
}
