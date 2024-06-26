bool validateEmailAddress(String email) {
  final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.(edu\.ph)$');

  return emailRegex.hasMatch(email);
}

bool validateIDNumber(String idnumber) {
  final RegExp idnumberRegex = RegExp(r'^\d{2}-\d{4}-\d{2}$');
  return idnumberRegex.hasMatch(idnumber);
}
