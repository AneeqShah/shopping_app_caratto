extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PhoneNumValidator on String {
  bool isValidPhoneNum() {
    return RegExp(r'(^(?:[+]998)?[0-9]{9}$)').hasMatch(this);
  }
}

extension IsAlpha on String {
  bool isAlpha() {
    return RegExp('[a-zA-Z]').hasMatch(this);
  }
}

extension IsNum on String {
  bool isNum() {
    return RegExp(r'\d').hasMatch(this);
  }
}
