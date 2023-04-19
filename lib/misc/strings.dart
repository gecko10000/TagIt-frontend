extension StringMethods on String {
  String toTitleCase() {
    final output = StringBuffer();
    bool wasSpace = true;
    for (int i = 0; i < length; i++) {
      output.write((wasSpace ? this[i].toUpperCase : this[i].toLowerCase)());
      wasSpace = this[i] == ' ';
    }
    return output.toString();
  }
}
