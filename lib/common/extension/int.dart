import 'dart:math';

extension MyInt on int {
  // converts the number of bytes into a
  // readable representation.
  // ex:
  // 551 -> 551B
  // 1693 -> 1.6kB
  // 62853 -> 62kB
  // 999999 -> 999kB
  // 6838134 -> 6.8MB

  // possible TODO: make 3-digit ones (maybe over 500?) show the next one
  // i.e. (700kB -> 0.7MB instead)
  String readableFileSize() {
    const prefixes = ["", "k", "M", "G", "T"];
    int i = 0;
    for (int copy = this; copy > 0; copy ~/= 1000) {
      i++;
    }
    // < 1000 means i is 1, < 1m means i is 2, etc.
    // base case, `this` == 0 and i would be -1
    // if someone gets i past 4, good for them
    // "yes sir, i categorize petabyte-large files sir,
    // please fix this issue where it's only displaying terabytes"
    i = max(0, min(4, i - 1));
    if (i == 0) {
      return "$this B";
    }
    // we create the divisor for the value.
    final divisor = pow(10, 3 * i);
    // if we have a single digit,
    // we replace it to show the next layer down.
    final num value;
    if (this ~/ divisor < 10) {
      // first, divide by a magnitude less than `divisor`.
      // then, floating point division to keep the decimal
      value = (this ~/ (divisor ~/ 10)) / 10;
    } else {
      value = this ~/ divisor;
    }
    return "$value ${prefixes[i]}B";
  }
}
