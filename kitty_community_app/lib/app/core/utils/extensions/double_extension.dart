extension DoubleExtension on double {
  double? dividedBy(double? other) {
    if (other != null && other != 0) {
      return this / other;
    }
    return null;
  }
}