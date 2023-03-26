class NumberUtils {
  static double parseDouble(String source) {
    if (double.tryParse(source) != null) {
      return double.parse(source);
    }

    return 0;
  }
}
