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
}
