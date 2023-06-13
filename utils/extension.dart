extension Validations on String {
  String? toValidEmail() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern.toString());
    if (isEmpty) {
      return "Email Required";
    }
    if (!regExp.hasMatch(this)) {
      return "Invalid Email";
    }
    return null;
  }

  String? toValidateCnic() {
    Pattern pattern = "^[0-9]{5}-[0-9]{7}-[0-9]{1}";
    RegExp regExp = RegExp(pattern.toString());
    if (isEmpty) {
      return "Required";
    }
    if (!regExp.hasMatch(this)) {
      return "Invalid CNIC";
    }
    return null;
  }

  String? toValidPassword() {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?).{8,}$');

    if (isEmpty) {
      return "Password Required";
    }
    if (length < 8) {
      return "Password is to short (minimum length is 8)";
    }
    if (!regex.hasMatch(this)) {
      return "Password should be 8 character long containing at least \n1 Numeric\n1 Alphabet \n1 Capital \n1 Special Character ";
    }
    return null;
  }

  String? toValidPhoneNumber() {
    print(this);
    if (isEmpty) {
      print('in1');
      return "Phone Number Required";
    }

    if (this.length != 14) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  double? toDouble() {
    if (isNotEmpty) {
      return double.parse(trim());
    }

    return null;
  }

  String? toCapitalized() =>
      (length > 1) ? this[0].toUpperCase() + substring(1) : toUpperCase();

  String? toCheckNullEmpty() {
    if (isNotEmpty) {
      return this;
    }

    return "N/A";
  }
}
